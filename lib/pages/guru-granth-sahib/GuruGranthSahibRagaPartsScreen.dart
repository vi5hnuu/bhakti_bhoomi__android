import 'package:bhakti_bhoomi/state/guruGranthSahib/guru_granth_sahib_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CustomDropDownMenu.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuruGranthSahibRagaPartsScreen extends StatefulWidget {
  final String title;
  final int ragaNo;

  const GuruGranthSahibRagaPartsScreen({super.key, required this.ragaNo, required this.title});

  @override
  State<GuruGranthSahibRagaPartsScreen> createState() => _GuruGranthSahibRagaPartsScreenState();
}

class _GuruGranthSahibRagaPartsScreenState extends State<GuruGranthSahibRagaPartsScreen> {
  CancelToken cancelToken = CancelToken();
  int selectedPart=1;
  double fontSize=16;

  @override
  void initState() {
    initRaga(ragaNo: widget.ragaNo,partNo: selectedPart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuruGranthSahibBloc, GuruGranthSahibState>(
      buildWhen: (previous, current) => previous!=current,
      builder: (context, state) {
        final raga= state.getRaga(ragaNo: widget.ragaNo,partNo: selectedPart);
        final ragaInfo=state.getInfo()!.ragasInfo[widget.ragaNo-1];

        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Raga : ${widget.ragaNo} | Part $selectedPart",
                style: const TextStyle(color: Colors.white,
                    fontFamily: "Kalam",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(onPressed: fontSize<=14 ? null : ()=>setState(() => fontSize-=1), icon: const Icon(Icons.remove)),
                IconButton(onPressed: fontSize>=32 ? null : ()=>setState(() => fontSize+=1), icon: const Icon(Icons.add)),
              ],
            ),
            body:raga!=null ?  Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 15),child: CustomDropDownMenu(
                    initialSelection: selectedPart.toString(),
                    onSelected: (value) => setState(() {
                      selectedPart=int.parse(value!);
                      initRaga(ragaNo: widget.ragaNo,partNo: selectedPart);
                    }),
                    label: "Select Part | ${raga.ragaName}",
                    dropdownMenuEntries: List.generate(ragaInfo.totalParts, (index) => DropdownMenuEntry(label: "Part ${index+1}",value: (index+1).toString()))),),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: raga.text.length,
                  itemBuilder: (context, index) =>
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(raga.text[index],style: TextStyle(fontSize: fontSize),)
                      ),
                ))
              ],
            ):
            (Center(child: state.isError(forr: Httpstates.GURU_GRANTH_SAHIB_RAGA) ? RetryAgain(onRetry: ()=>initRaga(ragaNo: widget.ragaNo,partNo: selectedPart), error: state.getError(forr: Httpstates.GURU_GRANTH_SAHIB_RAGA)!.message) : const CircularProgressIndicator())));
      },
    );
  }

  initRaga({required int ragaNo,required int partNo}) {
    cancelToken.cancel("cancelled");
    BlocProvider.of<GuruGranthSahibBloc>(context).add(FetchGuruGranthSahibRagaByRagaNoPartNo(ragaNo: ragaNo,partNo: partNo, cancelToken: cancelToken=CancelToken()));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
