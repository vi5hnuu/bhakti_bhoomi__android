import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            title: Text('Mahabharat'),
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
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: shlok != null
                      ? Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              children: [Text(shlok.text)],
                            ),
                            const Positioned(
                              bottom: 45,
                              right: 15,
                              child: Column(
                                children: [
                                  IconButton(onPressed: null, icon: Icon(Icons.favorite_border, size: 36)),
                                  SizedBox(height: 10),
                                  IconButton(onPressed: null, icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                ],
                              ),
                            )
                          ],
                        )
                      : state.error != null
                          ? Center(child: Text(state.error!))
                          : const Center(child: CircularProgressIndicator()),
                ),
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

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
