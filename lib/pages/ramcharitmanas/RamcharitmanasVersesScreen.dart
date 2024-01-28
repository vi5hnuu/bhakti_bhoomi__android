import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RamcharitmanasVersesScreen extends StatefulWidget {
  final String title;
  final String kand;
  const RamcharitmanasVersesScreen({super.key, required this.title, required this.kand});

  @override
  State<RamcharitmanasVersesScreen> createState() => _RamcharitmanasVersesScreenState();
}

class _RamcharitmanasVersesScreenState extends State<RamcharitmanasVersesScreen> {
  final pageStorageKey = const PageStorageKey('ramcharitmanas-kand-verses');
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  CancelToken? token;

  @override
  initState() {
    super.initState();
    token = _loadVerse(kand: widget.kand, verseNo: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Ramcharitmanas'),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.info!.kandaInfo[widget.kand],
            itemBuilder: (context, index) {
              final verse = state.getVerse(kand: widget.kand, verseNo: index + 1, lang: lang);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: verse != null
                      ? Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                DropdownMenu(
                                  dropdownMenuEntries: state.info!.versesTranslationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                  initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                  onSelected: (value) => setState(() {
                                    if (!mounted) return;
                                    lang = value;
                                    token?.cancel("cancelled");
                                    token = _loadVerse(kand: widget.kand, verseNo: index + 1, lang: value);
                                  }),
                                ),
                                Text(verse!.text)
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
                          : const RefreshProgressIndicator(),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                print("token $token");
                token?.cancel("cancelled");
                token = _loadVerse(kand: widget.kand, verseNo: pageNo + 1, lang: lang);
              },
            ),
          )),
    );
  }

  CancelToken _loadVerse({required String kand, required int verseNo, String? lang}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasVerseByKandaAndVerseNo(kanda: kand, verseNo: verseNo, lang: lang, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
