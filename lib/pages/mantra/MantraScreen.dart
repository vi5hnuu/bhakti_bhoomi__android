import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MantraScreen extends StatefulWidget {
  final String title;
  final String mantraId;
  const MantraScreen({super.key, required this.title, required this.mantraId});

  @override
  State<MantraScreen> createState() => _MantraScreenState();
}

class _MantraScreenState extends State<MantraScreen> {
  CancelToken token = CancelToken();

  @override
  initState() {
    initMantraById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraBloc, MantraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mantra = state.getMantraById(mantraId: widget.mantraId);
        return Scaffold(
            appBar: AppBar(
              title: Text(
                state.hasHttpState(forr: Httpstates.MANTRA_BY_ID) || mantra == null ? 'Mantra' : mantra.title,
                style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: mantra != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: _getMantras(mantras: mantra.mantras),
                      ),
                    ),
                  )
                : state.isError(forr: Httpstates.MANTRA_BY_ID)
                    ? Center(child: RetryAgain(onRetry: initMantraById,error: state.getError(forr: Httpstates.MANTRA_BY_ID)!))
                    : const Center(child: CircularProgressIndicator()));
      },
    );
  }

  List<Widget> _getMantras({required List<MantraModel>? mantras, bool inner = false}) {
    if (mantras == null) return List.empty();
    return mantras
        .map((mantra) => Padding(
              padding: EdgeInsets.only(left: 5 + (inner ? 24 : 0), right: 5, top: 5, bottom: 5),
              child: ExpansionTile(
                  backgroundColor: Theme.of(context).primaryColor,
                  collapsedBackgroundColor: Theme.of(context).primaryColor,
                  childrenPadding: const EdgeInsets.all(5),
                  collapsedTextColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text(mantra.title, style: const TextStyle(color: Colors.white)),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    if (_hasDescription(mantra.description))
                      Padding(
                        padding: EdgeInsets.only(left: 12 + (inner ? 24 : 0)),
                        child: _getDescription(mantra.description),
                      ),
                    if (_hasDescription(mantra.description) && mantra.translations != null) const SizedBox(height: 12),
                    if (mantra.translations != null)
                      Padding(
                        padding: EdgeInsets.only(left: 12 + (inner ? 24 : 0)),
                        child: _getTransLations(mantra.translations!),
                      ),
                    ..._getMantras(mantras: mantra.subMantras, inner: true)
                  ]),
            ))
        .toList();
  }

  _getDescription(Map<String, String> description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (description['hi'] != null && description['hi']!.isNotEmpty) ...[
          const Text(
            'Hindi : ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            description['hi']!,
            style: const TextStyle(color: Colors.white),
          )
        ],
        if (_hasDescription(description)) const SizedBox(height: 12),
        if (description['eng'] != null && description['eng']!.isNotEmpty) ...[
          const Text(
            'English : ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            description['eng']!,
            style: const TextStyle(color: Colors.white),
          )
        ]
      ],
    );
  }

  bool _hasDescription(Map<String, String> description) {
    return (description['hi'] != null && description['hi']!.isNotEmpty) || (description['eng'] != null && description['eng']!.isNotEmpty);
  }

  _getTransLations(Map<String, List<String>> translations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Translations', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (translations['hi'] != null && translations['hi']!.isNotEmpty) ...[
          const Text(
            'Hindi : ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            translations['hi']!.join(''),
            style: const TextStyle(color: Colors.white),
          )
        ],
        const SizedBox(height: 12),
        if (translations['eng'] != null && translations['eng']!.isNotEmpty) ...[
          const Text(
            'English : ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            translations['eng']!.join(''),
            style: const TextStyle(color: Colors.white),
          )
        ]
      ],
    );
  }

  initMantraById(){
    BlocProvider.of<MantraBloc>(context).add(FetchMantraById(id: widget.mantraId, cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
