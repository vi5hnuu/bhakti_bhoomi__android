import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValmikiRamayanShlokScreen extends StatefulWidget {
  final String title;
  final String kand;
  final int sargaNo;

  const ValmikiRamayanShlokScreen({super.key, required this.title, required this.kand, required this.sargaNo});

  @override
  State<ValmikiRamayanShlokScreen> createState() => _ValmikiRamayanShlokScreenState();
}

class _ValmikiRamayanShlokScreenState extends State<ValmikiRamayanShlokScreen> {
  final pageStorageKey = const PageStorageKey('valmikiramayan-kand-sarga-shloks');
  final PageController _controller = PageController(initialPage: 0);
  String? lang;
  CancelToken? shlokCancelToken;
  CancelToken? sargaInfoCancelToken;

  @override
  initState() {
    super.initState();
    shlokCancelToken = _loadShlok(kand: widget.kand, sargaNo: 1, lang: lang);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('valmiki ramayan'),
          ),
          body: Text("")),
    );
  }

  /*
  PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.info!.kandaInfo[widget.kand],
            itemBuilder: (context, index) {
              final ramayanInfo = state.ramayanInfo;
              final shlok = state.getShlok(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: lang);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ((state.isLoading || shlok == null) && state.error == null)
                      ? const RefreshProgressIndicator()
                      : state.error != null
                          ? Text(state.error!)
                          : Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    DropdownMenu(
                                      dropdownMenuEntries: ramayanInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                      initialSelection: lang ?? RamcharitmanasState.defaultLang,
                                      onSelected: (value) => setState(() { if(!mounted) return;
                                        lang = value;
                                        shlokCancelToken = shlokCancelToken = _loadShlok(kand: widget.kand, sargaNo: index + 1, lang: value);
                                      }),
                                    ),
                                    Text(shlok!.explaination)
                                  ],
                                ),
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
                print("token $shlokCancelToken");
                shlokCancelToken?.cancel("cancelled");
                shlokCancelToken = _loadShlok(kand: widget.kand, sargaNo: pageNo + 1, lang: lang);
              },
            ),
          )
  */

  CancelToken _loadShlok({required String kand, required int sargaNo, String? lang}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanShlokasByKandSargaNo(kanda: kand, sargaNo: sargaNo, lang: lang, cancelToken: cancelToken));
    return cancelToken;
  }

  CancelToken _loadSargaInfo({required String kand, required int sargaNo, String? lang}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanShlokasByKandSargaNo(kanda: kand, sargaNo: sargaNo, lang: lang, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    shlokCancelToken?.cancel("cancelled");
    super.dispose();
  }
}
