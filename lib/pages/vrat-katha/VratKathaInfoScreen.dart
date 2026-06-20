import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/vratkatha/vratKatha_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VratKathaInfoScreen extends StatefulWidget {
  final String title;
  const VratKathaInfoScreen({super.key, required this.title});

  @override
  State<VratKathaInfoScreen> createState() => _VratKathaInfoScreenState();
}

class _VratKathaInfoScreenState extends State<VratKathaInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  CancelToken cancelToken = CancelToken();
  int pageNo = 1;

  @override
  void initState() {
    loadCurrentPage();
    _scrollController.addListener(_loadNextPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VratKathaBloc, VratKathaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AppScaffold(
          title: 'Vrat Katha',
          subtitle: 'व्रत कथा',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.kathaInfos.isEmpty && state.isLoading(forr: Httpstates.VRAT_KATHA_INFO_PAGE)) const Expanded(child: AppLoader()),
              if (state.kathaInfos.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() => pageNo = 1);
                      loadCurrentPage();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.kathaInfos.length,
                      itemBuilder: (context, index) {
                        final kathaInfo = state.getKathaInfoAt(at: index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: AppCard(
                            onTap: () => GoRouter.of(context).pushNamed(Routing.vratKatha.name, pathParameters: {'kathaId': kathaInfo.id}),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: kathaInfo.imagePath,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.surfaceAlt, child: const Icon(Icons.image_outlined, color: AppColors.textFaint)),
                                    placeholder: (_, __) => Container(width: 56, height: 56, color: AppColors.surface),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(child: Text('${kathaInfo.title}', style: AppTypography.textTheme.titleMedium)),
                                const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (state.isLoading(forr: Httpstates.VRAT_KATHA_INFO_PAGE) && state.kathaInfos.isNotEmpty)
                const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: AppLoader()),
              if (state.isError(forr: Httpstates.VRAT_KATHA_INFO_PAGE))
                RetryAgain(onRetry: loadCurrentPage, error: state.getError(forr: Httpstates.VRAT_KATHA_INFO_PAGE)!.message),
            ],
          ),
        );
      },
    );
  }

  loadCurrentPage() => _loadPage(pageNo: pageNo);

  void _loadPage({required int pageNo}) {
    BlocProvider.of<VratKathaBloc>(context).add(FetchVratKathaInfoPage(pageNo: pageNo, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollPosition = _scrollController.position.pixels;
    final scrollPercentage = maxScrollExtent == 0 ? 0 : currentScrollPosition / maxScrollExtent;
    if (scrollPercentage <= 0.8) return;
    final bloc = BlocProvider.of<VratKathaBloc>(context);
    final shouldLoadNextPage = !bloc.state.isLoading(forr: Httpstates.VRAT_KATHA_INFO_PAGE) && bloc.state.totalPages > pageNo;
    if (shouldLoadNextPage) setState(() => _loadPage(pageNo: ++pageNo));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling vrat katha page info fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
