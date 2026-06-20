import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/language_dropdown.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
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
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  int currentPage = 0;
  CancelToken? token;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<RamcharitmanasBloc>(context).add(const FetchRamcharitmanasInfo());
    initCurrentVerse();
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
              subtitle: widget.kand,
              body: RetryAgain(
                onRetry: () => BlocProvider.of<RamcharitmanasBloc>(context).add(const FetchRamcharitmanasInfo()),
                error: state.getError(forr: Httpstates.RAMCHARITMANAS_INFO)?.message ?? 'Could not load',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: widget.kand, body: const AppLoader());
        }

        final total = state.totalVersesInKand(widget.kand) ?? 0;
        final languages = info.versesTranslationLanguages;
        return AppScaffold(
          title: 'Ramcharitmanas',
          subtitle: widget.kand,
          actions: [
            IconButton(onPressed: fontSize <= 14 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
            IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
          ],
          bottom: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: GoldLinearProgress(value: total > 0 ? (currentPage + 1) / total : 0),
          ),
          body: PageView.builder(
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: total,
            onPageChanged: (pageNo) => setState(() {
              currentPage = pageNo;
              _loadVerse(kand: widget.kand, verseNo: pageNo + 1, lang: lang);
            }),
            itemBuilder: (context, index) {
              final verse = state.getVerse(kand: widget.kand, verseNo: index + 1, lang: lang);
              if (verse == null) {
                if (state.isError(forr: Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)) {
                  return RetryAgain(onRetry: initCurrentVerse, error: state.getError(forr: Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)!.message);
                }
                return const AppLoader();
              }
              final contentId = RamcharitmanasState.commentForId(kand: widget.kand, verseNo: index + 1, lang: lang ?? RamcharitmanasState.defaultLang);
              return VersePage(
                header: languages.isEmpty
                    ? null
                    : LanguageDropdown(
                        languages: languages,
                        value: lang ?? RamcharitmanasState.defaultLang,
                        onChanged: (value) => setState(() {
                          lang = value;
                          _loadVerse(kand: widget.kand, verseNo: index + 1, lang: value);
                        }),
                      ),
                verseLabel: 'पद ${index + 1} / $total',
                text: verse.text,
                fontSize: fontSize,
                contentId: contentId,
                shareText: "${verse.text}\n\n— Ramcharitmanas | ${widget.kand}, Verse ${index + 1}\n\nRead on Bhakti Bhoomi",
                contentType: 'ramcharitmanas',
              );
            },
          ),
        );
      },
    );
  }

  void initCurrentVerse() => _loadVerse(kand: widget.kand, verseNo: currentPage + 1, lang: lang);

  void _loadVerse({required String kand, required int verseNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasVerseByKandaAndVerseNo(kanda: kand, verseNo: verseNo, lang: lang, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RamcharitmanasState.commentForId(kand: kand, verseNo: verseNo, lang: lang ?? RamcharitmanasState.defaultLang)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
