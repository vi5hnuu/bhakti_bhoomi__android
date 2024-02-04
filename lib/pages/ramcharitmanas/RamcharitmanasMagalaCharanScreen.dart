import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../widgets/CustomDropDownMenu.dart';

class RamcharitmanasMangalacharanScreen extends StatefulWidget {
  final String title;
  final String kand;
  const RamcharitmanasMangalacharanScreen({super.key, required this.title, required this.kand});

  @override
  State<RamcharitmanasMangalacharanScreen> createState() => _RamcharitmanasMangalacharanScreenState();
}

class _RamcharitmanasMangalacharanScreenState extends State<RamcharitmanasMangalacharanScreen> {
  CancelToken? token;
  String? lang;

  @override
  initState() {
    token = _loadMangalacharan(kand: widget.kand, lang: lang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mangalacharan = state.getMangalacharan(kand: widget.kand, lang: lang);

        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Ramcharitmanas | ${widget.kand} mangalacharan',
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: mangalacharan != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CustomDropDownMenu(
                            label: 'Select Language',
                            initialSelection: lang ?? RamcharitmanasState.defaultLang,
                            onSelected: _onLangSelected,
                            dropdownMenuEntries: state.info!.mangalacharanTranslationLanguages.entries
                                .map((e) => CustomDropDownEntry(label: e.key, value: e.value, foreGroundColor: Theme.of(context).primaryColor))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Text(
                            mangalacharan.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 2, fontSize: 16),
                          ),
                        ))
                      ],
                    ),
                  )
                : state.error != null
                    ? Center(
                        child: Text(state.error!),
                      )
                    : Center(
                        child: SpinKitThreeBounce(color: Theme.of(context).primaryColor),
                      ));
      },
    );
  }

  _onLangSelected(String? value) {
    setState(() {
      if (!mounted || value == null) return;
      lang = value;
      token?.cancel("cancelled");
      token = _loadMangalacharan(kand: widget.kand, lang: value);
    });
  }

  CancelToken _loadMangalacharan({required String kand, String? lang}) {
    CancelToken newToken = CancelToken();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasMangalacharanByKanda(kanda: kand, lang: lang, cancelToken: newToken));
    return newToken;
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    super.dispose();
  }
}
