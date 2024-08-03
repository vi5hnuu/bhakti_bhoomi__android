part of 'aarti_bloc.dart';

@Immutable("cannot modify aarti state")
class AartiState extends Equatable {
  final Map<String, HttpState> httpState;
  final Map<String, AartiModel> aartis; //aartiId,aarti
  final List<AartiInfoModel> aartisInfo; //aartiId,aartiInfo

  const AartiState._({
    required Map<String, HttpState> httpState,
    required Map<String, AartiModel> aartis,
    required List<AartiInfoModel> aartisInfo,
  })  : this.httpState = httpState,
        this.aartis = aartis,
        this.aartisInfo = aartisInfo;

  const AartiState.initial()
      : this._(
          httpState: const {},
          aartis: const {},
          aartisInfo: const [],
        );

  AartiState copyWith({
    Map<String, HttpState>? httpState,
    Map<String, AartiModel>? aartis,
    List<AartiInfoModel>? aartisInfo,
  }) {
    return AartiState._(
      httpState: httpState ?? this.httpState,
      aartis: aartis ?? this.aartis,
      aartisInfo: aartisInfo ?? this.aartisInfo,
    );
  }

  AartiModel? getAarti(String aartiId) {
    return aartis[aartiId];
  }

  @override
  List<Object?> get props => [httpState, aartis, aartisInfo];
}
