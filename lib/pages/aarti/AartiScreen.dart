import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AartiScreen extends StatefulWidget {
  final String title;
  final String aartiId;

  const AartiScreen({super.key, required this.aartiId, required this.title});

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initAarti();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AartiBloc, AartiState>(
      builder: (context, state) {
        final aarti = state.getAarti(widget.aartiId);
        return AppScaffold(
          title: 'Aarti',
          subtitle: aarti?.title ?? 'आरती',
          body: aarti != null
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  itemCount: aarti.verses.length,
                  itemBuilder: (context, index) {
                    final lines = aarti.verses[index];
                    final isRefrain = index == 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AppCard(
                        color: isRefrain ? AppColors.surface : AppColors.page,
                        borderColor: isRefrain ? AppColors.gold : AppColors.surfaceAlt,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: Column(
                          children: [
                            if (isRefrain) ...[const SectionLabel('टेक · refrain'), const SizedBox(height: 10)],
                            ...lines.map((verse) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    verse,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppScript.familyFor(verse),
                                      fontSize: 18,
                                      height: 1.6,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : state.isError(forr: Httpstates.AARTIS)
                  ? RetryAgain(onRetry: initAarti, error: state.getError(forr: Httpstates.AARTIS)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initAarti() {
    BlocProvider.of<AartiBloc>(context).add(FetchAartiEvent(aartiId: widget.aartiId, cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
