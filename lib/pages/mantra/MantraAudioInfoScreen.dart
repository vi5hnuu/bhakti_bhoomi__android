import 'dart:math';

import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  late int maxPageNo;

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
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Mantra's",
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: (state.allMantraAudioInfo?.data.length ?? 0),
                  itemBuilder: (context, index) {
                    final mantraAudioInfo = state.allMantraAudioInfo!.data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      child: RoundedListTile(
                          itemNo: index + 1,
                          onTap: ()=>GoRouter.of(context).pushNamed(Routing.mantraAudio.name, pathParameters: {'mantraAudioId': mantraAudioInfo.id}),
                          text: '${mantraAudioInfo.title['en']}'),
                    );
                  },
                ),
                if(state.hasHttpState(forr: state.mantraAudioInfoPageKey(pageNo: pageNo))) Align(alignment: Alignment.center, child:Center(child: state.isError(forr: state.mantraAudioInfoPageKey(pageNo: pageNo))
                    ? RetryAgain(onRetry: loadCurrentPage, error: state.getError(forr: state.mantraAudioInfoPageKey(pageNo: pageNo))!.message)
                    : Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: SpinKitThreeBounce(color: Theme.of(context).primaryColor, size: 24))))
              ],
            ));
      },
    );
  }

  loadCurrentPage(){
    _loadPage(pageNo: pageNo);
  }


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
    cancelToken.cancel("cancelling sargas fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}