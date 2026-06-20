import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MantraAudioInfoScreen extends StatefulWidget {
  final String title;
  const MantraAudioInfoScreen({super.key, required this.title});

  @override
  State<MantraAudioInfoScreen> createState() => _MantraAudioInfoScreenState();
}

class _MantraAudioInfoScreenState extends State<MantraAudioInfoScreen> {
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
    return BlocBuilder<MantraBloc, MantraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final count = state.allMantraAudioInfo?.data.length ?? 0;
        final pageState = state.hasHttpState(forr: state.mantraAudioInfoPageKey(pageNo: pageNo));
        return AppScaffold(
          title: 'Mantra Audio',
          subtitle: 'मंत्र · 🎵',
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  setState(() => pageNo = 1);
                  loadCurrentPage();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: count,
                  itemBuilder: (context, index) {
                    final mantraAudioInfo = state.allMantraAudioInfo!.data[index];
                    return IndexTile(
                      number: '♪',
                      title: '${mantraAudioInfo.title['en']}',
                      onTap: () => GoRouter.of(context).pushNamed(Routing.mantraAudio.name, pathParameters: {'mantraAudioId': mantraAudioInfo.id}),
                    );
                  },
                ),
              ),
              if (pageState)
                Align(
                  alignment: count == 0 ? Alignment.center : Alignment.bottomCenter,
                  child: state.isError(forr: state.mantraAudioInfoPageKey(pageNo: pageNo))
                      ? RetryAgain(onRetry: loadCurrentPage, error: state.getError(forr: state.mantraAudioInfoPageKey(pageNo: pageNo))!.message)
                      : const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: AppLoader()),
                ),
            ],
          ),
        );
      },
    );
  }

  loadCurrentPage() => _loadPage(pageNo: pageNo);

  void _loadPage({required int pageNo}) {
    BlocProvider.of<MantraBloc>(context).add(FetchAllMantraAudioInfo(pageNo: pageNo, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    if (!mounted || _scrollController.position.pixels != _scrollController.position.maxScrollExtent) {
      return;
    }
    setState(() => _loadPage(pageNo: ++pageNo));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling audio info fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
