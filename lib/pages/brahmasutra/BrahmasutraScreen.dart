import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/language_dropdown.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrahmasutraScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  final int quaterNo;
  const BrahmasutraScreen({super.key, required this.title, required this.chapterNo, required this.quaterNo});

  @override
  State<BrahmasutraScreen> createState() => _BrahmasutraScreenState();
}

class _BrahmasutraScreenState extends State<BrahmasutraScreen> {
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  int currentPage = 0;
  CancelToken? token;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<BrahmaSutraBloc>(context).add(const FetchBrahmasutraInfo());
    initCurrentSutr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.brahmasutraInfo;
        if (info == null) {
          if (state.isError(forr: Httpstates.BRAHMA_SUTRA_INFO)) {
            return AppScaffold(
              title: widget.title,
              subtitle: 'अध्याय ${widget.chapterNo}.${widget.quaterNo}',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<BrahmaSutraBloc>(context).add(const FetchBrahmasutraInfo()),
                error: state.getError(forr: Httpstates.BRAHMA_SUTRA_INFO)?.message ?? 'Could not load',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: 'अध्याय ${widget.chapterNo}.${widget.quaterNo}', body: const AppLoader());
        }

        final total = state.totalSutras(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo) ?? 0;
        final languages = info.translationLanguages;
        return AppScaffold(
          title: 'Brahma Sutra · ${widget.chapterNo}.${widget.quaterNo}',
          subtitle: 'ब्रह्मसूत्र',
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
              _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: pageNo, lang: lang);
            }),
            itemBuilder: (context, index) {
              final sutra = state.getBrahmaSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index, lang: lang);
              if (sutra == null) {
                if (state.isError(forr: Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO)) {
                  return RetryAgain(onRetry: initCurrentSutr, error: state.getError(forr: Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO)!.message);
                }
                return const AppLoader();
              }
              final contentId = BrahmaSutraState.commentForId(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index + 1, lang: lang ?? BrahmaSutraState.defaultLang);
              return VersePage(
                header: languages.isEmpty
                    ? null
                    : LanguageDropdown(
                        languages: languages,
                        value: lang ?? BrahmaSutraState.defaultLang,
                        onChanged: (value) => setState(() {
                          lang = value;
                          _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: index, lang: value);
                        }),
                      ),
                verseLabel: 'सूत्र ${index + 1} / $total',
                text: sutra.sutra.values.join("\n"),
                fontSize: fontSize,
                contentId: contentId,
                shareText: "${sutra.sutra.values.join("\n")}\n\n— Brahma Sutra ${widget.chapterNo}.${widget.quaterNo}.${index + 1}\n\nRead on Bhakti Bhoomi",
                contentType: 'brahmasutra',
              );
            },
          ),
        );
      },
    );
  }

  void initCurrentSutr() => _loadSutra(chapterNo: widget.chapterNo, quaterNo: widget.quaterNo, sutraNo: currentPage, lang: lang);

  void _loadSutra({required int chapterNo, required int quaterNo, required int sutraNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<BrahmaSutraBloc>(context).add(FetchBrahmasutraByChapterNoQuaterNoSutraNo(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo, lang: lang, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: BrahmaSutraState.commentForId(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo + 1, lang: lang ?? BrahmaSutraState.defaultLang)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
