part of 'mahabharat_bloc.dart';

@immutable
class MahabharatState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<int, MahabharatBookInfoModel> _bookInfo; //bookNo,bookInfo
  final Map<String, MahabharatShlokModel> _shloks; //shlokId,shlokInfo

  MahabharatState({
    this.isLoading = false,
    this.error,
    Map<int, MahabharatBookInfoModel> bookInfo = const {},
    Map<String, MahabharatShlokModel> shloks = const {},
  })  : _shloks = shloks,
        _bookInfo = bookInfo;

  MahabharatState copyWith({
    bool? isLoading,
    String? error,
    Map<int, MahabharatBookInfoModel>? bookInfo,
    Map<String, MahabharatShlokModel>? shloks,
  }) {
    return MahabharatState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      bookInfo: bookInfo ?? this._bookInfo,
      shloks: shloks ?? this._shloks,
    );
  }

  factory MahabharatState.initial() => MahabharatState();
  factory MahabharatState.loading() => MahabharatState(isLoading: true);
  factory MahabharatState.error(String error) => MahabharatState(error: error);
  factory MahabharatState.success(Map<int, MahabharatBookInfoModel> bookInfo, Map<String, MahabharatShlokModel> shloks) => MahabharatState(bookInfo: bookInfo, shloks: shloks);

  get allBookInfo => Map.unmodifiable(_bookInfo);
  void addBookInfo(MahabharatBookInfoModel bookInfo) => _bookInfo[bookInfo.bookNo] = bookInfo;

  get allShloks => Map.unmodifiable(_shloks);
  void addShlok(MahabharatShlokModel shlok) => _shloks[shlok.id] = shlok;

  @override
  List<Object?> get props => [isLoading, error, _bookInfo, _shloks];
}
