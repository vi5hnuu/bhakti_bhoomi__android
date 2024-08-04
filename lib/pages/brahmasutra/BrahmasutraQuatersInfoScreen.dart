import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          title: Text('BrahmaSutra | chapter ${widget.chapterNo}', style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
          builder: (context, state) {
            final brahmasutraInfo = state.brahmasutraInfo;
            return brahmasutraInfo != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: Column(
                      children: List.generate(
                          state.brahmasutraInfo!.chaptersInfo['${widget.chapterNo}']!.totalQuaters,
                          (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: RoundedListTile(
                                  itemNo: index + 1,
                                  text: "quater",
                                  onTap: () => GoRouter.of(context).pushNamed(Routing.brahmasutra, pathParameters: {'chapterNo': '${widget.chapterNo}', 'quaterNo': '${index + 1}'}),
                                ),
                              )),
                    ),
                  )
                : state.isError(forr: Httpstates.BRAHMA_SUTRA_INFO)
                    ? Center(child: Text(state.getError(forr: Httpstates.BRAHMA_SUTRA_INFO)!))//useless..wont occur
                    : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor));//wont occur
          },
        ));
  }
}
