import 'dart:math';

import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  late int maxPageNo;

  @override
  void initState() {
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
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Ramcharitmanas | ${widget.kand} Sargas',
                style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: ListView.builder(
              controller: _scrollController,
              itemCount: _itemsCountUntillPage(ramayanInfo: state.ramayanInfo!),
              itemBuilder: (context, index) {
                final sargaInfo = state.getSargaInfo(kanda: widget.kand, sargaNo: index + 1);
                return sargaInfo != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: RoundedListTile(
                            itemNo: index + 1,
                            onTap: () => GoRouter.of(context).pushNamed(Routing.valmikiRamayanShlok.name, pathParameters: {'kand': widget.kand, 'sargaNo': '${index + 1}'}),
                            text: 'Sarga - Total verses ${sargaInfo.totalShloks.values.reduce(min)}'),
                      )
                    : Center(child: state.isError(forr: Httpstates.RAMAYANA_SARGAS_INFO)
                    ? RetryAgain(onRetry: loadCurrentPage, error: state.getError(forr: Httpstates.RAMAYANA_SARGAS_INFO)!.message)
                    : Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: SpinKitThreeBounce(color: Theme.of(context).primaryColor, size: 24)));
              },
            ));
      },
    );
  }

  loadCurrentPage(){
    _loadPage(pageNo: pageNo);
  }

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
