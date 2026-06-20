import 'package:bhakti_bhoomi/services/practice/practice_store.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Design #04 — Japa Mala: a 108-bead counter on a calm dark surface.
/// Tapping anywhere counts a bead; completing a mala records a round and
/// advances the streak (all stored locally via [PracticeStore]).
class JapaMalaScreen extends StatefulWidget {
  const JapaMalaScreen({super.key});

  @override
  State<JapaMalaScreen> createState() => _JapaMalaScreenState();
}

class _JapaMalaScreenState extends State<JapaMalaScreen> {
  static const _mala = 108;
  int _count = 0;
  int _rounds = 0;
  final DateTime _start = DateTime.now();

  @override
  void initState() {
    PracticeStore.instance.totalRounds().then((v) => mounted ? setState(() => _rounds = v) : null);
    super.initState();
  }

  void _tap() {
    HapticFeedback.lightImpact();
    setState(() {
      _count++;
      if (_count >= _mala) {
        _count = 0;
        _rounds++;
        PracticeStore.instance.addRound();
        HapticFeedback.heavyImpact();
      } else {
        PracticeStore.instance.addBead();
      }
    });
  }

  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    final minutes = DateTime.now().difference(_start).inMinutes;
    final seconds = DateTime.now().difference(_start).inSeconds % 60;
    return Scaffold(
      backgroundColor: AppColors.darkSurface,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _tap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded, color: AppColors.textFaint)),
                    const Spacer(),
                    IconButton(onPressed: _reset, icon: const Icon(Icons.refresh_rounded, color: AppColors.textFaint)),
                  ],
                ),
                const Spacer(),
                Text('ॐ नमः शिवाय', style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 28, color: AppColors.onAccent)),
                const SizedBox(height: 4),
                Text('Om Namah Shivaya', style: TextStyle(color: AppColors.textFaint, fontSize: 13)),
                const SizedBox(height: 36),
                GoldCircularProgress(
                  value: _count / _mala,
                  size: 260,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$_count', style: const TextStyle(fontFamily: AppFonts.display, fontSize: 72, color: AppColors.onAccent, height: 1.0)),
                      Text('of $_mala', style: TextStyle(color: AppColors.textFaint, fontSize: 14)),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat('$_rounds', 'rounds'),
                    _stat('$minutes:${seconds.toString().padLeft(2, '0')}', 'minutes'),
                  ],
                ),
                const SizedBox(height: 12),
                Text('tap anywhere to count', style: TextStyle(color: AppColors.textFaint.withValues(alpha: 0.7), fontSize: 12)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.textTheme.headlineMedium!.copyWith(color: AppColors.gold)),
        Text(label, style: TextStyle(color: AppColors.textFaint, fontSize: 12)),
      ],
    );
  }
}
