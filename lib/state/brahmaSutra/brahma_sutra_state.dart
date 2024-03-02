part of 'brahma_sutra_bloc.dart';

@Immutable("instance BrahmaSutraState cannot be modified")
class BrahmaSutraState extends Equatable {
  final bool isLoading;
  final String? error;
  final BrahmasutraInfoModel? brahmasutraInfo;
  final Map<String, BrahmaSutraModel> _brahmaSutras; //_uniqueKey,brahmaSutraModel
  static final String defaultLang = "dv";

  const BrahmaSutraState({
    this.isLoading = true,
    this.error,
    this.brahmasutraInfo,
    Map<String, BrahmaSutraModel> brahmaSutras = const {},
  }) : _brahmaSutras = brahmaSutras;

  BrahmaSutraState copyWith({
    bool? isLoading,
    String? error,
    BrahmasutraInfoModel? brahmasutraInfo,
    Map<String, BrahmaSutraModel>? brahmaSutras,
  }) {
    return BrahmaSutraState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      brahmasutraInfo: brahmasutraInfo ?? this.brahmasutraInfo,
      brahmaSutras: brahmaSutras ?? this._brahmaSutras,
    );
  }

  factory BrahmaSutraState.initial() => const BrahmaSutraState();

  Map<String, BrahmaSutraModel> get brahmaSutras => Map.unmodifiable(_brahmaSutras);

  String _uniqueIdentifier({required int chapterNo, required int quaterNo, required int sutraNo, required String? lang}) {
    return "$chapterNo-$quaterNo-$sutraNo-${lang ?? defaultLang}";
  }

  bool brahmaSutraExists({required int chapterNo, required int quaterNo, required int sutraNo, String? lang}) {
    return _brahmaSutras.containsKey(_uniqueIdentifier(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo, lang: lang));
  }

  int? totalSutras({required int chapterNo, required int quaterNo}) {
    return brahmasutraInfo?.chaptersInfo['$chapterNo']?.totalSutras['$quaterNo'];
  }

  MapEntry<String, BrahmaSutraModel> getBrahmaSutraEntry({required BrahmaSutraModel brahmaSutra}) {
    return MapEntry<String, BrahmaSutraModel>(
        _uniqueIdentifier(chapterNo: brahmaSutra.chapterNo, quaterNo: brahmaSutra.quaterNo, sutraNo: brahmaSutra.sutraNo, lang: brahmaSutra.language), brahmaSutra);
  }

  BrahmaSutraModel? getBrahmaSutra({required int chapterNo, required int quaterNo, required int sutraNo, String? lang}) {
    return _brahmaSutras[_uniqueIdentifier(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo, lang: lang)];
  }

  static String commentForId({required int chapterNo, required int quaterNo, required int sutraNo, required String lang}) {
    return 'chapterNo_$chapterNo-quaterNo_$quaterNo-sutraNo_$sutraNo-lang_$lang';
  }

  @override
  List<Object?> get props => [isLoading, error, brahmasutraInfo, _brahmaSutras];
}
