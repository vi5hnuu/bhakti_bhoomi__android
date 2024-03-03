import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  CancelToken? cancelToken;
  int shlokNo = 1;

  @override
  initState() {
    cancelToken = _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: this.shlokNo, lang: lang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final totalShloks = state.totalShlokInSarga(kand: widget.kand, sargaNo: widget.sargaNo, lang: lang) ?? 0;
        return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                'Valmiki Ramayan',
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 24, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: PageView.builder(
              key: pageStorageKey,
              pageSnapping: true,
              controller: _controller,
              physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
              scrollDirection: Axis.vertical,
              itemCount: totalShloks,
              itemBuilder: (context, index) {
                final ramayanInfo = state.ramayanInfo;
                final shlok = state.getShlok(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: lang);
                return Center(
                  child: shlok != null
                      ? Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 70,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/heading_frame.png"), fit: BoxFit.fill)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.kand,
                                            style: TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.w700, fontSize: 24),
                                          ),
                                          Text(
                                            "${widget.sargaNo}",
                                            style: TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.w700, fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                      child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/text_bg.png"), fit: BoxFit.fill)),
                                    child: FractionallySizedBox(
                                      heightFactor: 0.7,
                                      widthFactor: 0.8,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          shlok.shlok,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )),
                                  if (index < totalShloks - 1) const Icon(Icons.keyboard_arrow_up_outlined)
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 45,
                              right: 15,
                              child: EngageActions(
                                onBookmark: () => {},
                                onLike: () => {},
                                onComment: () => onComment(
                                    context: context,
                                    commentFormId: RamayanState.commentForId(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: shlokNo, lang: lang ?? RamayanState.defaultLanguage)),
                              ),
                            ),
                            Positioned(
                                top: -5,
                                right: 3,
                                child: InkWell(
                                  onTap: () => {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            elevation: 5,
                                            child: FractionallySizedBox(
                                                heightFactor: 0.7,
                                                widthFactor: 1,
                                                child: LanguageDialog(
                                                    translationLanguages: ramayanInfo!.translationLanguages,
                                                    onPress: (value) => setState(() {
                                                          if (!mounted) return;
                                                          lang = value;
                                                          cancelToken = _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: value);
                                                        }))),
                                            backgroundColor: Colors.transparent,
                                          );
                                        })
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange.withOpacity(0.3),
                                        border: Border.all(color: Colors.deepOrange),
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100), bottomLeft: Radius.circular(100))),
                                    child: Icon(Icons.translate),
                                  ),
                                )),
                          ],
                        )
                      : state.error != null
                          ? Text(state.error!)
                          : SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                            ),
                );
              },
              dragStartBehavior: DragStartBehavior.down,
              onPageChanged: (pageNo) => setState(
                () {
                  cancelToken?.cancel("cancelled");
                  shlokNo = pageNo + 1;
                  cancelToken = _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: pageNo + 1, lang: lang);
                },
              ),
            ));
      },
    );
  }

  _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "Feature will available in next update...", color: Colors.orange));
  }

  CancelToken _loadShlok({required String kand, required int sargaNo, required int shlokNo, String? lang}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanShlokByKandSargaNoShlokNo(kanda: kand, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    cancelToken?.cancel("cancelled");
    super.dispose();
  }
}

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({
    super.key,
    required this.translationLanguages,
    this.onPress,
  });

  final Map<String, String> translationLanguages;
  final Function(String)? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/old_paper.png"), fit: BoxFit.fill)),
      child: Column(
        children: [
          const Text(
            "Select Lenguage",
            style: TextStyle(fontFamily: "Kalam", fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Expanded(
              child: ListView(
                  children: translationLanguages.entries
                      .map((e) => InkWell(
                          onTap: () {
                            if (onPress == null) return;
                            onPress!(e.value);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.all(7),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ], image: DecorationImage(image: AssetImage("assets/images/old_paper.png"), fit: BoxFit.fitWidth)),
                            child: Text(e.key, textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontFamily: 'PermanentMarker')),
                          )))
                      .toList())),
        ],
      ),
    );
  }
}
