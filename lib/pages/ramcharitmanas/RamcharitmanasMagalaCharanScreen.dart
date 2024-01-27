import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              title: Text('Ramcharitmanas mangalacharan'),
            ),
            body: ((state.isLoading || mangalacharan == null) && state.error == null)
                ? const RefreshProgressIndicator()
                : state.error != null
                    ? Text(state.error!)
                    : Column(
                        children: [
                          DropdownMenu(
                            dropdownMenuEntries: state.info!.mangalacharanTranslationLanguages.entries.map((e) => DropdownMenuEntry(value: e.value, label: e.key)).toList(),
                            initialSelection: lang ?? RamcharitmanasState.defaultLang,
                            onSelected: (value) => setState(() {
                              if (!mounted) return;
                              lang = value;
                              token = token = _loadMangalacharan(kand: widget.kand, lang: value);
                            }),
                          ),
                          SizedBox(
                            height: 60,
                            child: Text(mangalacharan!.text),
                          )
                        ],
                      ));
      },
    );
  }

  CancelToken _loadMangalacharan({required String kand, String? lang}) {
    token?.cancel("cancelled");
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
