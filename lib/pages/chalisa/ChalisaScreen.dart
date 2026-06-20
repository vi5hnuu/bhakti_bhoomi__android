import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChalisaScreen extends StatefulWidget {
  final String title;
  final String chalisaId;
  const ChalisaScreen({super.key, required this.title, required this.chalisaId});

  @override
  State<ChalisaScreen> createState() => _ChalisaScreenState();
}

class _ChalisaScreenState extends State<ChalisaScreen> {
  CancelToken token = CancelToken();

  @override
  void initState() {
    initChalisa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChalisaBloc, ChalisaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final chalisa = state.getChalisaById(chalisaId: widget.chalisaId);
        final loaded = !state.hasHttpState(forr: Httpstates.CHALISA_BY_ID) && state.allChalisa[widget.chalisaId] != null;
        return AppScaffold(
          title: 'Chalisa',
          subtitle: loaded ? state.allChalisa[widget.chalisaId]!.title : 'चालीसा',
          body: chalisa != null
              ? ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  children: chalisa.translations['hi']!['data']!
                      .map((verseGroup) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: AppCard(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              child: Column(
                                children: [
                                  Text(
                                    verseGroup.title.toUpperCase(),
                                    style: AppTypography.sectionLabel,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ...verseGroup.verses.map((verse) => Padding(
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
                          ))
                      .toList(),
                )
              : state.isError(forr: Httpstates.CHALISA_BY_ID)
                  ? RetryAgain(onRetry: initChalisa, error: state.getError(forr: Httpstates.CHALISA_BY_ID)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initChalisa() {
    BlocProvider.of<ChalisaBloc>(context).add(FetchChalisaById(id: widget.chalisaId, cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
