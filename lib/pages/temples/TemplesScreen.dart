import 'package:bhakti_bhoomi/services/apis/TempleApi.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Design #06 — Temples & Darshan: a curated list of major temples with a tap
/// to open directions.
class TemplesScreen extends StatefulWidget {
  const TemplesScreen({super.key});

  @override
  State<TemplesScreen> createState() => _TemplesScreenState();
}

class _TemplesScreenState extends State<TemplesScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    _future = TempleApi().list();
    super.initState();
  }

  Future<void> _directions(Map t) async {
    final lat = t['lat'], lng = t['lng'];
    if (lat == null || lng == null) return;
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Temples',
      subtitle: 'मंदिर · दर्शन',
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const AppLoader();
          if (snap.hasError) return RetryAgain(onRetry: () => setState(() => _future = TempleApi().list()), error: 'Could not load temples');
          final temples = snap.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            itemCount: temples.length,
            itemBuilder: (context, i) {
              final t = temples[i] as Map;
              final img = t['imageUrl'] as String?;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () => _directions(t),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: img != null
                            ? CachedNetworkImage(imageUrl: img, width: 60, height: 60, fit: BoxFit.cover)
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold, AppColors.goldDeep])),
                                child: const Icon(Icons.temple_hindu_rounded, color: AppColors.onAccent),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t['name']}', style: AppTypography.textTheme.titleMedium),
                            Text('${t['nameNative'] ?? ''} · ${t['deity'] ?? ''}',
                                style: TextStyle(fontFamily: AppScript.familyFor('${t['nameNative']}'), fontSize: 13, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text('${t['city']}, ${t['state']}', style: AppTypography.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      const Icon(Icons.directions_outlined, color: AppColors.terracotta),
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
