part of 'rigveda_bloc.dart';

@immutable
class RigvedaState extends Equatable {
  final bool isLoading;
  final String? error;
  final RigvedaInfoModel? rigvedaInfo;
  final Map<String, RigvedaVerseModel> _verses; //verseId,verse

  RigvedaState({
    this.isLoading = false,
    this.error,
    this.rigvedaInfo,
    Map<String, RigvedaVerseModel> verses = const {},
  }) : _verses = verses;

  RigvedaState copyWith({
    bool? isLoading,
    String? error,
    RigvedaInfoModel? rigvedaInfo,
    Map<String, RigvedaVerseModel>? verses,
  }) {
    return RigvedaState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      rigvedaInfo: rigvedaInfo ?? this.rigvedaInfo,
      verses: verses ?? this._verses,
    );
  }

  factory RigvedaState.initial() => RigvedaState();
  factory RigvedaState.loading() => RigvedaState(isLoading: true);
  factory RigvedaState.failure(String error) => RigvedaState(error: error);
  factory RigvedaState.success(RigvedaInfoModel rigvedaInfo, Map<String, RigvedaVerseModel> verses) => RigvedaState(
        rigvedaInfo: rigvedaInfo,
        verses: verses,
      );

  get allVerses => Map.unmodifiable(_verses);
  void addVerse(RigvedaVerseModel verse) {
    _verses[verse.id] = verse;
  }

  @override
  List<Object?> get props => [isLoading, error, rigvedaInfo, _verses];
}
