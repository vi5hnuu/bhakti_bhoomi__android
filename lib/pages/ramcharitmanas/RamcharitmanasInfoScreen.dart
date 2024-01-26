import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RamcharitmanasInfoScreen extends StatefulWidget {
  final String title;
  const RamcharitmanasInfoScreen({super.key, required this.title});

  @override
  State<RamcharitmanasInfoScreen> createState() => _RamcharitmanasInfoScreenState();
}

class _RamcharitmanasInfoScreenState extends State<RamcharitmanasInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous.info != current.info,
      builder: (context, state) {
        final info = state.info;
        return Scaffold(
          appBar: AppBar(
            title: Text('Ramcharitmanas'),
          ),
          body: ((state.isLoading || info == null) && state.error == null)
              ? const RefreshProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: ListView(
                            children: state
                                .getAllKands()
                                .map((kand) => InkWell(
                                      onTap: () => GoRouter.of(context).pushNamed(Routing.ramcharitmanasKandVerses, pathParameters: {"kand": kand}),
                                      child: SizedBox(
                                        height: 60,
                                        child: Text(kand),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView(
                            children: state
                                .getAllKands()
                                .map((kand) => InkWell(
                                      onTap: () => GoRouter.of(context).pushNamed(Routing.ramcharitmanasMangalaCharan, pathParameters: {"kand": kand}),
                                      child: SizedBox(
                                        height: 60,
                                        child: Text("$kand Mangalacharan"),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
