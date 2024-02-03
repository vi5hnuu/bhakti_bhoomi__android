import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
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
    BlocProvider.of<AartiBloc>(context).add(FetchAartiInfoEvent(cancelToken: cancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<AartiBloc, AartiState>(builder: (context, state) {
        return state.aartisInfo.isNotEmpty
            ? ListView.builder(
                itemCount: state.aartisInfo.length,
                itemBuilder: (context, index) {
                  final aartiInfo = state.aartisInfo[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                      ),
                      key: Key(aartiInfo.id),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64), side: BorderSide(color: Theme.of(context).primaryColor)),
                      title: Text(aartiInfo.title),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      onTap: () {
                        GoRouter.of(context).pushNamed(Routing.aarti, pathParameters: {"id": state.aartisInfo[index].id});
                      },
                    ),
                  );
                })
            : state.error != null
                ? Center(child: Text(state.error!))
                : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor));
      }),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
