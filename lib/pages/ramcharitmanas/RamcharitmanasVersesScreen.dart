import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
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
  int currentPage = 0;

  @override
  initState() {
    initCurrentVerse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Ramcharitmanas | ${widget.kand} Verses',
              style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
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
                                      _loadVerse(kand: widget.kand, verseNo: index + 1, lang: value);
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Text(
                                      verse.text,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                                    ),
                                  )),
                                  SizedBox(
                                    height: 24,
                                    child: (currentPage+1) < state.totalVersesInKand(widget.kand)! ? const Icon(Icons.drag_handle) : null,
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: EngageActions(
                                    onBookmark: () => {},
                                    onLike: () => {},
                                    onComment: () => onComment(
                                        context: context, commentFormId: RamcharitmanasState.commentForId(kand: widget.kand, verseNo: index + 1, lang: lang ?? RamcharitmanasState.defaultLang)),
                                  )),
                              Positioned(
                                top: 64,
                                right: 7,
                                child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: const Icon(Icons.report_problem_outlined, size: 24)),
                              )
                            ],
                          )
                        : state.isError(forr: Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)
                            ? Center(child: RetryAgain(onRetry: initCurrentVerse,error: state.getError(forr: Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)!))
                            : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor))),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: _onPageChanged,
          )),
    );
  }


  void initCurrentVerse() {
    _loadVerse(kand: widget.kand, verseNo: currentPage+1);
  }

  void _loadVerse({required String kand, required int verseNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasVerseByKandaAndVerseNo(kanda: kand, verseNo: verseNo, lang: lang, cancelToken: token));
  }

  _onPageChanged(pageNo) {
    setState(
      () {
        if (!mounted) return;
        currentPage = pageNo;
        _loadVerse(kand: widget.kand, verseNo: pageNo + 1, lang: lang);
      },
    );
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
