import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: Text(widget.title),
      ),
      body: BlocBuilder<AartiBloc, AartiState>(builder: (context, state) {
        return state.aartisInfo.isNotEmpty
            ? ListView.builder(
                itemCount: state.aartisInfo.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Text('${index + 1}'),
                        key: Key(state.aartisInfo[index].id),
                        title: Text(state.aartisInfo[index].title),
                        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.orangeAccent)),
                        onTap: () {
                          GoRouter.of(context).pushNamed(Routing.aarti, pathParameters: {"id": state.aartisInfo[index].id});
                        },
                      ),
                    ))
            : state.error != null
                ? Center(child: Text(state.error!))
                : Center(child: CircularProgressIndicator());
      }),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
