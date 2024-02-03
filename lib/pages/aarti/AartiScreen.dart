import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AartiScreen extends StatefulWidget {
  final String title;
  final String aartiId;
  const AartiScreen({super.key, required this.aartiId, required this.title});

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    BlocProvider.of<AartiBloc>(context).add(FetchAartiEvent(aartiId: widget.aartiId, cancelToken: cancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AartiBloc, AartiState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              state.isLoading || state.error != null || state.aartis[widget.aartiId] == null ? 'Aarti' : state.aartis[widget.aartiId]!.title,
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: state.getAarti(widget.aartiId) != null
              ? ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.aartis[widget.aartiId]!.verses.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: state
                          .getAarti(widget.aartiId)!
                          .verses[index]
                          .map((verse) => Text(
                                verse,
                                style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 18, fontWeight: FontWeight.w700),
                              ))
                          .toList(),
                    ),
                  ),
                )
              : state.error != null
                  ? Center(child: Text(state.error!))
                  : Center(child: CircularProgressIndicator())),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
