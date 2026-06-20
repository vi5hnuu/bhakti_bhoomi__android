import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class MantraScreen extends StatefulWidget {
  final String title;
  final String mantraId;
  const MantraScreen({super.key, required this.title, required this.mantraId});

  @override
  State<MantraScreen> createState() => _MantraScreenState();
}

class _MantraScreenState extends State<MantraScreen> {
  CancelToken token = CancelToken();

  @override
  void initState() {
    initMantraById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraBloc, MantraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mantra = state.getMantraById(mantraId: widget.mantraId);
        final loaded = !state.hasHttpState(forr: Httpstates.MANTRA_BY_ID) && mantra != null;
        return AppScaffold(
          title: 'Mantra',
          subtitle: loaded ? mantra.title : 'मंत्र',
          body: mantra != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(children: _getMantras(mantras: mantra.mantras)),
                )
              : state.isError(forr: Httpstates.MANTRA_BY_ID)
                  ? RetryAgain(onRetry: initMantraById, error: state.getError(forr: Httpstates.MANTRA_BY_ID)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  List<Widget> _getMantras({required List<MantraModel>? mantras, bool inner = false}) {
    if (mantras == null) return const [];
    return mantras
        .map((mantra) => Padding(
              padding: EdgeInsets.only(left: inner ? 16 : 0, bottom: 12),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.surfaceAlt),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    initiallyExpanded: !inner,
                    backgroundColor: AppColors.surface,
                    collapsedBackgroundColor: AppColors.surface,
                    iconColor: AppColors.terracotta,
                    collapsedIconColor: AppColors.terracotta,
                    childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                    title: Text(mantra.title, style: TextStyle(fontFamily: AppScript.familyFor(mantra.title), fontSize: 18, color: AppColors.ink)),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_hasDescription(mantra.description)) _section('Description', _bilingual(mantra.description['hi'], mantra.description['eng'])),
                      if (mantra.translations != null) _section('Translations', _bilingual(mantra.translations!['hi']?.join('\n'), mantra.translations!['eng']?.join('\n'))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () async {
                            final shareResult = await Share.share("${_getSharableText(mantra)} \n\n Read More : https://play.google.com/store/apps/details?id=com.vi5hnu.bhakti_bhoomi&hl=en-IN", subject: mantra.title);
                            if (shareResult.status == ShareResultStatus.success) {
                              NotificationService.showSnackbar(text: "Mantra shared successfully", color: Colors.green);
                            }
                          },
                          icon: const Icon(Icons.share_outlined, color: AppColors.terracotta),
                        ),
                      ),
                      ..._getMantras(mantras: mantra.subMantras, inner: true),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget _section(String label, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  List<Widget> _bilingual(String? hi, String? eng) {
    return [
      if (hi != null && hi.isNotEmpty) ...[
        Text('हिंदी', style: AppTypography.textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(hi, style: TextStyle(fontFamily: AppScript.familyFor(hi), fontSize: 15, height: 1.5, color: AppColors.ink)),
        const SizedBox(height: 10),
      ],
      if (eng != null && eng.isNotEmpty) ...[
        Text('English', style: AppTypography.textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(eng, style: AppTypography.textTheme.bodyMedium),
      ],
    ];
  }

  bool _hasDescription(Map<String, String> description) {
    return (description['hi'] != null && description['hi']!.isNotEmpty) || (description['eng'] != null && description['eng']!.isNotEmpty);
  }

  String _getSharableText(MantraModel mantra) {
    return "${mantra.title.trim()}\n\n${_hasDescription(mantra.description) ? "${mantra.description.values.join("\n")}\n\n" : ""}${mantra.translations?["hi"] != null ? "${mantra.translations?["hi"]?.join("\n")}\n\n" : ""}${mantra.translations?["eng"] != null ? "${mantra.translations?["eng"]?.join("\n")}\n\n" : ""}";
  }

  initMantraById() {
    BlocProvider.of<MantraBloc>(context).add(FetchMantraById(id: widget.mantraId, cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
