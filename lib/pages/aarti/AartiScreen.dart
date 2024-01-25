import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AartiScreen extends StatelessWidget {
  final String title;
  final String aartiId;
  const AartiScreen({super.key, required this.aartiId, required this.title});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => BlocProvider.of<AartiBloc>(context).add(FetchAartiEvent(aartiId: aartiId)));

    return BlocBuilder<AartiBloc, AartiState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(title: state.isLoading || state.error != null || state.aartis[aartiId] == null ? Text("Aarti") : Text(state.aartis[aartiId]!.title)),
          body: ((state.isLoading || state.aartis[aartiId] == null) && state.error == null)
              ? const CircularProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : ListView.builder(
                      itemCount: state.aartis[aartiId]!.verses.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: (state.aartis[aartiId] as AartiModel).verses[index].map((e) => Text(e)).toList(),
                        ),
                      ),
                    )),
    );
  }
}
