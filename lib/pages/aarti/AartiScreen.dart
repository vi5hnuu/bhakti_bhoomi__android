import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
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
    initAarti();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AartiBloc, AartiState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                state.aartis[widget.aartiId] == null || state.hasHttpState(forr: Httpstates.AARTIS) ? 'Aarti' : state.aartis[widget.aartiId]!.title,
                style: const TextStyle(color: Colors.white,
                    fontFamily: "Kalam",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: state.getAarti(widget.aartiId)!=null ? ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.aartis[widget.aartiId]!.verses.length,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: state
                          .getAarti(widget.aartiId)!
                          .verses[index]
                          .map((verse) =>
                          Text(
                            verse,
                            style: const TextStyle(fontFamily: 'NotoSansDevanagari',
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ))
                          .toList(),
                    ),
                  ),
            ):
            (Center(child: state.isError(forr: Httpstates.AARTIS) ? RetryAgain(onRetry: initAarti, error: state.getError(forr: Httpstates.AARTIS)!.message) : const CircularProgressIndicator())));
      },
    );
  }

  initAarti() {
    BlocProvider.of<AartiBloc>(context).add(
        FetchAartiEvent(aartiId: widget.aartiId, cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
