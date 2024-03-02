import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  CancelToken? token;

  @override
  initState() {
    token = loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: 1);
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
                        padding: const EdgeInsets.all(8),
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
                              child: Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                elevation: 1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () => this._showNotImplementedMessage(),
                                          tooltip: 'Like',
                                          selectedIcon: Icon(Icons.favorite, size: 36),
                                          isSelected: true,
                                          icon: Icon(Icons.favorite_border, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(
                                          onPressed: () =>
                                              onComment(context: context, commentFormId: MahabharatState.commentForId(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1)),
                                          icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(
                                        onPressed: () => this._showNotImplementedMessage(),
                                        icon: Icon(Icons.bookmark_border, size: 36),
                                        tooltip: 'bookmark',
                                        color: Colors.blue,
                                        selectedIcon: Icon(Icons.bookmark_added_sharp, size: 36),
                                        isSelected: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.report_problem_outlined, size: 24)),
                            )
                          ],
                        ),
                      )
                    : state.error != null
                        ? Center(child: Text(state.error!))
                        : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              if (!mounted) return;
              token?.cancel("cancelled");
              token = loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
            }),
          )),
    );
  }

  CancelToken loadShlok({required int bookNo, required int chapterNo, required int shlokNo}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatShlokByShlokNo(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: cancelToken));
    return cancelToken;
  }

  _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "Feature will available in next update...", color: Colors.orange));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
