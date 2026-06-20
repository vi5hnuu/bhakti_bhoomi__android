import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/language_dropdown.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValmikiRamayanShlokScreen extends StatefulWidget {
  final String title;
  final String kand;
  final int sargaNo;
  const ValmikiRamayanShlokScreen({super.key, required this.title, required this.kand, required this.sargaNo});

  @override
  State<ValmikiRamayanShlokScreen> createState() => _ValmikiRamayanShlokScreenState();
}

class _ValmikiRamayanShlokScreenState extends State<ValmikiRamayanShlokScreen> {
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  int currentPage = 0;
  CancelToken? cancelToken;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<RamayanBloc>(context).add(const FetchRamayanInfo());
    loadCurrentShlok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final total = state.totalShlokInSarga(kand: widget.kand, sargaNo: widget.sargaNo, lang: lang) ?? 0;
        final languages = state.ramayanInfo?.translationLanguages ?? const {};
        return AppScaffold(
          title: 'Valmiki Ramayan',
          subtitle: '${widget.kand} · सर्ग ${widget.sargaNo}',
          actions: [
            IconButton(onPressed: fontSize <= 14 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
            IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
          ],
          bottom: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: GoldLinearProgress(value: total > 0 ? (currentPage + 1) / total : 0),
          ),
          body: total == 0
              ? const AppLoader()
              : PageView.builder(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
                  scrollDirection: Axis.vertical,
                  itemCount: total,
                  onPageChanged: (pageNo) => setState(() {
                    currentPage = pageNo;
                    _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: pageNo + 1, lang: lang);
                  }),
                  itemBuilder: (context, index) {
                    final shlok = state.getShlok(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: lang);
                    if (shlok == null) {
                      if (state.isError(forr: Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO)) {
                        return RetryAgain(onRetry: loadCurrentShlok, error: state.getError(forr: Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO)!.message);
                      }
                      return const AppLoader();
                    }
                    final contentId = RamayanState.commentForId(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: lang ?? RamayanState.defaultLanguage);
                    return VersePage(
                      header: languages.isEmpty
                          ? null
                          : LanguageDropdown(
                              languages: languages,
                              value: lang ?? RamayanState.defaultLanguage,
                              onChanged: (value) => setState(() {
                                lang = value;
                                _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: value);
                              }),
                            ),
                      verseLabel: 'श्लोक ${index + 1} / $total',
                      text: shlok.shlok,
                      fontSize: fontSize,
                      contentId: contentId,
                      shareText: "${shlok.shlok}\n\n— Valmiki Ramayan | ${widget.kand}, Sarga ${widget.sargaNo}:${index + 1}\n\nRead on Bhakti Bhoomi",
                      contentType: 'ramayan',
                    );
                  },
                ),
        );
      },
    );
  }

  void loadCurrentShlok() => _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: currentPage + 1, lang: lang);

  void _loadShlok({required String kand, required int sargaNo, required int shlokNo, String? lang}) {
    cancelToken?.cancel("cancelled");
    cancelToken = CancelToken();
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanShlokByKandSargaNoShlokNo(kanda: kand, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang, cancelToken: cancelToken));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamayanState.commentForId(kanda: kand, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang ?? RamayanState.defaultLanguage)));
  }

  @override
  void dispose() {
    _controller.dispose();
    cancelToken?.cancel("cancelled");
    super.dispose();
  }
}
