import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/guruGranthSahib/guru_granth_sahib_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class GuruGranthSahibRagaPartsScreen extends StatefulWidget {
  final String title;
  final int ragaNo;

  const GuruGranthSahibRagaPartsScreen({super.key, required this.ragaNo, required this.title});

  @override
  State<GuruGranthSahibRagaPartsScreen> createState() => _GuruGranthSahibRagaPartsScreenState();
}

class _GuruGranthSahibRagaPartsScreenState extends State<GuruGranthSahibRagaPartsScreen> {
  CancelToken cancelToken = CancelToken();
  int selectedPart=1;
  double fontSize=16;

  @override
  void initState() {
    initRaga(ragaNo: widget.ragaNo,partNo: selectedPart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuruGranthSahibBloc, GuruGranthSahibState>(
      buildWhen: (previous, current) => previous!=current,
      builder: (context, state) {
        final raga= state.getRaga(ragaNo: widget.ragaNo,partNo: selectedPart);
        final ragaInfo=state.getInfo()!.ragasInfo[widget.ragaNo-1];

        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Raga : ${widget.ragaNo} | Part $selectedPart",
                style: const TextStyle(color: Colors.white,
                    fontFamily: "Kalam",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(onPressed: fontSize <= 12 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
                IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
              ],
            ),
            body: raga != null
                ? Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: CustomDropDownMenu(
                              initialSelection: selectedPart.toString(),
                              onSelected: (value) => setState(() {
                                selectedPart = int.parse(value!);
                                initRaga(ragaNo: widget.ragaNo, partNo: selectedPart);
                              }),
                              label: "Select Part | ${raga.ragaName}",
                              dropdownMenuEntries: List.generate(ragaInfo.totalParts, (index) => DropdownMenuEntry(label: "Part ${index + 1}", value: (index + 1).toString())),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(left: 12, right: 72, bottom: 12, top: 0),
                              itemCount: raga.text.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(raga.text[index], style: TextStyle(fontSize: fontSize)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 45,
                        right: 15,
                        child: BlocBuilder<LikeBloc, LikeState>(
                          builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                          builder: (ctx, bookmarkState) {
                            final contentId = GuruGranthSahibState.commentForId(ragaNo: widget.ragaNo, partNo: selectedPart);
                            final bookmarked = bookmarkState.isBookmarked(contentId);
                            return EngageActions(
                              isBookmarked: bookmarked,
                              isLiked: likeState.isLiked(contentId),
                              onBookmark: () => requireAuth(context, () {
                                if (bookmarked) {
                                  final bid = bookmarkState.bookmarkIdFor(contentId);
                                  if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                } else {
                                  ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'guru_granth_sahib'));
                                }
                              }),
                              onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                              }),
                              onShare: () async {
                                final text = raga.text.take(3).join('\n');
                                final result = await Share.share("$text\n\n— Guru Granth Sahib, Raga ${widget.ragaNo} Part $selectedPart\n\nRead on Bhakti Bhoomi");
                                if (result.status == ShareResultStatus.success) {
                                  // shared
                                }
                              },
                              onComment: () => onComment(context: context, commentFormId: contentId),
                            );
                          },
                        )),
                      ),
                    ],
                  )
                : Center(
                    child: state.isError(forr: Httpstates.GURU_GRANTH_SAHIB_RAGA)
                        ? RetryAgain(onRetry: () => initRaga(ragaNo: widget.ragaNo, partNo: selectedPart), error: state.getError(forr: Httpstates.GURU_GRANTH_SAHIB_RAGA)!.message)
                        : SpinKitThreeBounce(color: Theme.of(context).primaryColor)));
      },
    );
  }

  initRaga({required int ragaNo,required int partNo}) {
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
    BlocProvider.of<GuruGranthSahibBloc>(context).add(FetchGuruGranthSahibRagaByRagaNoPartNo(ragaNo: ragaNo, partNo: partNo, cancelToken: cancelToken));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: GuruGranthSahibState.commentForId(ragaNo: ragaNo, partNo: partNo)));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
