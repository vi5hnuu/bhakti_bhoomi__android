import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
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
      builder: (context, state) => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              'Valmiki Ramayan | Kand ${widget.kand} | Sarga No | ${widget.sargaNo}',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 14, fontWeight: FontWeight.bold),
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
            itemCount: state.totalShlokInSarga(kand: widget.kand, sargaNo: widget.sargaNo, lang: lang),
            itemBuilder: (context, index) {
              final ramayanInfo = state.ramayanInfo;
              final shlok = state.getShlok(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: lang);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: shlok != null
                      ? Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CustomDropDownMenu(
                                  dropdownMenuEntries: ramayanInfo!.translationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                                  initialSelection: lang ?? RamayanState.defaultLanguage,
                                  onSelected: (value) => setState(() {
                                    if (!mounted) return;
                                    lang = value;
                                    cancelToken = _loadShlok(kand: widget.kand, sargaNo: widget.sargaNo, shlokNo: index + 1, lang: value);
                                  }),
                                  label: 'select language',
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Text(
                                    shlok.shlok,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                                  ),
                                )),
                                SizedBox(
                                  height: 24,
                                  child: (shlokNo < state.totalShlokInSarga(kand: widget.kand, sargaNo: widget.sargaNo, lang: lang)!) ? Icon(Icons.drag_handle) : null,
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 45,
                              right: 15,
                              child: Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                elevation: 1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () => this._showNotImplementedMessage(),
                                          tooltip: 'Like',
                                          selectedIcon: Icon(Icons.favorite, size: 36),
                                          isSelected: true,
                                          icon: Icon(Icons.favorite_border, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(
                                          onPressed: () => onComment(
                                              context: context,
                                              commentFormId: RamayanState.commentForId(kanda: widget.kand, sargaNo: widget.sargaNo, shlokNo: shlokNo, lang: lang ?? RamayanState.defaultLanguage)),
                                          icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(
                                        onPressed: () => this._showNotImplementedMessage(),
                                        icon: Icon(Icons.bookmark_border, size: 36),
                                        tooltip: 'bookmark',
                                        color: Colors.blue,
                                        selectedIcon: Icon(Icons.bookmark_added_sharp, size: 36),
                                        isSelected: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : state.error != null
                          ? Center(child: Text(state.error!))
                          : Center(
                              child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
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
          )),
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
