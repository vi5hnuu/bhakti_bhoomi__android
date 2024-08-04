part of 'rigveda_bloc.dart';

@immutable
class RigvedaState extends Equatable  with WithHttpState{
  final RigvedaInfoModel? rigvedaInfo;
  final Map<String, RigvedaSuktaModel> _suktas; //verseId,verse

  RigvedaState({
    Map<String,HttpState>? httpStates,
    this.rigvedaInfo,
    Map<String, RigvedaSuktaModel> suktas = const {},
  }) : _suktas = suktas{
    this.httpStates.addAll(httpStates ?? {});
  }

  RigvedaState copyWith({
    Map<String, HttpState>? httpStates,
    RigvedaInfoModel? rigvedaInfo,
    Map<String, RigvedaSuktaModel>? suktas,
  }) {
    return RigvedaState(
      httpStates: httpStates ?? this.httpStates,
      rigvedaInfo: rigvedaInfo ?? this.rigvedaInfo,
      suktas: suktas ?? this._suktas,
    );
  }

  factory RigvedaState.initial() => RigvedaState();

  String _uniqueIdentifier({required int mandala, required int suktaNo}) => '${mandala}_$suktaNo';

  bool suktaExists({required int mandala, required int suktaNo}) => _suktas.containsKey(_uniqueIdentifier(mandala: mandala, suktaNo: suktaNo));

  RigvedaSuktaModel? getSukta({required int mandala, required int suktaNo}) => _suktas[_uniqueIdentifier(mandala: mandala, suktaNo: suktaNo)];

  static String commentForId({required int mandala, required int suktaNo}) {
    return 'mandalaNo_$mandala-suktaNo_$suktaNo';
  }

  MapEntry<String, RigvedaSuktaModel> getSuktaEntry(RigvedaSuktaModel sukta) => MapEntry(_uniqueIdentifier(mandala: sukta.mandala, suktaNo: sukta.sukta), sukta);

  Map<String, RigvedaSuktaModel> get allSuktas => Map.unmodifiable(_suktas);

  @override
  List<Object?> get props => [httpStates, rigvedaInfo, _suktas];
}
