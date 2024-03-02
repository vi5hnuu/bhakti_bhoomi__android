part of 'rigveda_bloc.dart';

@immutable
class RigvedaState extends Equatable {
  final bool isLoading;
  final String? error;
  final RigvedaInfoModel? rigvedaInfo;
  final Map<String, RigvedaSuktaModel> _suktas; //verseId,verse

  RigvedaState({
    this.isLoading = true,
    this.error,
    this.rigvedaInfo,
    Map<String, RigvedaSuktaModel> suktas = const {},
  }) : _suktas = suktas;

  RigvedaState copyWith({
    bool? isLoading,
    String? error,
    RigvedaInfoModel? rigvedaInfo,
    Map<String, RigvedaSuktaModel>? suktas,
  }) {
    return RigvedaState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
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
  List<Object?> get props => [isLoading, error, rigvedaInfo, _suktas];
}
