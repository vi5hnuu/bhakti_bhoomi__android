import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class AartiInfoScreen extends StatefulWidget {
  final String title;

  const AartiInfoScreen({super.key, required this.title});

  @override
  State<AartiInfoScreen> createState() => _AartiInfoScreenState();
}

class _AartiInfoScreenState extends State<AartiInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initAartiInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: "Kalam",
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<AartiBloc, AartiState>(builder: (context, state) {
        return state.aartisInfo.isNotEmpty
            ? ListView.builder(
                itemCount: state.aartisInfo.length,
                itemBuilder: (context, index) {
                  final aartiInfo = state.aartisInfo[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedListTile(
                      itemNo: index + 1,
                      text: aartiInfo.title,
                      key: Key(aartiInfo.id),
                      onTap: () => GoRouter.of(context).pushNamed(Routing.aarti,
                          pathParameters: {"id": state.aartisInfo[index].id}),
                    ),
                  );
                })
            : Center(
                child: state.isError(forr: Httpstates.AARTI_INFO)
                    ? RetryAgain(onRetry: initAartiInfo,error: state.getError(forr:  Httpstates.AARTI_INFO)!)
                    : (state.isLoading(forr: Httpstates.AARTI_INFO)
                        ? SpinKitThreeBounce(
                            color: Theme.of(context).primaryColor)
                        : const Text("No Aarti found.")));
      }),
    );
  }

  initAartiInfo() {
    BlocProvider.of<AartiBloc>(context)
        .add(FetchAartiInfoEvent(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

