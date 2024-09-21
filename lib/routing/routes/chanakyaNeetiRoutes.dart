import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiShlokScreen.dart';
import 'package:go_router/go_router.dart';

final chanakyaNeetiRoutes=GoRoute(
  path: BBR.Routing.chanakyaNitiChapters.baseUrl,
  redirect: (context, state) => state.fullPath == BBR.Routing.chanakyaNitiChapters.baseUrl ? BBR.Routing.chanakyaNitiChapters.fullPath : null,
  routes: [GoRoute(
    name: BBR.Routing.chanakyaNitiChapters.name,
    path: BBR.Routing.chanakyaNitiChapters.path,
    builder: (context, state) => const ChanakyaNeetiChaptersScreen(title: 'ChanaKya Niti')),
    GoRoute(
      name: BBR.Routing.chanakyaNitiChapterShlok.name,
      path: BBR.Routing.chanakyaNitiChapterShlok.path,
      builder: (context, state) => ChanakyaNeetiShlokScreen(title: 'ChanaKya Niti', chapterNo: int.parse(state.pathParameters['chapterNo']!)))
  ]);
