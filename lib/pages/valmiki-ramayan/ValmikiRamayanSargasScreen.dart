import 'dart:math';

import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ValmikiRamayanSargasScreen extends StatefulWidget {
  final String title;
  final String kand;

  const ValmikiRamayanSargasScreen({super.key, required this.title, required this.kand});

  @override
  State<ValmikiRamayanSargasScreen> createState() => _ValmikiRamayanSargasScreenState();
}

class _ValmikiRamayanSargasScreenState extends State<ValmikiRamayanSargasScreen> {
  final ScrollController _scrollController = ScrollController();
  CancelToken cancelToken = CancelToken();
  int pageNo = 1;
  int maxPageNo = 1;

  @override
  void initState() {
    // Self-heal: load the kand info so ramayanInfo / maxPageNo are available
    // even on direct entry, then the first sargas page.
    BlocProvider.of<RamayanBloc>(context).add(const FetchRamayanInfo());
    maxPageNo = BlocProvider.of<RamayanBloc>(context).state.maxPageNo(kand: widget.kand);
    loadCurrentPage();
    _scrollController.addListener(_loadNextPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final ramayanInfo = state.ramayanInfo;
        if (ramayanInfo == null) {
          return AppScaffold(
            title: 'Valmiki Ramayan',
            subtitle: '${widget.kand} · सर्ग',
            body: state.isError(forr: Httpstates.RAMAYANA_INFO)
                ? RetryAgain(
                    onRetry: () => BlocProvider.of<RamayanBloc>(context).add(const FetchRamayanInfo()),
                    error: state.getError(forr: Httpstates.RAMAYANA_INFO)?.message ?? 'Could not load',
                  )
                : const AppLoader(),
          );
        }
        maxPageNo = state.maxPageNo(kand: widget.kand);
        return AppScaffold(
          title: 'Valmiki Ramayan',
          subtitle: '${widget.kand} · सर्ग',
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() => pageNo = 1);
              loadCurrentPage();
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _itemsCountUntillPage(ramayanInfo: ramayanInfo),
              itemBuilder: (context, index) {
                final sargaInfo = state.getSargaInfo(kanda: widget.kand, sargaNo: index + 1);
                if (sargaInfo == null) {
                  return state.isError(forr: Httpstates.RAMAYANA_SARGAS_INFO)
                      ? RetryAgain(onRetry: loadCurrentPage, error: state.getError(forr: Httpstates.RAMAYANA_SARGAS_INFO)!.message)
                      : const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: AppLoader());
                }
                return IndexTile(
                  number: '${index + 1}',
                  title: 'Sarga ${index + 1}',
                  meta: '${sargaInfo.totalShloks.values.reduce(min)} verses',
                  onTap: () => GoRouter.of(context).pushNamed(Routing.valmikiRamayanShlok.name, pathParameters: {'kand': widget.kand, 'sargaNo': '${index + 1}'}),
                );
              },
            ),
          ),
        );
      },
    );
  }

  loadCurrentPage() => _loadPage(pageNo: pageNo);

  int _itemsCountUntillPage({required RamayanInfoModel ramayanInfo}) {
    final totalSargs = _totalSargas(ramayanInfo: ramayanInfo);
    return ((pageNo - 1) * RamayanState.defaultSargasInfoPageSize) +
        (pageNo < maxPageNo || totalSargs % RamayanState.defaultSargasInfoPageSize == 0 ? RamayanState.defaultSargasInfoPageSize : totalSargs % RamayanState.defaultSargasInfoPageSize);
  }

  int _totalSargas({required RamayanInfoModel ramayanInfo}) {
    return ramayanInfo.kandInfo[widget.kand]!;
  }

  void _loadPage({required int pageNo}) {
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanSargasInfo(kanda: widget.kand, pageNo: pageNo, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    final isLoaded = BlocProvider.of<RamayanBloc>(context).state.isSargaInfoPageLoaded(kand: widget.kand, pageNo: pageNo);
    if (!mounted || !isLoaded || pageNo >= maxPageNo || _scrollController.position.pixels != _scrollController.position.maxScrollExtent) {
      return;
    }
    setState(() => _loadPage(pageNo: ++pageNo));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling sargas fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
