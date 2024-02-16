import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
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
            title: Text(
              'Brahmasutra | chapter ${widget.chapterNo} | quater | ${widget.quaterNo}',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 14, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo),
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
                                CustomDropDownMenu(
                                  dropdownMenuEntries: state.brahmasutraInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                  initialSelection: lang ?? BrahmaSutraState.defaultLang,
                                  onSelected: (value) => setState(() {
                                    if (!mounted) return;
                                    lang = value;
                                    token?.cancel("cancelled");
                                    token = _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index, lang: value);
                                  }),
                                  label: 'select language',
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: sutra.sutra.entries
                                        .map((e) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                                e.value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                                              ),
                                        ))
                                        .toList(),
                                  ),
                                )),
                                SizedBox(
                                  height: 24,
                                  child: (index + 1 < state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo)!) ? Icon(Icons.drag_handle) : null,
                                ),
                              ],
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
                                      IconButton(onPressed: null, tooltip: 'Like', selectedIcon: Icon(Icons.favorite, size: 36), isSelected: true, icon: Icon(Icons.favorite_border, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(onPressed: null, icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(
                                        onPressed: () => null,
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
                          ],
                        )
                      : state.error != null
                          ? Center(child: Text(state.error!))
                          : Center(
                              child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
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
