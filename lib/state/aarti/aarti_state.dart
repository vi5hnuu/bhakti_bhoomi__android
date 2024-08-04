part of 'aarti_bloc.dart';

@Immutable("cannot modify aarti state")
class AartiState extends Equatable with WithHttpState {
  final Map<String, AartiModel> aartis; //aartiId,aarti
  final List<AartiInfoModel> aartisInfo; //aartiId,aartiInfo

  AartiState._({
    Map<String,HttpState>? httpStates,
    required Map<String, AartiModel> aartis,
    required List<AartiInfoModel> aartisInfo,
  })  : this.aartis = aartis,
        this.aartisInfo = aartisInfo{
    this.httpStates.addAll(httpStates ?? {});
  }

  AartiState.initial()
      : this._(
          httpStates: const {},
          aartis: const {},
          aartisInfo: const [],
        );

  AartiState copyWith({
    Map<String, HttpState>? httpStates,
    Map<String, AartiModel>? aartis,
    List<AartiInfoModel>? aartisInfo,
  }) {
    return AartiState._(
      httpStates: httpStates ?? this.httpStates,
      aartis: aartis ?? this.aartis,
      aartisInfo: aartisInfo ?? this.aartisInfo,
    );
  }

  AartiModel? getAarti(String aartiId) {
    return aartis[aartiId];
  }

  @override
  List<Object?> get props => [httpStates, aartis, aartisInfo];
}
