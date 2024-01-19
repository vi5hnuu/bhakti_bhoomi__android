part of 'brahma_sutra_bloc.dart';

class BrahmaSutraState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<int, BrahmaSutraChapterInfoModel> _chaptersInfo; //chapterNo->chapterInfo
  final BrahmasutraInfoModel? brahmasutraInfo;
  final Map<String, BrahmaSutraModel> _brahmaSutras; //sutraId->brahmaSutraModel

  const BrahmaSutraState({
    this.isLoading = false,
    this.error,
    Map<int, BrahmaSutraChapterInfoModel> chaptersInfo = const {},
    this.brahmasutraInfo,
    Map<String, BrahmaSutraModel> brahmaSutras = const {},
  })  : _brahmaSutras = brahmaSutras,
        _chaptersInfo = chaptersInfo;

  BrahmaSutraState copyWith({
    bool? isLoading,
    String? error,
    Map<int, BrahmaSutraChapterInfoModel>? chaptersInfo,
    BrahmasutraInfoModel? brahmasutraInfoModel,
    Map<String, BrahmaSutraModel>? brahmaSutras,
  }) {
    return BrahmaSutraState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      chaptersInfo: chaptersInfo ?? this._chaptersInfo,
      brahmasutraInfo: brahmasutraInfoModel ?? this.brahmasutraInfo,
      brahmaSutras: brahmaSutras ?? this._brahmaSutras,
    );
  }

  factory BrahmaSutraState.initial() => const BrahmaSutraState();
  factory BrahmaSutraState.loading() => const BrahmaSutraState(isLoading: true);
  factory BrahmaSutraState.failure(String error) => BrahmaSutraState(error: error);
  factory BrahmaSutraState.success(Map<int, BrahmaSutraChapterInfoModel> chaptersInfo, BrahmasutraInfoModel brahmasutraInfoModel, Map<String, BrahmaSutraModel> brahmaSutras) =>
      BrahmaSutraState(chaptersInfo: chaptersInfo, brahmasutraInfo: brahmasutraInfoModel, brahmaSutras: brahmaSutras);

  get chaptersInfo => Map.unmodifiable(_chaptersInfo);
  void addChapterInfo(int chapterNo, BrahmaSutraChapterInfoModel chapterInfo) {
    _chaptersInfo[chapterNo] = chapterInfo;
  }

  get brahmaSutras => Map.unmodifiable(_brahmaSutras);
  void addBrahmaSutra(BrahmaSutraModel brahmaSutra) {
    _brahmaSutras[brahmaSutra.id] = brahmaSutra;
  }

  @override
  List<Object?> get props => [isLoading, error, _chaptersInfo, brahmasutraInfo, _brahmaSutras];
}
