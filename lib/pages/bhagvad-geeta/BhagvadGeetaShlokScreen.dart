import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BhagvadGeetaShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const BhagvadGeetaShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<BhagvadGeetaShlokScreen> createState() => _BhagvadGeetaShlokScreenState();
}

class _BhagvadGeetaShlokScreenState extends State<BhagvadGeetaShlokScreen> {
  final pageStorageKey = const PageStorageKey('bhagvadGeeta_shlok_screen');
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;

  @override
  initState() {
    super.initState();
    token = loadShlok(chapterNo: widget.chapterNo, shlokNo: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Bhagvad Geeta'),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.bhagvadGeetaChapters![widget.chapterNo].versesCount,
            itemBuilder: (context, index) {
              final shlok = state.getShlok(chapterNo: widget.chapterNo, shlokNo: index + 1);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ((state.isLoading || shlok == null) && state.error == null)
                      ? const RefreshProgressIndicator()
                      : state.error != null
                          ? Text(state.error!)
                          : Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [Text(shlok!.shlok)],
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
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                print("token $token");
                token?.cancel("cancelled");
                token = loadShlok(chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
              },
            ),
          )),
    );
  }

  CancelToken loadShlok({required int chapterNo, required int shlokNo}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<BhagvadGeetaBloc>(context).add(FetchBhagvadShlokByChapterNoShlokNo(chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
