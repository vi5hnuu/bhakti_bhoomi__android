import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String? lang;
  CancelToken? token;

  @override
  initState() {
    super.initState();
    token = _loadSutra(chapterNo: widget.chapterNo, sutraNo: 1, lang: lang);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YogaSutraBloc, YogaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Yoga Sutra'),
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
                  child: ((state.isLoading || sutra == null) && state.error == null)
                      ? const RefreshProgressIndicator()
                      : state.error != null
                          ? Text(state.error!)
                          : Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    DropdownMenu(
                                      dropdownMenuEntries: state.yogaSutraInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                      initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                      onSelected: (value) => setState(() {
                                        if (!mounted) return;
                                        lang = value;
                                        token = token = _loadSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: value);
                                      }),
                                    ),
                                    Text(sutra!.sutra.values.first)
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
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                print("token $token");
                token?.cancel("cancelled");
                token = _loadSutra(chapterNo: widget.chapterNo, sutraNo: pageNo + 1, lang: lang);
              },
            ),
          )),
    );
  }

  CancelToken _loadSutra({required int chapterNo, required int sutraNo, String? lang}) {
    token?.cancel("cancelled");
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraByChapterNoSutraNo(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
