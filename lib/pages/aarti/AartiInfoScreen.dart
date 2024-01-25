import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AartiInfoScreen extends StatelessWidget {
  final String title;
  const AartiInfoScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => BlocProvider.of<AartiBloc>(context).add(FetchAartiInfoEvent()));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<AartiBloc, AartiState>(builder: (context, state) {
        return state.isLoading && state.error == null
            ? CircularProgressIndicator()
            : state.error != null
                ? Text(state.error!)
                : ListView.builder(
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
                        ));
      }),
    );
  }
}
