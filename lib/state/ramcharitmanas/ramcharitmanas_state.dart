part of 'ramcharitmanas_bloc.dart';

@immutable
class RamcharitmanasState extends Equatable {
  final bool isLoading;
  final String? error;
  final RamcharitmanasInfoModel? info;
  final Map<String, RamcharitmanasMangalacharanModel> _mangalacharan; //mangalacharanId, mangalacharan
  final Map<String, RamcharitmanasVerseModel> _verses; //verseId, verse

  RamcharitmanasState({
    this.isLoading = true,
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

  get allMangalacharan => Map.unmodifiable(_mangalacharan);

  get allVerses => Map.unmodifiable(_verses);

  @override
  List<Object?> get props => [isLoading, error, info, _mangalacharan, _verses];
}
