import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RigvedaSuktaScreen extends StatefulWidget {
  final String title;
  final int mandala;
  const RigvedaSuktaScreen({super.key, required this.title, required this.mandala});

  @override
  State<RigvedaSuktaScreen> createState() => _RigvedaSuktaScreenState();
}

class _RigvedaSuktaScreenState extends State<RigvedaSuktaScreen> {
  final pageStorageKey = const PageStorageKey('rigveda-mandala-suktas');
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;

  @override
  initState() {
    super.initState();
    token = _loadSukta(mandala: widget.mandala, suktaNo: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RigvedaBloc, RigvedaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Rigveda'),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.rigvedaInfo!.mandalaInfo[widget.mandala],
            itemBuilder: (context, index) {
              final sukta = state.getSukta(mandala: widget.mandala, suktaNo: index + 1);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ((state.isLoading || sukta == null) && state.error == null)
                      ? const RefreshProgressIndicator()
                      : state.error != null
                          ? Text(state.error!)
                          : Stack(
                              children: [
                                Text(sukta!.text),
                                const Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: Column(
                                    children: [
                                      IconButton(onPressed: null, icon: Icon(Icons.favorite_border, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(onPressed: null, icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                print("token $token");
                token?.cancel("cancelled");
                token = _loadSukta(mandala: widget.mandala, suktaNo: pageNo + 1);
              },
            ),
          )),
    );
  }

  CancelToken _loadSukta({required int mandala, required int suktaNo}) {
    token?.cancel("cancelled");
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<RigvedaBloc>(context).add(FetchVerseByMandalaSukta(mandalaNo: mandala, suktaNo: suktaNo, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
