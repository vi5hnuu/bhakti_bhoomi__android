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
  CancelToken token = CancelToken();

  @override
  initState() {
    super.initState();
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasMangalacharanByKanda(kanda: widget.kand, cancelToken: token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous.allMangalacharan != current.allMangalacharan,
      builder: (context, state) {
        final mangalacharan = state.getMangalacharan(kand: widget.kand);

        return Scaffold(
            appBar: AppBar(
              title: Text('Ramcharitmanas mangalacharan'),
            ),
            body: ((state.isLoading || mangalacharan == null) && state.error == null)
                ? const RefreshProgressIndicator()
                : state.error != null
                    ? Text(state.error!)
                    : SizedBox(
                        height: 60,
                        child: Text(mangalacharan!.text),
                      ));
      },
    );
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    super.dispose();
  }
}
