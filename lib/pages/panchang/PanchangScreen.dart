import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/services/apis/PanchangApi.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Design #37 — Panchang: today's Hindu almanac (tithi, nakshatra, yoga,
/// karana, vara, sunrise/sunset, masa, samvat) from the backend.
class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  DateTime _date = DateTime.now();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    _future = PanchangApi().getPanchang(date: _date);
    super.initState();
  }

  void _shiftDay(int days) {
    setState(() {
      _date = _date.add(Duration(days: days));
      _future = PanchangApi().getPanchang(date: _date);
    });
  }

  String _t(String? iso) {
    if (iso == null) return '—';
    try {
      return DateFormat('d MMM, h:mm a').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Panchang',
      subtitle: 'पंचांग · ${DateFormat('EEE, d MMM').format(_date)}',
      actions: [
        IconButton(onPressed: () => context.pushNamed(Routing.festivals.name), icon: const Icon(Icons.celebration_outlined)),
      ],
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Row(
          children: [
            IconButton(onPressed: () => _shiftDay(-1), icon: const Icon(Icons.chevron_left_rounded)),
            Expanded(child: Center(child: Text(DateFormat('EEEE, d MMMM yyyy').format(_date), style: AppTypography.textTheme.titleSmall))),
            IconButton(onPressed: () => _shiftDay(1), icon: const Icon(Icons.chevron_right_rounded)),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const AppLoader();
          if (snap.hasError || !snap.hasData) {
            return RetryAgain(onRetry: () => setState(() => _future = PanchangApi().getPanchang(date: _date)), error: 'Could not load panchang');
          }
          final p = snap.data!;
          final tithi = p['tithi'] as Map? ?? {};
          final nak = p['nakshatra'] as Map? ?? {};
          final yoga = p['yoga'] as Map? ?? {};
          final karana = p['karana'] as Map? ?? {};
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              // Hero summary
              AppCard(
                color: AppColors.darkSurface,
                borderColor: AppColors.darkSurface,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${p['masa'] ?? ''} · ${p['paksha'] ?? tithi['paksha'] ?? ''} · ${p['ritu'] ?? ''}',
                        style: AppTypography.sectionLabel.copyWith(color: AppColors.gold)),
                    const SizedBox(height: 10),
                    Text('${tithi['name'] ?? ''}', style: AppTypography.textTheme.displaySmall!.copyWith(color: AppColors.onAccent)),
                    Text('${nak['name'] ?? ''} nakshatra', style: const TextStyle(color: AppColors.textFaint, fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _hero('Sunrise', _time(p['sunrise'])),
                        const SizedBox(width: 24),
                        _hero('Sunset', _time(p['sunset'])),
                        const SizedBox(width: 24),
                        _hero('Vikram Samvat', '${p['vikramSamvat'] ?? ''}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionLabel('THE FIVE LIMBS · पंचांग'),
              const SizedBox(height: 12),
              _row('Tithi', '${tithi['name'] ?? ''} (${tithi['paksha'] ?? ''})', 'ends ${_t(tithi['endsAt'])}'),
              _row('Nakshatra', '${nak['name'] ?? ''}', 'ends ${_t(nak['endsAt'])}'),
              _row('Yoga', '${yoga['name'] ?? ''}', 'ends ${_t(yoga['endsAt'])}'),
              _row('Karana', '${karana['name'] ?? ''}', null),
              _row('Vara', '${p['vara'] ?? ''}', null),
              const SizedBox(height: 8),
              const SectionLabel('CALENDAR'),
              const SizedBox(height: 12),
              _row('Masa', '${p['masa'] ?? ''}', null),
              _row('Ritu', '${p['ritu'] ?? ''}', null),
              _row('Vikram Samvat', '${p['vikramSamvat'] ?? ''}', null),
              _row('Shaka Samvat', '${p['shakaSamvat'] ?? ''}', null),
            ],
          );
        },
      ),
    );
  }

  String _time(String? iso) {
    if (iso == null) return '—';
    try {
      return DateFormat('h:mm a').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  Widget _hero(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.textTheme.titleMedium!.copyWith(color: AppColors.gold)),
        Text(label, style: const TextStyle(color: AppColors.textFaint, fontSize: 11)),
      ],
    );
  }

  Widget _row(String label, String value, String? sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.textTheme.bodyMedium)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: AppTypography.textTheme.titleSmall),
                if (sub != null) Text(sub, style: AppTypography.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
