import 'package:bhakti_bhoomi/services/practice/reminders_service.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:flutter/material.dart';

class _Ritual {
  final int id;
  final String name, nameNative;
  final int defH, defM;
  const _Ritual(this.id, this.name, this.nameNative, this.defH, this.defM);
}

const _rituals = [
  _Ritual(1, 'Morning prayer', 'प्रातः वंदना', 6, 0),
  _Ritual(2, 'Japa', 'जप', 7, 0),
  _Ritual(3, 'Evening lamp', 'संध्या दीप', 18, 30),
  _Ritual(4, 'Aarti', 'आरती', 19, 0),
  _Ritual(5, 'Gratitude', 'कृतज्ञता', 21, 0),
];

/// Design #39 — Daily rituals & reminders. Each ritual can be toggled on with a
/// time; enabling schedules a repeating local notification via [RemindersService].
class RitualsScreen extends StatefulWidget {
  const RitualsScreen({super.key});

  @override
  State<RitualsScreen> createState() => _RitualsScreenState();
}

class _RitualsScreenState extends State<RitualsScreen> {
  final _storage = SecureStorage().storage;
  final Map<int, bool> _on = {};
  final Map<int, TimeOfDay> _time = {};

  @override
  void initState() {
    _load();
    super.initState();
  }

  Future<void> _load() async {
    for (final r in _rituals) {
      _on[r.id] = (await _storage.read(key: 'ritual_${r.id}_on')) == 'true';
      final h = int.tryParse(await _storage.read(key: 'ritual_${r.id}_h') ?? '') ?? r.defH;
      final m = int.tryParse(await _storage.read(key: 'ritual_${r.id}_m') ?? '') ?? r.defM;
      _time[r.id] = TimeOfDay(hour: h, minute: m);
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggle(_Ritual r, bool value) async {
    setState(() => _on[r.id] = value);
    await _storage.write(key: 'ritual_${r.id}_on', value: '$value');
    final t = _time[r.id]!;
    if (value) {
      await RemindersService.instance.scheduleDaily(id: r.id, title: r.name, body: 'Time for ${r.nameNative} · ${r.name}', hour: t.hour, minute: t.minute);
    } else {
      await RemindersService.instance.cancel(r.id);
    }
  }

  Future<void> _pickTime(_Ritual r) async {
    final picked = await showTimePicker(context: context, initialTime: _time[r.id] ?? TimeOfDay(hour: r.defH, minute: r.defM));
    if (picked == null) return;
    setState(() => _time[r.id] = picked);
    await _storage.write(key: 'ritual_${r.id}_h', value: '${picked.hour}');
    await _storage.write(key: 'ritual_${r.id}_m', value: '${picked.minute}');
    if (_on[r.id] == true) {
      await RemindersService.instance.scheduleDaily(id: r.id, title: r.name, body: 'Time for ${r.nameNative} · ${r.name}', hour: picked.hour, minute: picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Daily Rituals',
      subtitle: 'नित्य कर्म · reminders',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: _rituals.map((r) {
          final on = _on[r.id] ?? false;
          final t = _time[r.id] ?? TimeOfDay(hour: r.defH, minute: r.defM);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name, style: AppTypography.textTheme.titleMedium),
                        Text(r.nameNative, style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickTime(r),
                    child: Text(t.format(context), style: AppTypography.textTheme.titleSmall!.copyWith(color: on ? AppColors.terracotta : AppColors.textFaint)),
                  ),
                  Switch(
                    value: on,
                    activeColor: AppColors.terracotta,
                    onChanged: (v) => _toggle(r, v),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
