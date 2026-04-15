import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class BrahmasutraScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  final int quaterNo;
  const BrahmasutraScreen({super.key, required this.title, required this.chapterNo, required this.quaterNo});

  @override
  State<BrahmasutraScreen> createState() => _BrahmasutraScreenState();
}

class _BrahmasutraScreenState extends State<BrahmasutraScreen> {
  final pageStorageKey = const PageStorageKey('brahmasutra');
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  int currentPage = 0;
  CancelToken? token;
  double fontSize = 16;

  @override
  initState() {
    initCurrentSutr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Brahmasutra | chapter ${widget.chapterNo} | quater | ${widget.quaterNo}',
              style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 14, fontWeight: FontWeight.bold),
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
                value: (state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo) ?? 0) > 0
                    ? (currentPage + 1) / state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo)!
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
            itemCount: state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo),
            itemBuilder: (context, index) {
              final sutra = state.getBrahmaSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index, lang: lang);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: sutra != null
                      ? Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CustomDropDownMenu(
                                  dropdownMenuEntries: state.brahmasutraInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                  initialSelection: lang ?? BrahmaSutraState.defaultLang,
                                  onSelected: (value) => setState(() {
                                    if (!mounted) return;
                                    lang = value;
                                    _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index, lang: value);
                                  }),
                                  label: 'select language',
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: sutra.sutra.entries
                                        .map((e) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                e.value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: fontSize),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )),
                                SizedBox(
                                  height: 24,
                                  child: (index + 1 < state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo)!) ? const Icon(Icons.drag_handle) : null,
                                ),
                              ],
                            ),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: BlocBuilder<LikeBloc, LikeState>(
                                  builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                  builder: (ctx, bookmarkState) {
                                    final contentId = BrahmaSutraState.commentForId(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index + 1, lang: lang ?? BrahmaSutraState.defaultLang);
                                    final bookmarked = bookmarkState.isBookmarked(contentId);
                                    return EngageActions(
                                      isBookmarked: bookmarked,
                                      isLiked: likeState.isLiked(contentId),
                                      onBookmark: () => requireAuth(context, () {
                                        if (bookmarked) {
                                          final bid = bookmarkState.bookmarkIdFor(contentId);
                                          if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                        } else {
                                          ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'brahmasutra'));
                                        }
                                      }),
                                      onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                        ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                      }),
                                      onShare: () async {
                                        final result = await Share.share("${sutra.sutra.values.join("\n")}\n\n— Brahma Sutra ${widget.chapterNo}.${widget.quaterNo}.${index + 1}\n\nRead on Bhakti Bhoomi");
                                        if (result.status == ShareResultStatus.success) {
                                          NotificationService.showSnackbar(text: "Sutra shared successfully", color: Colors.green);
                                        }
                                      },
                                      onComment: () => onComment(context: context, commentFormId: contentId),
                                    );
                                  },
                                ))),
                          ],
                        )
                      : state.isError(forr: Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO)
                          ? Center(child: Text(state.getError(forr: Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO)!.message))
                          : Center(
                              child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              currentPage=pageNo;
              _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: pageNo, lang: lang);
              },
            ),
          )),
    );
  }

  void initCurrentSutr() {
    _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: 0, lang: lang);
  }

  void _loadSutra({required int chapterNo, required int quaterNo, required int sutraNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<BrahmaSutraBloc>(context).add(FetchBrahmasutraByChapterNoQuaterNoSutraNo(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo, lang: lang, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: BrahmaSutraState.commentForId(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo + 1, lang: lang ?? BrahmaSutraState.defaultLang)));
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
