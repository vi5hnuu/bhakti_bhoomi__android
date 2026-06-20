import 'package:bhakti_bhoomi/services/apis/PanchangApi.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Design #38 — Festivals: major Hindu festivals for the year, derived from the
/// backend Panchang.
class FestivalsScreen extends StatefulWidget {
  const FestivalsScreen({super.key});

  @override
  State<FestivalsScreen> createState() => _FestivalsScreenState();
}

class _FestivalsScreenState extends State<FestivalsScreen> {
  int _year = DateTime.now().year;
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    _future = PanchangApi().getFestivals(year: _year);
    super.initState();
  }

  void _shiftYear(int delta) {
    setState(() {
      _year += delta;
      _future = PanchangApi().getFestivals(year: _year);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Festivals',
      subtitle: 'पर्व · $_year',
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Row(
          children: [
            IconButton(onPressed: () => _shiftYear(-1), icon: const Icon(Icons.chevron_left_rounded)),
            Expanded(child: Center(child: Text('$_year', style: AppTypography.textTheme.titleMedium))),
            IconButton(onPressed: () => _shiftYear(1), icon: const Icon(Icons.chevron_right_rounded)),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const AppLoader();
          if (snap.hasError || !snap.hasData) {
            return RetryAgain(onRetry: () => setState(() => _future = PanchangApi().getFestivals(year: _year)), error: 'Could not load festivals');
          }
          final festivals = snap.data!;
          final now = DateTime.now();
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            itemCount: festivals.length,
            itemBuilder: (context, i) {
              final f = festivals[i] as Map;
              final date = DateTime.tryParse('${f['date']}');
              final upcoming = date != null && !date.isBefore(DateTime(now.year, now.month, now.day));
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: upcoming ? AppColors.terracotta.withValues(alpha: 0.12) : AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(date != null ? DateFormat('MMM').format(date) : '', style: AppTypography.textTheme.labelSmall),
                            Text(date != null ? '${date.day}' : '', style: AppTypography.textTheme.titleMedium!.copyWith(color: AppColors.terracotta)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${f['name']}', style: AppTypography.textTheme.titleMedium),
                            Text('${f['nameNative']} · ${f['masa']} ${f['paksha']}',
                                style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 13, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
