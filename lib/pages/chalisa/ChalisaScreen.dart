import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChalisaScreen extends StatefulWidget {
  final String title;
  final String chalisaId;
  const ChalisaScreen({super.key, required this.title, required this.chalisaId});

  @override
  State<ChalisaScreen> createState() => _ChalisaScreenState();
}

class _ChalisaScreenState extends State<ChalisaScreen> {
  CancelToken token = CancelToken();

  @override
  initState() {
    BlocProvider.of<ChalisaBloc>(context).add(FetchChalisaById(id: widget.chalisaId, cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChalisaBloc, ChalisaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final chalisa = state.getChalisaById(chalisaId: widget.chalisaId);
        return Scaffold(
            appBar: AppBar(
              title: Text('Chalisa'),
            ),
            body: chalisa != null
                ? Text(chalisa.title)
                : state.error != null
                    ? Center(child: Text(state.error!))
                    : Center(child: const RefreshProgressIndicator()));
      },
    );
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
