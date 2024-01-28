import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BrahmasutraQuatersInfoScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const BrahmasutraQuatersInfoScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<BrahmasutraQuatersInfoScreen> createState() => _BrahmasutraQuatersInfoScreenState();
}

class _BrahmasutraQuatersInfoScreenState extends State<BrahmasutraQuatersInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mahabharat'),
        ),
        body: BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
          builder: (context, state) {
            final brahmasutraInfo = state.brahmasutraInfo;
            return (state.isLoading || brahmasutraInfo == null) && state.error == null
                ? RefreshProgressIndicator()
                : state.error != null
                    ? Text(state.error!)
                    : Column(
                        children: List.generate(
                            state.brahmasutraInfo!.chaptersInfo['${widget.chapterNo}']!.totalQuaters,
                            (index) => InkWell(
                                onTap: () => GoRouter.of(context).pushNamed(Routing.brahmasutra, pathParameters: {'chapterNo': '${widget.chapterNo}', 'quaterNo': '${index + 1}'}),
                                child: Text('${index + 1} quater'))),
                      );
          },
        ));
  }
}
