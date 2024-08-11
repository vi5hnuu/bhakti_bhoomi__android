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

class ValmikiRamayanKandsScreen extends StatefulWidget {
  final String title;

  const ValmikiRamayanKandsScreen({super.key, required this.title});

  @override
  State<ValmikiRamayanKandsScreen> createState() => _ValmikiRamayanKandsScreenState();
}

class _ValmikiRamayanKandsScreenState extends State<ValmikiRamayanKandsScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initRamayanaInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final ramayanInfo = state.ramayanInfo;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Valmiki Ramayan',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: ramayanInfo != null
                ? ListView(
                    children: state
                        .kandas()!
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                              child: RoundedListTile(
                                itemNo: e.value,
                                onTap: () => GoRouter.of(context).pushNamed(Routing.valmikiRamayanSargasInfo, pathParameters: {'kand': e.key}),
                                text: '${e.key}',
                              ),
                            ))
                        .toList())
                : state.isError(forr: Httpstates.RAMAYANA_INFO)
                    ? Center(
                        child: RetryAgain(onRetry: initRamayanaInfo,error: state.getError(forr: Httpstates.RAMAYANA_INFO)!),
                      )
                    : Center(
                        child: SpinKitThreeBounce(color: Theme.of(context).primaryColor),
                      ),
          ),
        );
      },
    );
  }

  initRamayanaInfo(){
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanInfo(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel();
    super.dispose();
  }
}
