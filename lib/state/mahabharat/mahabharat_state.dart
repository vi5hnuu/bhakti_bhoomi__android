part of 'mahabharat_bloc.dart';

@immutable
class MahabharatState extends Equatable with WithHttpState{
  final List<MahabharatBookInfoModel>? _booksInfo; //bookInfo
  final Map<String, MahabharatShlokModel> _shloks; //bookNo_chapterNo_shlokNo,shlokInfo

  MahabharatState({
    Map<String,HttpState>? httpStates,
    List<MahabharatBookInfoModel>? bookInfo,
    Map<String, MahabharatShlokModel> shloks = const {},
  })  : _shloks = shloks,
        _booksInfo = bookInfo{
    this.httpStates.addAll(httpStates ?? {});
  }

  MahabharatState copyWith({
    Map<String, HttpState>? httpStates,
    List<MahabharatBookInfoModel>? bookInfo,
    Map<String, MahabharatShlokModel>? shloks,
  }) {
    return MahabharatState(
      httpStates: httpStates ?? this.httpStates,
      bookInfo: bookInfo ?? this._booksInfo,
      shloks: shloks ?? this._shloks,
    );
  }

  factory MahabharatState.initial() => MahabharatState();

  List<MahabharatBookInfoModel>? get allBooksInfo => _booksInfo != null ? List.unmodifiable(_booksInfo) : null;
  MahabharatBookInfoModel? getBooksInfo({required int bookNo}) => allBooksInfo?[bookNo - 1];

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

  static String commentForId({required int bookNo, required int chapterNo, required int shlokNo}) {
    return 'bookNo_$bookNo-chapterNo_${chapterNo}-shlokNo_${shlokNo}';
  }

  @override
  List<Object?> get props => [httpStates, _booksInfo, _shloks];
}
