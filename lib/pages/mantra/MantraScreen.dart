import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MantraScreen extends StatefulWidget {
  final String title;
  final String mantraId;
  const MantraScreen({super.key, required this.title, required this.mantraId});

  @override
  State<MantraScreen> createState() => _MantraScreenState();
}

class _MantraScreenState extends State<MantraScreen> {
  CancelToken token = CancelToken();

  @override
  initState() {
    BlocProvider.of<MantraBloc>(context).add(FetchMantraById(id: widget.mantraId, cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraBloc, MantraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mantra = state.getMantraById(mantraId: widget.mantraId);
        return Scaffold(
            appBar: AppBar(
              title: Text('Rigveda'),
            ),
            body: mantra != null
                ? Text(mantra.title)
                : state.error != null
                    ? Center(child: Text(state.error!))
                    : Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
