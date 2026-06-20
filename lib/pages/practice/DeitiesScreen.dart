import 'dart:io';

import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _Deity {
  final String id, name, nameNative;
  final bool goddess;
  const _Deity(this.id, this.name, this.nameNative, {this.goddess = false});
}

const _deities = [
  _Deity('shiva', 'Shiva', 'शिव'),
  _Deity('vishnu', 'Vishnu', 'विष्णु'),
  _Deity('krishna', 'Krishna', 'कृष्ण'),
  _Deity('rama', 'Rama', 'राम'),
  _Deity('hanuman', 'Hanuman', 'हनुमान'),
  _Deity('ganesha', 'Ganesha', 'गणेश'),
  _Deity('lakshmi', 'Lakshmi', 'लक्ष्मी', goddess: true),
  _Deity('durga', 'Durga', 'दुर्गा', goddess: true),
  _Deity('saraswati', 'Saraswati', 'सरस्वती', goddess: true),
];

/// Design #22 — Deities: a portrait for every god & goddess. Each medallion is
/// a fillable slot — tap to set your own deity art (stored locally).
class DeitiesScreen extends StatefulWidget {
  const DeitiesScreen({super.key});

  @override
  State<DeitiesScreen> createState() => _DeitiesScreenState();
}

class _DeitiesScreenState extends State<DeitiesScreen> {
  final _picker = ImagePicker();
  final _storage = SecureStorage().storage;
  final Map<String, String> _paths = {};

  @override
  void initState() {
    _loadPaths();
    super.initState();
  }

  Future<void> _loadPaths() async {
    for (final d in _deities) {
      final p = await _storage.read(key: 'deity_img_${d.id}');
      if (p != null && File(p).existsSync()) _paths[d.id] = p;
    }
    if (mounted) setState(() {});
  }

  Future<void> _pick(_Deity d) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    await _storage.write(key: 'deity_img_${d.id}', value: picked.path);
    setState(() => _paths[d.id] = picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Deities',
      subtitle: 'देवी–देवता',
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.78),
        itemCount: _deities.length,
        itemBuilder: (context, index) {
          final d = _deities[index];
          final path = _paths[d.id];
          final tint = d.goddess ? const Color(0xFFB57A8C) : AppColors.gold;
          return GestureDetector(
            onTap: () => _pick(d),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: path == null ? LinearGradient(colors: [tint, tint.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                    image: path != null ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover) : null,
                    border: Border.all(color: tint, width: 2),
                  ),
                  child: path == null
                      ? Center(child: Text('or browse\nfiles', textAlign: TextAlign.center, style: TextStyle(color: AppColors.onAccent.withValues(alpha: 0.85), fontSize: 10)))
                      : null,
                ),
                const SizedBox(height: 8),
                Text(d.name, style: AppTypography.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(d.nameNative, style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          );
        },
      ),
    );
  }
}
