import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MahabharatChaptersInfoScreen extends StatefulWidget {
  final String title;
  final int bookNo;
  const MahabharatChaptersInfoScreen({super.key, required this.title, required this.bookNo});

  @override
  State<MahabharatChaptersInfoScreen> createState() => _MahabharatChaptersInfoScreenState();
}

class _MahabharatChaptersInfoScreenState extends State<MahabharatChaptersInfoScreen> {
  @override
  void initState() {
    // Self-heal on direct entry so getBooksInfo() is available.
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MahabharatBloc, MahabharatState>(
      builder: (context, state) {
        final bookInfo = state.allBooksInfo == null ? null : state.getBooksInfo(bookNo: widget.bookNo);
        return AppScaffold(
          title: 'Mahabharat · Book ${widget.bookNo}',
          subtitle: 'पर्व ${widget.bookNo} · अध्याय',
          body: bookInfo != null
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: bookInfo.info.length,
                  itemBuilder: (context, index) => IndexTile(
                    number: '${index + 1}',
                    title: 'Chapter ${index + 1}',
                    meta: '${bookInfo.info['${index + 1}'] ?? 0} verses',
                    onTap: () => GoRouter.of(context).pushNamed(
                      Routing.mahabharatBookChapterShloks.name,
                      pathParameters: {'bookNo': '${widget.bookNo}', 'chapterNo': '${index + 1}'},
                    ),
                  ),
                )
              : state.isError(forr: Httpstates.MAHABHARATA_INFO)
                  ? RetryAgain(
                      onRetry: () => BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent()),
                      error: state.getError(forr: Httpstates.MAHABHARATA_INFO)?.message ?? 'Could not load',
                    )
                  : const AppLoader(),
        );
      },
    );
  }
}
