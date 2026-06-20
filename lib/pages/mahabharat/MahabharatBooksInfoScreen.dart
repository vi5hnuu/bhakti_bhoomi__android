import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MahabharatBookInfoScreen extends StatefulWidget {
  final String title;
  const MahabharatBookInfoScreen({super.key, required this.title});

  @override
  State<MahabharatBookInfoScreen> createState() => _MahabharatBookInfoScreenState();
}

class _MahabharatBookInfoScreenState extends State<MahabharatBookInfoScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initMahabharataInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MahabharatBloc, MahabharatState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final books = state.allBooksInfo;
        return AppScaffold(
          title: 'Mahabharat',
          subtitle: 'महाभारत · पर्व',
          body: books != null
              ? RefreshIndicator(
                  onRefresh: () async => initMahabharataInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final bookInfo = books[index];
                      final totalShloks = bookInfo.info.values.fold<int>(0, (t, s) => t + s);
                      return IndexTile(
                        number: '${bookInfo.bookNo}',
                        title: 'Book ${bookInfo.bookNo}',
                        subtitle: 'पर्व ${bookInfo.bookNo}',
                        meta: '$totalShloks shloks',
                        onTap: () => GoRouter.of(context).pushNamed(Routing.mahabharatBookChaptersInfos.name, pathParameters: {'bookNo': '${bookInfo.bookNo}'}),
                      );
                    },
                  ),
                )
              : state.isError(forr: Httpstates.MAHABHARATA_INFO)
                  ? RetryAgain(onRetry: initMahabharataInfo, error: state.getError(forr: Httpstates.MAHABHARATA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initMahabharataInfo() {
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
