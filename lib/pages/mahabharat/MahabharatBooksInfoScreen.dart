import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class MahabharatBookInfoScreen extends StatefulWidget {
  final String title;
  MahabharatBookInfoScreen({super.key, required this.title});

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
        buildWhen: (previous, current) =>previous != current,
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Mahabharat',
                  style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: state.allBooksInfo != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: state.allBooksInfo!
                            .map((bookInfo) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    tileColor: Theme.of(context).primaryColor,
                                    leading: const Icon(Icons.menu_rounded, color: Colors.white),
                                    title: Text('Book ${bookInfo.bookNo}', style: const TextStyle(fontSize: 24, color: Colors.white)),
                                    subtitle: Text('Contains ${bookInfo.info.values.reduce((tShloks, shloks) => tShloks + shloks)} Shloks', style: TextStyle(color: Colors.white)),
                                    onTap: () => GoRouter.of(context).pushNamed(Routing.mahabharatBookChaptersInfos.name, pathParameters: {'bookNo': '${bookInfo.bookNo}'}),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  : state.isError(forr: Httpstates.MAHABHARATA_INFO)
                      ? Center(child: RetryAgain(onRetry: initMahabharataInfo,error: state.getError(forr: Httpstates.MAHABHARATA_INFO)!.message))
                      : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor))
            ));
  }

  initMahabharataInfo(){
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
