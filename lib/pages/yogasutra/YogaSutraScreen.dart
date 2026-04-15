import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class YogaSutraScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const YogaSutraScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<YogaSutraScreen> createState() => _YogaSutraScreenState();
}

class _YogaSutraScreenState extends State<YogaSutraScreen> {
  final pageStorageKey = const PageStorageKey('ramcharitmanas-kand-verses');
  final PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;
  String? lang;
  CancelToken? token;
  double fontSize = 16;

  @override
  initState() {
    loadCurrentSutra();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YogaSutraBloc, YogaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'YogaSutra | chapter No ${widget.chapterNo}',
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
                value: state.yogaSutraInfo!.totalSutra.length > 0
                    ? (currentPage + 1) / state.yogaSutraInfo!.totalSutra.length
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
            itemCount: state.yogaSutraInfo!.totalSutra.length,
            itemBuilder: (context, index) {
              final sutra = state.getSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: lang);
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
                                    dropdownMenuEntries: state.yogaSutraInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                    initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                    onSelected: (value) => setState(() {
                                      if (!mounted) return;
                                      lang = value;
                                      _loadSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: value);
                                    }),
                                    label: 'select language',
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    sutra.sutra.values.first,
                                    style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: fontSize),
                                  )))
                                ],
                              ),
                              Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: BlocBuilder<LikeBloc, LikeState>(
                                    builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                    builder: (ctx, bookmarkState) {
                                      final contentId = YogaSutraState.commentForId(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: lang ?? YogaSutraState.defaultLanguage);
                                      final bookmarked = bookmarkState.isBookmarked(contentId);
                                      return EngageActions(
                                        isBookmarked: bookmarked,
                                        isLiked: likeState.isLiked(contentId),
                                        onBookmark: () => requireAuth(context, () {
                                          if (bookmarked) {
                                            final bid = bookmarkState.bookmarkIdFor(contentId);
                                            if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                          } else {
                                            ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'yoga_sutra'));
                                          }
                                        }),
                                        onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                          ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                        }),
                                        onShare: () async {
                                          final result = await Share.share("${sutra.sutra.values.first}\n\n— Yoga Sutra ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi");
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
                        : state.isError(forr: Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)
                            ? Center(
                                child: Text(state.getError(forr: Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)!.message),
                              )
                            : Center(
                                child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                              ))),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
                currentPage=pageNo;
                _loadSutra(chapterNo: widget.chapterNo, sutraNo: pageNo + 1, lang: lang);
              },
            ),
          )),
    );
  }

  _showNotImplementedMessage() {
    NotificationService.showSnackbar(text: "Feature will available in next update...", color: Colors.orange);
  }

  void loadCurrentSutra() {
    _loadSutra(chapterNo: widget.chapterNo, sutraNo: currentPage+1, lang: lang);
  }

  void _loadSutra({required int chapterNo, required int sutraNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraByChapterNoSutraNo(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: YogaSutraState.commentForId(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang ?? YogaSutraState.defaultLanguage)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
