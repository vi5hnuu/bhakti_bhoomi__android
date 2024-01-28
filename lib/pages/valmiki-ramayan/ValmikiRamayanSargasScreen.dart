import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValmikiRamayanSargasScreen extends StatefulWidget {
  final String title;
  final String kand;

  const ValmikiRamayanSargasScreen({super.key, required this.title, required this.kand});

  @override
  State<ValmikiRamayanSargasScreen> createState() => _ValmikiRamayanSargasScreenState();
}

class _ValmikiRamayanSargasScreenState extends State<ValmikiRamayanSargasScreen> {
  final ScrollController _scrollController = ScrollController();
  CancelToken? cancelToken;
  int pageNo = 1;

  @override
  void initState() {
    cancelToken = _loadPage();
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
            title: Text('Valmiki Ramayan'),
          ),
          body: (state.isLoading || !state.sargasInfoExists(kanda: widget.kand, pageNo: pageNo)) && state.error == null
              ? RefreshProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        final sargaInfo = state.getSargaInfo(kanda: widget.kand, sargaNo: index + 1);
                        return InkWell(
                          onTap: () => Navigator.of(context).pushNamed(Routing.valmikiRamayanShlok, arguments: {'kand': widget.kand, 'sargaNo': index + 1}),
                          child: Text('Sarga ${sargaInfo!.totalShloks}'),
                        );
                      },
                    ),
        );
      },
    );
  }

  CancelToken _loadPage() {
    cancelToken?.cancel("cancelling sargas fetch");
    final newCancelToken = CancelToken();
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanSargasInfo(kanda: widget.kand, pageNo: 1, cancelToken: newCancelToken));
    return newCancelToken;
  }

  void _loadNextPage() {
    print("loading next page : ${_scrollController.positions}");
  }

  @override
  void dispose() {
    cancelToken?.cancel("cancelling sargas fetch");
    _scrollController.removeListener(_loadNextPage);
    _scrollController.dispose();
    super.dispose();
  }
}
