import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/language_dropdown.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YogaSutraScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const YogaSutraScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<YogaSutraScreen> createState() => _YogaSutraScreenState();
}

class _YogaSutraScreenState extends State<YogaSutraScreen> {
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;
  int currentPage = 0;
  double fontSize = 20;
  String? lang;

  @override
  void initState() {
    BlocProvider.of<YogaSutraBloc>(context).add(const FetchYogasutraInfo());
    loadCurrentSutra();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YogaSutraBloc, YogaSutraState>(
      builder: (context, state) {
        final info = state.yogaSutraInfo;
        if (info == null) {
          if (state.isError(forr: Httpstates.YOGASUTRA_INFO)) {
            return AppScaffold(
              title: widget.title,
              subtitle: 'अध्याय ${widget.chapterNo}',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<YogaSutraBloc>(context).add(const FetchYogasutraInfo()),
                error: state.getError(forr: Httpstates.YOGASUTRA_INFO)?.message ?? 'Could not load',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: 'अध्याय ${widget.chapterNo}', body: const AppLoader());
        }

        final total = info.totalSutra.length;
        final languages = info.translationLanguages;
        return AppScaffold(
          title: 'Yoga Sutra · Ch ${widget.chapterNo}',
          subtitle: 'योगसूत्र',
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
              _loadSutra(chapterNo: widget.chapterNo, sutraNo: pageNo + 1, lang: lang);
            }),
            itemBuilder: (context, index) {
              final sutra = state.getSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: lang);
              if (sutra == null) {
                if (state.isError(forr: Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)) {
                  return RetryAgain(onRetry: loadCurrentSutra, error: state.getError(forr: Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)!.message);
                }
                return const AppLoader();
              }
              final contentId = YogaSutraState.commentForId(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: lang ?? YogaSutraState.defaultLanguage);
              return VersePage(
                header: languages.isEmpty
                    ? null
                    : LanguageDropdown(
                        languages: languages,
                        value: lang ?? YogaSutraState.defaultLanguage,
                        onChanged: (value) => setState(() {
                          lang = value;
                          _loadSutra(chapterNo: widget.chapterNo, sutraNo: index + 1, lang: value);
                        }),
                      ),
                verseLabel: 'सूत्र ${index + 1} / $total',
                text: sutra.sutra.values.first,
                fontSize: fontSize,
                contentId: contentId,
                shareText: "${sutra.sutra.values.first}\n\n— Yoga Sutra ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi",
                contentType: 'yoga_sutra',
              );
            },
          ),
        );
      },
    );
  }

  void loadCurrentSutra() => _loadSutra(chapterNo: widget.chapterNo, sutraNo: currentPage + 1, lang: lang);

  void _loadSutra({required int chapterNo, required int sutraNo, String? lang}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraByChapterNoSutraNo(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: YogaSutraState.commentForId(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang ?? YogaSutraState.defaultLanguage)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
