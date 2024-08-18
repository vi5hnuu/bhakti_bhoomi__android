import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class RigvedaMandalasInfoScreen extends StatefulWidget {
  final String title;
  const RigvedaMandalasInfoScreen({super.key, required this.title});

  @override
  State<RigvedaMandalasInfoScreen> createState() => _RigvedaMandalasInfoScreenState();
}

class _RigvedaMandalasInfoScreenState extends State<RigvedaMandalasInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initRigvedaInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RigvedaBloc, RigvedaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'RigVeda',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: state.rigvedaInfo != null
              ? Column(
                  children: List.generate(
                      state.rigvedaInfo!.totalMandala,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            child: RoundedListTile(
                                itemNo: index + 1, onTap: () => GoRouter.of(context).pushNamed(Routing.rigvedaMandalaSuktas.name, pathParameters: {'mandala': '${index + 1}'}), text: "mandala"),
                          )),
                )
              : state.isError(forr: Httpstates.RIGVEDA_INFO)
                  ? Center(child: RetryAgain(onRetry: initRigvedaInfo,error: state.getError(forr: Httpstates.RIGVEDA_INFO)!.message))
                  : Center(
                      child: SpinKitThreeBounce(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
        );
      },
    );
  }

  initRigvedaInfo(){
    BlocProvider.of<RigvedaBloc>(context).add(FetchRigvedaInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }
}
