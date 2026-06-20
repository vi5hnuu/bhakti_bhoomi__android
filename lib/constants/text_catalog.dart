import 'package:bhakti_bhoomi/routing/routes.dart';

/// Tradition a sacred text belongs to (used by the Library filter chips).
enum Tradition { hindu, sikh }

/// Metadata for one sacred text shown in the Library / Home catalog.
class SacredText {
  final String id;
  final String name; // English / transliteration
  final String nameNative; // Devanagari / Gurmukhi
  final String abbrev; // medallion glyph (native abbreviation)
  final String subtitle; // e.g. "18 chapters · 700 verses"
  final String routeName; // go_router entry route name
  final Tradition tradition;

  const SacredText({
    required this.id,
    required this.name,
    required this.nameNative,
    required this.abbrev,
    required this.subtitle,
    required this.routeName,
    required this.tradition,
  });
}

/// The full catalog of texts available in the app, in display order.
/// `routeName` values map to the existing entry routes in [Routing].
final List<SacredText> kSacredTexts = [
  SacredText(id: 'bhagvad-geeta', name: 'Bhagavad Gita', nameNative: 'श्रीमद्भगवद्गीता', abbrev: 'गी', subtitle: '18 chapters · 700 verses', routeName: Routing.bhagvadGeetaChapters.name, tradition: Tradition.hindu),
  SacredText(id: 'valmiki-ramayan', name: 'Valmiki Ramayan', nameNative: 'वाल्मीकि रामायण', abbrev: 'रा', subtitle: '7 kandas', routeName: Routing.valmikiRamayanKandsInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'mahabharat', name: 'Mahabharat', nameNative: 'महाभारत', abbrev: 'मा', subtitle: '18 parvas', routeName: Routing.mahabharatBookInfos.name, tradition: Tradition.hindu),
  SacredText(id: 'ramcharitmanas', name: 'Ramcharitmanas', nameNative: 'रामचरितमानस', abbrev: 'रा', subtitle: '7 kands', routeName: Routing.ramcharitmanasInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'rigveda', name: 'Rig Veda', nameNative: 'ऋग्वेद', abbrev: 'ऋ', subtitle: '10 mandalas', routeName: Routing.rigvedaMandalasInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'yoga-sutra', name: 'Yoga Sutra', nameNative: 'योगसूत्र', abbrev: 'यो', subtitle: '4 chapters', routeName: Routing.yogaSutraChapters.name, tradition: Tradition.hindu),
  SacredText(id: 'chanakya-neeti', name: 'Chanakya Neeti', nameNative: 'चाणक्य नीति', abbrev: 'चा', subtitle: '17 chapters', routeName: Routing.chanakyaNitiChapters.name, tradition: Tradition.hindu),
  SacredText(id: 'brahma-sutra', name: 'Brahma Sutra', nameNative: 'ब्रह्मसूत्र', abbrev: 'ब्र', subtitle: '4 chapters', routeName: Routing.brahmasutraChaptersInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'aarti', name: 'Aarti', nameNative: 'आरती', abbrev: 'आ', subtitle: 'Devotional songs', routeName: Routing.aartiInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'chalisa', name: 'Chalisa', nameNative: 'चालीसा', abbrev: 'चा', subtitle: 'Forty-verse hymns', routeName: Routing.chalisaInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'mantra', name: 'Mantra', nameNative: 'मंत्र', abbrev: 'ॐ', subtitle: 'Sacred chants', routeName: Routing.mantraInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'vrat-katha', name: 'Vrat Katha', nameNative: 'व्रत कथा', abbrev: 'व्र', subtitle: 'Fasting stories', routeName: Routing.vratKathaInfo.name, tradition: Tradition.hindu),
  SacredText(id: 'guru-granth-sahib', name: 'Guru Granth Sahib', nameNative: 'ਗੁਰੂ ਗ੍ਰੰਥ ਸਾਹਿਬ', abbrev: 'ੴ', subtitle: 'Ragas & shabads', routeName: Routing.guruGranthSahibInfo.name, tradition: Tradition.sikh),
];
