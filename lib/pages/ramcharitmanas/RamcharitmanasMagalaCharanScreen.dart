import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/language_dropdown.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RamcharitmanasMangalacharanScreen extends StatefulWidget {
  final String title;
  final String kand;
  const RamcharitmanasMangalacharanScreen({super.key, required this.title, required this.kand});

  @override
  State<RamcharitmanasMangalacharanScreen> createState() => _RamcharitmanasMangalacharanScreenState();
}

class _RamcharitmanasMangalacharanScreenState extends State<RamcharitmanasMangalacharanScreen> {
  String? lang;
  CancelToken? token;
  double fontSize = 22;

  @override
  void initState() {
    BlocProvider.of<RamcharitmanasBloc>(context).add(const FetchRamcharitmanasInfo());
    loadCurrentLangMangalaCharan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.info;
        if (info == null) {
          if (state.isError(forr: Httpstates.RAMCHARITMANAS_INFO)) {
            return AppScaffold(
              title: widget.title,
              subtitle: '${widget.kand} · मंगलाचरण',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<RamcharitmanasBloc>(context).add(const FetchRamcharitmanasInfo()),
                error: state.getError(forr: Httpstates.RAMCHARITMANAS_INFO)?.message ?? 'Could not load',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: '${widget.kand} · मंगलाचरण', body: const AppLoader());
        }

        final mangalacharan = state.getMangalacharan(kand: widget.kand, lang: lang);
        final languages = info.mangalacharanTranslationLanguages;
        return AppScaffold(
          title: 'Mangalacharan',
          subtitle: widget.kand,
          actions: [
            IconButton(onPressed: fontSize <= 14 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
            IconButton(onPressed: fontSize >= 34 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
          ],
          body: mangalacharan == null
              ? (state.isError(forr: Httpstates.RAMCHARITMANAS_ALL_MANGALACHARAN)
                  ? RetryAgain(onRetry: loadCurrentLangMangalaCharan, error: state.getError(forr: Httpstates.RAMCHARITMANAS_ALL_MANGALACHARAN)!.message)
                  : const AppLoader())
              : VersePage(
                  header: languages.isEmpty
                      ? null
                      : LanguageDropdown(languages: languages, value: lang ?? RamcharitmanasState.defaultLang, onChanged: _onLangSelected),
                  verseLabel: 'मंगलाचरण',
                  text: mangalacharan.text,
                  fontSize: fontSize,
                  contentId: RamcharitmanasState.commentForId(kand: widget.kand, lang: lang ?? RamcharitmanasState.defaultLang),
                  shareText: "${mangalacharan.text}\n\n— Ramcharitmanas | ${widget.kand} Mangalacharan\n\nRead on Bhakti Bhoomi",
                  contentType: 'ramcharitmanas',
                ),
        );
      },
    );
  }

  void _onLangSelected(String? value) {
    setState(() {
      if (!mounted || value == null) return;
      lang = value;
      _loadLangMangalacharan(kand: widget.kand, lang: value);
      context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamcharitmanasState.commentForId(kand: widget.kand, lang: value)));
    });
  }

  void loadCurrentLangMangalaCharan() {
    _loadLangMangalacharan(kand: widget.kand, lang: lang);
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamcharitmanasState.commentForId(kand: widget.kand, lang: lang ?? RamcharitmanasState.defaultLang)));
  }

  void _loadLangMangalacharan({required String kand, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasMangalacharanByKanda(kanda: kand, lang: lang, cancelToken: token));
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    super.dispose();
  }
}
