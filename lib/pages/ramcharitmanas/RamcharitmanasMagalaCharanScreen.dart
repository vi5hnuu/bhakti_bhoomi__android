import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../widgets/CustomDropDownMenu.dart';

class RamcharitmanasMangalacharanScreen extends StatefulWidget {
  final String title;
  final String kand;
  const RamcharitmanasMangalacharanScreen({super.key, required this.title, required this.kand});

  @override
  State<RamcharitmanasMangalacharanScreen> createState() => _RamcharitmanasMangalacharanScreenState();
}

class _RamcharitmanasMangalacharanScreenState extends State<RamcharitmanasMangalacharanScreen> {
  CancelToken? token;
  String? lang;

  @override
  initState() {
    loadCurrentLangMangalaCharan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mangalacharan = state.getMangalacharan(kand: widget.kand, lang: lang);

        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Ramcharitmanas | ${widget.kand} mangalacharan',
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: mangalacharan != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: CustomDropDownMenu(
                                label: 'Select Language',
                                initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                onSelected: _onLangSelected,
                                dropdownMenuEntries: state.info!.mangalacharanTranslationLanguages.entries
                                    .map((e) => CustomDropDownEntry(label: e.key, value: e.value, foreGroundColor: Theme.of(context).primaryColor))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                                child: SingleChildScrollView(
                              child: Text(
                                mangalacharan.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                              ),
                            ))
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
                                  IconButton(
                                      onPressed: () => this._showNotImplementedMessage(),
                                      tooltip: 'Like',
                                      selectedIcon: Icon(Icons.favorite, size: 36),
                                      isSelected: true,
                                      icon: const Icon(Icons.favorite_border, size: 36)),
                                  const SizedBox(height: 10),
                                  IconButton(
                                      onPressed: () => onComment(context: context, commentFormId: RamcharitmanasState.commentForId(kand: widget.kand, lang: lang ?? RamcharitmanasState.defaultLang)),
                                      icon: const Icon(Icons.mode_comment_outlined, size: 36)),
                                  const SizedBox(height: 10),
                                  IconButton(
                                    onPressed: () => this._showNotImplementedMessage(),
                                    icon: const Icon(Icons.bookmark_border, size: 36),
                                    tooltip: 'bookmark',
                                    color: Colors.blue,
                                    selectedIcon: const Icon(Icons.bookmark_added_sharp, size: 36),
                                    isSelected: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : state.isError(forr: Httpstates.RAMCHARITMANAS_ALL_MANGALACHARAN)
                    ? Center(
                        child: RetryAgain(onRetry: loadCurrentLangMangalaCharan,error: state.getError(forr: Httpstates.RAMCHARITMANAS_ALL_MANGALACHARAN)!),
                      )
                    : Center(
                        child: SpinKitThreeBounce(color: Theme.of(context).primaryColor),
                      ));
      },
    );
  }

  _onLangSelected(String? value) {
    setState(() {
      if (!mounted || value == null) return;
      lang = value;
      _loadLangMangalacharan(kand: widget.kand, lang: value);
    });
  }

  void loadCurrentLangMangalaCharan() {
    _loadLangMangalacharan(kand: widget.kand, lang: lang);
  }

  void _loadLangMangalacharan({required String kand, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasMangalacharanByKanda(kanda: kand, lang: lang, cancelToken: token));
  }

  _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "Feature will available in next update...", color: Colors.orange));
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    super.dispose();
  }
}
