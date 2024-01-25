part of 'mahabharat_bloc.dart';

@immutable
class MahabharatState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<MahabharatBookInfoModel>? _booksInfo; //bookInfo
  final Map<String, MahabharatShlokModel> _shloks; //bookNo_chapterNo_shlokNo,shlokInfo

  MahabharatState({
    this.isLoading = true,
    this.error,
    List<MahabharatBookInfoModel>? bookInfo,
    Map<String, MahabharatShlokModel> shloks = const {},
  })  : _shloks = shloks,
        _booksInfo = bookInfo;

  MahabharatState copyWith({
    bool? isLoading,
    String? error,
    List<MahabharatBookInfoModel>? bookInfo,
    Map<String, MahabharatShlokModel>? shloks,
  }) {
    return MahabharatState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      bookInfo: bookInfo ?? this._booksInfo,
      shloks: shloks ?? this._shloks,
    );
  }

  factory MahabharatState.initial() => MahabharatState();

  List<MahabharatBookInfoModel>? get allBooksInfo => _booksInfo != null ? List.unmodifiable(_booksInfo) : null;
  Map<String, MahabharatShlokModel> get allShloks => Map.unmodifiable(_shloks);

  bool existsShlokByKey({required String shlokId}) => allShloks[shlokId] != null;
  bool existsShlokByValue({required int bookNo, required int chapterNo, required int shlokNo}) {
    return allShloks[_keyIdentifier(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo)] != null;
  }

  int totalVerses({required int bookNo, required int chapterNo}) {
    var totalVerses = allBooksInfo?[bookNo - 1].info['${chapterNo}'];
    if (totalVerses == null) throw Exception("BookInfo not found");
    return totalVerses;
  }

  static String _keyIdentifier({required int bookNo, required int chapterNo, required int shlokNo}) {
    return '${bookNo}_${chapterNo}_${shlokNo}';
  }

  static MapEntry<String, MahabharatShlokModel> shlokEntry(MahabharatShlokModel shlok) {
    return MapEntry<String, MahabharatShlokModel>(_keyIdentifier(bookNo: shlok.book, chapterNo: shlok.chapter, shlokNo: shlok.shlokNo), shlok);
  }

  MahabharatShlokModel? getShlok({required int bookNo, required int chapterNo, required int shlokNo}) {
    return allShloks[_keyIdentifier(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo)];
  }

  @override
  List<Object?> get props => [isLoading, error, _booksInfo, _shloks];
}
