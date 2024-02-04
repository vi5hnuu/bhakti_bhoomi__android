import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  CancelToken? token;

  @override
  initState() {
    token = _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: 0, lang: lang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('brahmasutra'),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.brahmasutraInfo!.chaptersInfo['${widget.chapterNo}']!.totalSutras['${widget.quaterNo}'],
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
                                DropdownMenu(
                                  dropdownMenuEntries: state.brahmasutraInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                  initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                  onSelected: (value) => setState(() {
                                    if (!mounted) return;
                                    lang = value;
                                    token?.cancel("cancelled");
                                    token = _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index, lang: value);
                                  }),
                                ),
                                Text(sutra!.sutra.entries.toList()[1].value),
                              ],
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
                          : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                print("token $token");
                token?.cancel("cancelled");
                token = _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: pageNo, lang: lang);
              },
            ),
          )),
    );
  }

  CancelToken _loadSutra({required int chapterNo, required int quaterNo, required int sutraNo, String? lang}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<BrahmaSutraBloc>(context).add(FetchBrahmasutraByChapterNoQuaterNoSutraNo(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo, lang: lang, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
