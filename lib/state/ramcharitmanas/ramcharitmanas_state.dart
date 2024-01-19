part of 'ramcharitmanas_bloc.dart';

@immutable
class RamcharitmanasState extends Equatable {
  final bool isLoading;
  final String? error;
  final RamcharitmanasInfoModel? info;
  final Map<String, RamcharitmanasMangalacharanModel> _mangalacharan; //mangalacharanId, mangalacharan
  final Map<String, RamcharitmanasVerseModel> _verses; //verseId, verse

  RamcharitmanasState({
    this.isLoading = false,
    this.error,
    this.info,
    Map<String, RamcharitmanasMangalacharanModel> mangalacharan = const {},
    Map<String, RamcharitmanasVerseModel> verses = const {},
  })  : _verses = verses,
        _mangalacharan = mangalacharan;

  RamcharitmanasState copyWith({
    bool? isLoading,
    String? error,
    RamcharitmanasInfoModel? info,
    Map<String, RamcharitmanasMangalacharanModel>? mangalacharan,
    Map<String, RamcharitmanasVerseModel>? verses,
  }) {
    return RamcharitmanasState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      info: info ?? this.info,
      mangalacharan: mangalacharan ?? this._mangalacharan,
      verses: verses ?? this._verses,
    );
  }

  factory RamcharitmanasState.initial() => RamcharitmanasState();
  factory RamcharitmanasState.loading() => RamcharitmanasState(isLoading: true);
  factory RamcharitmanasState.error(String error) => RamcharitmanasState(error: error);
  factory RamcharitmanasState.success({
    required RamcharitmanasInfoModel info,
    required Map<String, RamcharitmanasMangalacharanModel> mangalacharan,
    required Map<String, RamcharitmanasVerseModel> verses,
  }) =>
      RamcharitmanasState(
        info: info,
        mangalacharan: mangalacharan,
        verses: verses,
      );

  get allMangalacharan => Map.unmodifiable(_mangalacharan);
  void addMangalacharan(RamcharitmanasMangalacharanModel mangalacharan) {
    _mangalacharan[mangalacharan.id] = mangalacharan;
  }

  get allVerses => Map.unmodifiable(_verses);
  void addVerse(RamcharitmanasVerseModel verse) {
    _verses[verse.id] = verse;
  }

  @override
  List<Object?> get props => [isLoading, error, info, _mangalacharan, _verses];
}
