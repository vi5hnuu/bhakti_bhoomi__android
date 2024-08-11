import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class RamcharitmanasInfoScreen extends StatefulWidget {
  final String title;
  const RamcharitmanasInfoScreen({super.key, required this.title});

  @override
  State<RamcharitmanasInfoScreen> createState() => _RamcharitmanasInfoScreenState();
}

class _RamcharitmanasInfoScreenState extends State<RamcharitmanasInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initRamcharitmanasInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.info;
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Ramcharitmanas',
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: info != null
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 5,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Material(
                                color: Theme.of(context).primaryColor,
                                elevation: 8,
                                shadowColor: Colors.black,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                child: const Text(
                                  "-: Kands :-",
                                  style: TextStyle(fontFamily: 'permanentMarker', fontSize: 32, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  child: ListView.builder(
                                    itemCount: state.getAllKands().length,
                                    padding: const EdgeInsets.all(8),
                                    itemBuilder: (context, index) {
                                      final kand = state.getAllKands()[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: RoundedListTile(
                                          text: kand,
                                          itemNo: index + 1,
                                          onTap: () => GoRouter.of(context).pushNamed(Routing.ramcharitmanasKandVerses, pathParameters: {"kand": kand}),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        Flexible(
                          flex: 5,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Material(
                                color: Theme.of(context).primaryColor,
                                elevation: 8,
                                shadowColor: Colors.black,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                child: const Text(
                                  "-: Mangalacharan :-",
                                  style: TextStyle(fontFamily: 'permanentMarker', fontSize: 32, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  child: ListView.builder(
                                    itemCount: state.getAllKands().length,
                                    padding: const EdgeInsets.all(8),
                                    itemBuilder: (context, index) {
                                      final kand = state.getAllKands()[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: RoundedListTile(
                                          text: '$kand Mangalacharan',
                                          itemNo: index + 1,
                                          onTap: () => GoRouter.of(context).pushNamed(Routing.ramcharitmanasMangalaCharan, pathParameters: {"kand": kand}),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : state.isError(forr: Httpstates.RAMCHARITMANAS_INFO)
                    ? Center(child: RetryAgain(onRetry: initRamcharitmanasInfo,error: state.getError(forr: Httpstates.RAMCHARITMANAS_INFO)!))
                    : Center(
                        child: SpinKitThreeBounce(color: Theme.of(context).primaryColor),
                      ));
      },
    );
  }

  initRamcharitmanasInfo(){
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
