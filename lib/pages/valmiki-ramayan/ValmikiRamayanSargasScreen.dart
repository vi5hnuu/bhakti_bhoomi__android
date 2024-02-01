import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
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
  late int maxPageNo;

  @override
  void initState() {
    maxPageNo = BlocProvider.of<RamayanBloc>(context).state.maxPageNo(kand: widget.kand);
    _loadPage(pageNo: pageNo);
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
              title: Text('Valmiki Ramayan sargas'),
            ),
            body: ListView.builder(
              controller: _scrollController,
              itemCount: _itemsCountUntillPage(ramayanInfo: state.ramayanInfo!),
              itemBuilder: (context, index) {
                final sargaInfo = state.getSargaInfo(kanda: widget.kand, sargaNo: index + 1);
                return sargaInfo != null
                    ? InkWell(
                        onTap: () => GoRouter.of(context).pushNamed(Routing.valmikiRamayanShlok, pathParameters: {'kand': widget.kand, 'sargaNo': '${index + 1}'}),
                        child: SizedBox(child: Text('Sarga ${index} - ${sargaInfo.sargaId}'), height: 120))
                    : state.error != null
                        ? Center(child: Text(state.error!))
                        : Center(
                            child: const CircularProgressIndicator(),
                          );
              },
            ));
      },
    );
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
