import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaShlokScreen.dart';
import 'package:go_router/go_router.dart';

final bhagvadGeetaRoutes=GoRoute(
  path: '/bhagvad-geeta',
  redirect: (context, state) => state.fullPath == '/bhagvad-geeta' ? "${state.path!}/${BBR.Routing.bhagvadGeetaChapters.path}" : null,
  routes: [GoRoute(
    name: BBR.Routing.bhagvadGeetaChapters.name,
    path: BBR.Routing.bhagvadGeetaChapters.path,
    builder: (context, state) => const BhagvadGeetaChaptersScreen(title: 'Bhagvad Geeta')),
    GoRoute(
      name: BBR.Routing.bhagvadGeetaChapterShloks.name,
      path: BBR.Routing.bhagvadGeetaChapterShloks.path,
      builder: (context, state) => BhagvadGeetaShlokScreen(title: 'Bhagvad Geeta shlok', chapterNo: int.parse(state.pathParameters['chapterNo']!)))
  ]);
