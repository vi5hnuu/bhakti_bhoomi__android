import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RamcharitmanasVersesScreen extends StatefulWidget {
  final String title;
  final String kand;
  const RamcharitmanasVersesScreen({super.key, required this.title, required this.kand});

  @override
  State<RamcharitmanasVersesScreen> createState() => _RamcharitmanasVersesScreenState();
}

class _RamcharitmanasVersesScreenState extends State<RamcharitmanasVersesScreen> {
  final pageStorageKey = const PageStorageKey('ramcharitmanas-kand-verses');
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  CancelToken? token;
  int currentPage = 0;
  double fontSize = 16;

  @override
  initState() {
    initCurrentVerse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Ramcharitmanas | ${widget.kand} Verses',
              style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(onPressed: fontSize <= 12 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
              IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: LinearProgressIndicator(
                value: (state.totalVersesInKand(widget.kand) ?? 0) > 0
                    ? (currentPage + 1) / state.totalVersesInKand(widget.kand)!
                    : 0,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
            ),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.totalVersesInKand(widget.kand),
            itemBuilder: (context, index) {
              final verse = state.getVerse(kand: widget.kand, verseNo: index + 1, lang: lang);
              return Center(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: verse != null
                        ? Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CustomDropDownMenu(
                                    label: 'Select Language',
                                    dropdownMenuEntries: state.info!.versesTranslationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                    initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                    onSelected: (value) => setState(() {
                                      if (!mounted) return;
                                      lang = value;
                                      _loadVerse(kand: widget.kand, verseNo: index + 1, lang: value);
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Text(
                                      verse.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: fontSize),
                                    ),
                                  )),
                                  SizedBox(
                                    height: 24,
                                    child: (currentPage+1) < state.totalVersesInKand(widget.kand)! ? const Icon(Icons.drag_handle) : null,
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: BlocBuilder<LikeBloc, LikeState>(
                                    builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                    builder: (ctx, bookmarkState) {
                                      final contentId = RamcharitmanasState.commentForId(kand: widget.kand, verseNo: index + 1, lang: lang ?? RamcharitmanasState.defaultLang);
                                      final bookmarked = bookmarkState.isBookmarked(contentId);
                                      return EngageActions(
                                        isBookmarked: bookmarked,
                                        isLiked: likeState.isLiked(contentId),
                                        onBookmark: () => requireAuth(context, () {
                                          if (bookmarked) {
                                            final bid = bookmarkState.bookmarkIdFor(contentId);
                                            if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                          } else {
                                            ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'ramcharitmanas'));
                                          }
                                        }),
                                        onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                          ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                        }),
                                        onShare: () async {
                                          final result = await Share.share("${verse.text}\n\n— Ramcharitmanas | ${widget.kand}, Verse ${index + 1}\n\nRead on Bhakti Bhoomi");
                                          if (result.status == ShareResultStatus.success) {
                                            NotificationService.showSnackbar(text: "Verse shared successfully", color: Colors.green);
                                          }
                                        },
                                        onComment: () => onComment(context: context, commentFormId: contentId),
                                      );
                                    },
                                  ))),
                              Positioned(
                                top: 64,
                                right: 7,
                                child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: const Icon(Icons.report_problem_outlined, size: 24)),
                              )
                            ],
                          )
                        : state.isError(forr: Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)
                            ? Center(child: RetryAgain(onRetry: initCurrentVerse,error: state.getError(forr: Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)!.message))
                            : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor))),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: _onPageChanged,
          )),
    );
  }


  void initCurrentVerse() {
    _loadVerse(kand: widget.kand, verseNo: currentPage+1);
  }

  void _loadVerse({required String kand, required int verseNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasVerseByKandaAndVerseNo(kanda: kand, verseNo: verseNo, lang: lang, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamcharitmanasState.commentForId(kand: kand, verseNo: verseNo, lang: lang ?? RamcharitmanasState.defaultLang)));
  }

  _onPageChanged(pageNo) {
    setState(
      () {
        if (!mounted) return;
        currentPage = pageNo;
        _loadVerse(kand: widget.kand, verseNo: pageNo + 1, lang: lang);
      },
    );
  }

  _showNotImplementedMessage() {
    NotificationService.showSnackbar(text: "Feature will available in next update...", color: Colors.orange);
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
