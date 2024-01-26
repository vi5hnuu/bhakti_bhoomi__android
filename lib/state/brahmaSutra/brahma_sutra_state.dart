part of 'brahma_sutra_bloc.dart';

@Immutable("instance BrahmaSutraState cannot be modified")
class BrahmaSutraState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<int, BrahmaSutraChapterInfoModel> _chaptersInfo; //chapterNo->chapterInfo
  final BrahmasutraInfoModel? brahmasutraInfo;
  final Map<String, BrahmaSutraModel> _brahmaSutras; //sutraId->brahmaSutraModel

  const BrahmaSutraState({
    this.isLoading = true,
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
      error: error,
      chaptersInfo: chaptersInfo ?? this._chaptersInfo,
      brahmasutraInfo: brahmasutraInfoModel ?? this.brahmasutraInfo,
      brahmaSutras: brahmaSutras ?? this._brahmaSutras,
    );
  }

  factory BrahmaSutraState.initial() => const BrahmaSutraState();

  get chaptersInfo => Map.unmodifiable(_chaptersInfo);

  get brahmaSutras => Map.unmodifiable(_brahmaSutras);

  @override
  List<Object?> get props => [isLoading, error, _chaptersInfo, brahmasutraInfo, _brahmaSutras];
}
