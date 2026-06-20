import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bhakti_bhoomi/state/vratkatha/vratKatha_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VratKathaScreen extends StatefulWidget {
  final String title;
  final String kathaId;

  const VratKathaScreen({super.key, required this.kathaId, required this.title});

  @override
  State<VratKathaScreen> createState() => _VratKathaScreenState();
}

class _VratKathaScreenState extends State<VratKathaScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initVratKatha();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VratKathaBloc, VratKathaState>(
      builder: (context, state) {
        final katha = state.getVratKatha(widget.kathaId);
        final kathaInfo = state.getKathaInfo(kathaId: widget.kathaId);
        return AppScaffold(
          title: 'Vrat Katha',
          subtitle: kathaInfo?.title ?? widget.title,
          body: katha != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (katha.title != null) ...[
                        Text(katha.title!, style: AppTypography.textTheme.displaySmall, softWrap: true),
                        const SizedBox(height: 14),
                      ],
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: katha.imagePath,
                          fit: BoxFit.fitWidth,
                          errorWidget: (_, __, ___) => Container(height: 160, color: AppColors.surfaceAlt, child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textFaint)),
                          placeholder: (_, __) => Container(height: 160, color: AppColors.surface, child: const AppLoader()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...katha.katha.text.map((verse) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (verse.title != null) ...[
                                Text(verse.title!, style: TextStyle(fontFamily: AppScript.familyFor(verse.title!), fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.terracotta)),
                                const SizedBox(height: 8),
                              ],
                              ...verse.description.map((desc) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(desc, style: TextStyle(fontFamily: AppScript.familyFor(desc), fontSize: 17, height: 1.7, color: AppColors.ink)),
                                  )),
                              const SizedBox(height: 12),
                            ],
                          )),
                    ],
                  ),
                )
              : state.isError(forr: Httpstates.VRAT_KATHA)
                  ? RetryAgain(onRetry: initVratKatha, error: state.getError(forr: Httpstates.VRAT_KATHA)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initVratKatha() {
    BlocProvider.of<VratKathaBloc>(context).add(FetchVratKathaById(kathaId: widget.kathaId, cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
