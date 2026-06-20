import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';

/// Local-only persistence for the Practice features (Japa Mala counter and the
/// "Your Journey" streak/stats). Uses the existing encrypted secure storage so
/// no backend is required.
class PracticeStore {
  PracticeStore._();
  static final PracticeStore instance = PracticeStore._();

  final _storage = SecureStorage().storage;

  static const _kTotalRounds = 'practice_japa_total_rounds';
  static const _kTotalBeads = 'practice_japa_total_beads';
  static const _kStreak = 'practice_streak';
  static const _kLastActiveDate = 'practice_last_active_date';
  static const _kMeditateMinutes = 'practice_meditate_minutes';

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<int> _getInt(String key) async => int.tryParse(await _storage.read(key: key) ?? '') ?? 0;
  Future<void> _setInt(String key, int v) => _storage.write(key: key, value: '$v');

  Future<int> totalRounds() => _getInt(_kTotalRounds);
  Future<int> totalBeads() => _getInt(_kTotalBeads);
  Future<int> meditateMinutes() => _getInt(_kMeditateMinutes);

  /// Records one completed mala (108 beads) and updates the streak.
  Future<void> addRound() async {
    await _setInt(_kTotalRounds, await totalRounds() + 1);
    await _setInt(_kTotalBeads, await totalBeads() + 108);
    await _touchStreak();
  }

  /// Records a single bead tap towards the running total.
  Future<void> addBead() async {
    await _setInt(_kTotalBeads, await totalBeads() + 1);
    await _touchStreak();
  }

  Future<void> addMeditateMinutes(int minutes) async {
    await _setInt(_kMeditateMinutes, await meditateMinutes() + minutes);
    await _touchStreak();
  }

  Future<int> streak() async {
    final last = await _storage.read(key: _kLastActiveDate);
    if (last == null) return 0;
    // Streak is valid only if last activity was today or yesterday.
    final today = DateTime.now();
    final y = DateTime(today.year, today.month, today.day - 1);
    final yesterday = '${y.year}-${y.month}-${y.day}';
    if (last == _today() || last == yesterday) return await _getInt(_kStreak);
    return 0;
  }

  /// Marks the user active today, incrementing the streak across day boundaries.
  Future<void> _touchStreak() async {
    final last = await _storage.read(key: _kLastActiveDate);
    final today = _today();
    if (last == today) return; // already counted today
    final y = DateTime.now().subtract(const Duration(days: 1));
    final yesterday = '${y.year}-${y.month}-${y.day}';
    final current = await _getInt(_kStreak);
    final next = last == yesterday ? current + 1 : 1;
    await _setInt(_kStreak, next);
    await _storage.write(key: _kLastActiveDate, value: today);
  }
}
