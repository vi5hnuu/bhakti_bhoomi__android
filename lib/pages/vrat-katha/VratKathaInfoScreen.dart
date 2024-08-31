import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/vratkatha/vratKatha_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(state.kathaInfos.isNotEmpty) Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.kathaInfos.length,
                    itemBuilder: (context, index) {
                      final kathaInfo = state.getKathaInfoAt(at: index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: RoundedListTile(
                            itemNo: index + 1,
                            imageUrl: kathaInfo.imagePath,
                            onTap: () => GoRouter.of(context).pushNamed(Routing.vratKatha.name, pathParameters: {'kathaId': kathaInfo.id}),
                            text: '${kathaInfo.title}'),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: (state.isLoading(forr: Httpstates.VRAT_KATHA_INFO_PAGE))
                      ? Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: SpinKitThreeBounce(color: Theme.of(context).primaryColor, size: 24))
                      : ((state.isError(forr: Httpstates.VRAT_KATHA_INFO_PAGE))
                          ? RetryAgain(
                              onRetry: loadCurrentPage,
                              error: state
                                  .getError(
                                      forr: Httpstates.VRAT_KATHA_INFO_PAGE)!
                                  .message)
                          : null),
                )
              ],
            ));
      },
    );
  }

  loadCurrentPage(){
    _loadPage(pageNo: pageNo);
  }

  void _loadPage({required int pageNo}) {
    BlocProvider.of<VratKathaBloc>(context).add(FetchVratKathaInfoPage(pageNo: pageNo, cancelToken: cancelToken));
  }

  void _loadNextPage() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;
    // Calculate the scroll percentage
    double scrollPercentage = currentScrollPosition / maxScrollExtent;
    // Check if scroll percentage is greater than or equal to 80%
    if (scrollPercentage <= 0.8) return;
    final bloc=BlocProvider.of<VratKathaBloc>(context);
    final shouldLoadNextPage = !bloc.state.isLoading(forr: Httpstates.VRAT_KATHA_INFO_PAGE) && bloc.state.totalPages> pageNo;
    if(shouldLoadNextPage) setState(() => _loadPage(pageNo: ++pageNo));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelling vrat katha page info fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
