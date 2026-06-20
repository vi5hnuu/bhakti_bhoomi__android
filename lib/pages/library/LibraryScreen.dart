import 'package:bhakti_bhoomi/constants/text_catalog.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/pill_chip.dart';
import 'package:bhakti_bhoomi/widgets/common/text_medallion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Design #10 — Library: the central catalog of every sacred text, with
/// search and a tradition filter (All / Hindu / Sikh).
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Tradition? _filter; // null = All
  String _query = '';

  List<SacredText> get _filtered {
    final q = _query.trim().toLowerCase();
    return kSacredTexts.where((t) {
      final matchesTradition = _filter == null || t.tradition == _filter;
      final matchesQuery = q.isEmpty ||
          t.name.toLowerCase().contains(q) ||
          t.nameNative.contains(_query.trim()) ||
          t.subtitle.toLowerCase().contains(q);
      return matchesTradition && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Library', style: AppTypography.textTheme.displayMedium),
                    Text('सभी ग्रंथ · ${kSacredTexts.length} texts',
                        style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 14, color: AppColors.textMuted)),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: AppColors.textFaint),
                        hintText: 'Search texts, chapters, verses',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        PillChip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                        const SizedBox(width: 8),
                        PillChip(label: 'Hindu', selected: _filter == Tradition.hindu, onTap: () => setState(() => _filter = Tradition.hindu)),
                        const SizedBox(width: 8),
                        PillChip(label: 'Sikh', selected: _filter == Tradition.sikh, onTap: () => setState(() => _filter = Tradition.sikh)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = items[i];
                if (i == 0 || items[i - 1].tradition != t.tradition) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, i == 0 ? 8 : 20, 20, 10),
                        child: Text(
                          t.tradition == Tradition.sikh ? 'SIKH · ਸਿੱਖ' : 'SANATAN · सनातन',
                          style: AppTypography.sectionLabel,
                        ),
                      ),
                      _row(t),
                    ],
                  );
                }
                return _row(t);
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _row(SacredText t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppCard(
        onTap: () => context.pushNamed(t.routeName),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            TextMedallion(glyph: t.abbrev, sikh: t.tradition == Tradition.sikh),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.name, style: AppTypography.textTheme.titleMedium),
                  Text(t.nameNative,
                      style: TextStyle(fontFamily: AppScript.familyFor(t.nameNative), fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(t.subtitle, style: AppTypography.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}
