import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    initChalisa();
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
            title: Text(
              state.hasHttpState(forr: Httpstates.CHALISA_BY_ID) || state.allChalisa[widget.chalisaId] == null ? 'Aarti' : state.allChalisa[widget.chalisaId]!.title,
              style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: chalisa != null
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: chalisa.translations['hi']!['data']!
                          .map((verseGroup) => Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Column(
                                  children: [
                                    Text(verseGroup.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'NotoSansDevanagari')),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ...verseGroup.verses.map((verse) => Text(verse, style: const TextStyle(fontSize: 18)))
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  : state.isError(forr: Httpstates.CHALISA_BY_ID)
                      ? Center(child: RetryAgain(onRetry: initChalisa,error: state.getError(forr: Httpstates.CHALISA_BY_ID)!.message))
                      : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor))),
        );
      },
    );
  }

  initChalisa(){
    BlocProvider.of<ChalisaBloc>(context).add(FetchChalisaById(id: widget.chalisaId, cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
