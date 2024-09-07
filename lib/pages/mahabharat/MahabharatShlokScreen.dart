import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class MahabharatShlokScreen extends StatefulWidget {
  final String title;
  final int bookNo;
  final int chapterNo;
  const MahabharatShlokScreen({super.key, required this.title, required this.bookNo, required this.chapterNo});

  @override
  State<MahabharatShlokScreen> createState() => _MahabharatShlokScreenState();
}

class _MahabharatShlokScreenState extends State<MahabharatShlokScreen> {
  final pageStorageKey = const PageStorageKey('mahabharat_shlok_screen');
  final PageController _controller = PageController(initialPage: 0);
  int currentPage=0;
  CancelToken? token;

  @override
  initState() {
    loadCurrentShlok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MahabharatBloc, MahabharatState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title:
                Text('Mahabharat | Book No - ${widget.bookNo} | Chapter No ${widget.chapterNo}', style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.totalVerses(bookNo: widget.bookNo, chapterNo: widget.chapterNo),
            itemBuilder: (context, index) {
              final shlok = state.getShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1);
              return Center(
                child: shlok != null
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(shlok.text)],
                            ),
                            Positioned(
                              bottom: 45,
                              right: 15,
                              child: EngageActions(
                                onShare: () async {
                                  ShareResult shareResult = await Share.share("${shlok.text} https://play.google.com/store/apps/details?id=com.vi5hnu.bhakti_bhoomi&hl=en-IN", subject: "Mahabharat Shlok", sharePositionOrigin: const Rect.fromLTWH(0, 0, 0, 0));
                                  if (shareResult.status == ShareResultStatus.success) {
                                    NotificationService.showSnackbar(text: "shlok shared successfully",color: Colors.green);
                                  }
                                },
                                onComment: () => onComment(context: context, commentFormId: MahabharatState.commentForId(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1)),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: const Icon(Icons.report_problem_outlined, size: 24)),
                            )
                          ],
                        ),
                      )
                    : state.isError(forr: Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)
                        ? Center(child: RetryAgain(onRetry: loadCurrentShlok,error: state.getError(forr: Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)!.message))
                        : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              if (!mounted) return;
              currentPage=pageNo;
              loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
            }),
          )),
    );
  }

  loadCurrentShlok(){
    loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: currentPage+1);
  }

  void loadShlok({required int bookNo, required int chapterNo, required int shlokNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatShlokByShlokNo(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: token));
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
