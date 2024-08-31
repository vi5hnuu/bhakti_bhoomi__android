import 'dart:ui';

import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/vratkatha/vratKatha_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VratKathaScreen extends StatefulWidget {
  final String title;
  final String kathaId;

  const VratKathaScreen({super.key, required this.kathaId, required this.title});

  @override
  State<VratKathaScreen> createState() => _VratKathaScreenState();
}

class _VratKathaScreenState extends State<VratKathaScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initVratKatha();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VratKathaBloc, VratKathaState>(
      builder: (context, state) {
        final katha=state.getVratKatha(widget.kathaId);
        final kathaInfo=state.getKathaInfo(kathaId: widget.kathaId);
        return Scaffold(
            appBar: AppBar(
              title: Text(kathaInfo?.title ?? widget.title,
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
            body: SingleChildScrollView(padding:const EdgeInsets.all(15.0),
              child: katha!=null ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                if(katha.title!=null) ...[Text(katha.title!,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),softWrap: true),
                const SizedBox(height: 15)],
                Card(
                  elevation: 0.1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child:  Image.network(fit: BoxFit.fitWidth,katha.imagePath,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : const CircularProgressIndicator())
                ),
                ...katha.katha.text.map((verse) =>
                    Column(children: [
                      if(verse.title!=null) ...[Text(
                        verse.title!,
                        style: const TextStyle(fontFamily: 'NotoSansDevanagari',
                            fontSize: 22,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700),
                      ),const SizedBox(height: 8)],
                      ...verse.description.map((desc)=>Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          desc,
                          style: const TextStyle(fontFamily: 'NotoSansDevanagari',
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ))
                    ],))
                    .toList(),
                ]):Center(child: state.isError(forr: Httpstates.VRAT_KATHA) ? RetryAgain(onRetry: initVratKatha, error: state.getError(forr: Httpstates.VRAT_KATHA)!.message) : const CircularProgressIndicator()),));
      },
    );
  }

  initVratKatha() {
    BlocProvider.of<VratKathaBloc>(context).add(FetchVratKathaById(kathaId: widget.kathaId, cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
