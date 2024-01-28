part of 'aarti_bloc.dart';

@Immutable("cannot modify aarti state")
class AartiState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<String, AartiModel> aartis; //aartiId,aarti
  final List<AartiInfoModel> aartisInfo; //aartiId,aartiInfo

  const AartiState._({
    this.isLoading = true,
    this.error,
    required Map<String, AartiModel> aartis,
    required List<AartiInfoModel> aartisInfo,
  })  : this.aartis = aartis,
        this.aartisInfo = aartisInfo;

  const AartiState.initial()
      : this._(
          aartis: const {},
          aartisInfo: const [],
        );

  AartiState copyWith({
    bool? isLoading,
    String? error,
    Map<String, AartiModel>? aartis,
    List<AartiInfoModel>? aartisInfo,
  }) {
    return AartiState._(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      aartis: aartis ?? this.aartis,
      aartisInfo: aartisInfo ?? this.aartisInfo,
    );
  }

  AartiModel? getAarti(String aartiId) {
    return aartis[aartiId];
  }

  @override
  List<Object?> get props => [isLoading, error, aartis, aartisInfo];
}
