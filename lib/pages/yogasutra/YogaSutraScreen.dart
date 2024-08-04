import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  int currentPage=0;
  String? lang;
  CancelToken? token;

  @override
  initState() {
    loadCurrentSutra();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YogaSutraBloc, YogaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'YogaSutra | chapter No ${widget.chapterNo}',
              style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 14, fontWeight: FontWeight.bold),
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
            itemCount: state.yogaSutraInfo!.totalSutra.length,
            itemBuilder: (context, index) {
              final sutra = state.getSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: lang);
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
                                    dropdownMenuEntries: state.yogaSutraInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                    initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                    onSelected: (value) => setState(() {
                                      if (!mounted) return;
                                      lang = value;
                                      _loadSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: value);
                                    }),
                                    label: 'select language',
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    sutra.sutra.values.first,
                                    style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                                  )))
                                ],
                              ),
                              Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: EngageActions(
                                    onBookmark: () => {},
                                    onLike: () => {},
                                    onComment: () => onComment(
                                        context: context, commentFormId: YogaSutraState.commentForId(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: lang ?? YogaSutraState.defaultLanguage)),
                                  )),
                            ],
                          )
                        : state.isError(forr: Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)
                            ? Center(
                                child: Text(state.getError(forr: Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)!),
                              )
                            : Center(
                                child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                              ))),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
                currentPage=pageNo;
                _loadSutra(chapterNo: widget.chapterNo, sutraNo: pageNo + 1, lang: lang);
              },
            ),
          )),
    );
  }

  _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "Feature will available in next update...", color: Colors.orange));
  }

  void loadCurrentSutra() {
    _loadSutra(chapterNo: widget.chapterNo, sutraNo: currentPage+1, lang: lang);
  }

  void _loadSutra({required int chapterNo, required int sutraNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraByChapterNoSutraNo(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang, cancelToken: token));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
