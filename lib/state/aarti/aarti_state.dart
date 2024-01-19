part of 'aarti_bloc.dart';

@immutable
class AartiState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<String, AartiModel> _aarti; //aartiId,aarti
  final Map<String, AartiInfoModel> _aartiInfo; //aartiId,aartiInfo

  const AartiState({this.isLoading = false, this.error, Map<String, AartiModel> aarti = const {}, Map<String, AartiInfoModel> aartiInfo = const {}})
      : _aartiInfo = aartiInfo,
        _aarti = aarti;

  AartiState copyWith({
    bool? isLoading,
    String? error,
    Map<String, AartiModel>? aarti,
    Map<String, AartiInfoModel>? aartiInfo,
  }) {
    return AartiState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      aarti: aarti ?? this._aarti,
      aartiInfo: aartiInfo ?? this._aartiInfo,
    );
  }

  get aartis => Map.unmodifiable(_aarti);
  void addAarti(AartiModel aarti) {
    _aarti[aarti.id] = aarti;
  }

  get aartisInfo => Map.unmodifiable(_aartiInfo);
  void addAartiInfo(AartiInfoModel aartiInfo) {
    _aartiInfo[aartiInfo.id] = aartiInfo;
  }

  factory AartiState.initial() => AartiState();
  factory AartiState.loading() => AartiState(isLoading: true);
  factory AartiState.failure(String error) => AartiState(error: error);
  factory AartiState.success(Map<String, AartiModel> aarti, Map<String, AartiInfoModel> aartiInfo) => AartiState(aarti: aarti, aartiInfo: aartiInfo);

  @override
  List<Object?> get props => [isLoading, error, _aarti, _aartiInfo];
}
