import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            title: Text(
              'Ramcharitmanas | ${widget.kand} Verses',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
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
            itemCount: state.totalVersesInKand(widget.kand),
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
                                  CustomDropDownMenu(
                                    label: 'Select Language',
                                    dropdownMenuEntries: state.info!.versesTranslationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                    initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                    onSelected: (value) => setState(() {
                                      if (!mounted) return;
                                      lang = value;
                                      token?.cancel("cancelled");
                                      token = _loadVerse(kand: widget.kand, verseNo: index + 1, lang: value);
                                    }),
                                  ),
                                  SizedBox(height: 12),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Text(
                                      verse.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                                    ),
                                  )),
                                  SizedBox(
                                    height: 24,
                                    child: _controller.page?.toInt() != null && (_controller.page!.toInt() + 1 < state.totalVersesInKand(widget.kand)!) ? Icon(Icons.drag_handle) : null,
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 45,
                                right: 15,
                                child: Column(
                                  children: [
                                    IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.favorite_border, size: 36)),
                                    SizedBox(height: 10),
                                    IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                    SizedBox(height: 10),
                                    IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.bookmark_border, size: 36)),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 64,
                                right: 7,
                                child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.report_problem_outlined, size: 24)),
                              )
                            ],
                          )
                        : state.error != null
                            ? Center(child: Text(state.error!))
                            : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor))),
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
