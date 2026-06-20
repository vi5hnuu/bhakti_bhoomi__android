import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RigvedaSuktaScreen extends StatefulWidget {
  final String title;
  final int mandala;

  const RigvedaSuktaScreen({super.key, required this.title, required this.mandala});

  @override
  State<RigvedaSuktaScreen> createState() => _RigvedaSuktaScreenState();
}

class _RigvedaSuktaScreenState extends State<RigvedaSuktaScreen> {
  final PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;
  CancelToken? token;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<RigvedaBloc>(context).add(const FetchRigvedaInfo());
    loadCurrentSukta();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RigvedaBloc, RigvedaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.rigvedaInfo;
        if (info == null) {
          if (state.isError(forr: Httpstates.RIGVEDA_INFO)) {
            return AppScaffold(
              title: widget.title,
              subtitle: 'मण्डल ${widget.mandala}',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<RigvedaBloc>(context).add(const FetchRigvedaInfo()),
                error: state.getError(forr: Httpstates.RIGVEDA_INFO)?.message ?? 'Could not load',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: 'मण्डल ${widget.mandala}', body: const AppLoader());
        }

        // mandalaInfo is keyed by String mandala number.
        final total = info.mandalaInfo['${widget.mandala}'] ?? 0;
        return AppScaffold(
          title: 'Rig Veda · Mandala ${widget.mandala}',
          subtitle: 'ऋग्वेद',
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
              _loadSukta(mandala: widget.mandala, suktaNo: pageNo + 1);
            }),
            itemBuilder: (context, index) {
              final sukta = state.getSukta(mandala: widget.mandala, suktaNo: index + 1);
              if (sukta == null) {
                if (state.isError(forr: Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA)) {
                  return RetryAgain(onRetry: loadCurrentSukta, error: state.getError(forr: Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA)!.message);
                }
                return const AppLoader();
              }
              final contentId = RigvedaState.commentForId(mandala: widget.mandala, suktaNo: index + 1);
              return VersePage(
                verseLabel: 'सूक्त ${index + 1} / $total',
                text: sukta.text,
                fontSize: fontSize,
                contentId: contentId,
                shareText: "${sukta.text}\n\n— Rig Veda, Mandala ${widget.mandala}, Sukta ${index + 1}\n\nRead on Bhakti Bhoomi",
                contentType: 'rigveda',
              );
            },
          ),
        );
      },
    );
  }

  void loadCurrentSukta() => _loadSukta(mandala: widget.mandala, suktaNo: currentPage + 1);

  void _loadSukta({required int mandala, required int suktaNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RigvedaBloc>(context).add(FetchVerseByMandalaSukta(mandalaNo: mandala, suktaNo: suktaNo, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RigvedaState.commentForId(mandala: mandala, suktaNo: suktaNo)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
