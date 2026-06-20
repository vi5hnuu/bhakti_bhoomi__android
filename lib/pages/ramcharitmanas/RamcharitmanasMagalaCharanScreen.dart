import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/CustomDropDownMenu.dart';

class RamcharitmanasMangalacharanScreen extends StatefulWidget {
  final String title;
  final String kand;
  const RamcharitmanasMangalacharanScreen({super.key, required this.title, required this.kand});

  @override
  State<RamcharitmanasMangalacharanScreen> createState() => _RamcharitmanasMangalacharanScreenState();
}

class _RamcharitmanasMangalacharanScreenState extends State<RamcharitmanasMangalacharanScreen> {
  CancelToken? token;
  String? lang;

  @override
  initState() {
    loadCurrentLangMangalaCharan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mangalacharan = state.getMangalacharan(kand: widget.kand, lang: lang);

        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Ramcharitmanas | ${widget.kand} mangalacharan',
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: mangalacharan != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: CustomDropDownMenu(
                                label: 'Select Language',
                                initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                onSelected: _onLangSelected,
                                dropdownMenuEntries: state.info!.mangalacharanTranslationLanguages.entries
                                    .map((e) => CustomDropDownEntry(label: e.key, value: e.value, foreGroundColor: Theme.of(context).primaryColor))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                                child: SingleChildScrollView(
                              child: Text(
                                mangalacharan.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                              ),
                            ))
                          ],
                        ),
                        Positioned(
                          bottom: 45,
                          right: 15,
                          child: BlocBuilder<LikeBloc, LikeState>(
                            builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                              builder: (ctx, bookmarkState) {
                                final contentId = RamcharitmanasState.commentForId(kand: widget.kand, lang: lang ?? RamcharitmanasState.defaultLang);
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
                                    final result = await Share.share("${mangalacharan!.text}\n\n— Ramcharitmanas | ${widget.kand} Mangalacharan\n\nRead on Bhakti Bhoomi");
                                    if (result.status == ShareResultStatus.success) {
                                      NotificationService.showSnackbar(text: "Mangalacharan shared successfully", color: Colors.green);
                                    }
                                  },
                                  onComment: () => onComment(context: context, commentFormId: contentId),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : state.isError(forr: Httpstates.RAMCHARITMANAS_ALL_MANGALACHARAN)
                    ? Center(
                        child: RetryAgain(onRetry: loadCurrentLangMangalaCharan,error: state.getError(forr: Httpstates.RAMCHARITMANAS_ALL_MANGALACHARAN)!.message),
                      )
                    : Center(
                        child: SpinKitThreeBounce(color: Theme.of(context).primaryColor),
                      ));
      },
    );
  }

  _onLangSelected(String? value) {
    setState(() {
      if (!mounted || value == null) return;
      lang = value;
      _loadLangMangalacharan(kand: widget.kand, lang: value);
      context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamcharitmanasState.commentForId(kand: widget.kand, lang: value)));
    });
  }

  void loadCurrentLangMangalaCharan() {
    _loadLangMangalacharan(kand: widget.kand, lang: lang);
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamcharitmanasState.commentForId(kand: widget.kand, lang: lang ?? RamcharitmanasState.defaultLang)));
  }

  void _loadLangMangalacharan({required String kand, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasMangalacharanByKanda(kanda: kand, lang: lang, cancelToken: token));
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    super.dispose();
  }
}
