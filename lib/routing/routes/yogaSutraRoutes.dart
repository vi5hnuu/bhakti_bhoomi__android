import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/yogasutra/YogaSutraChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/yogasutra/YogaSutraScreen.dart';
import 'package:go_router/go_router.dart';

final yogaSutraRoutes=GoRoute(
  path: '/yoga-sutra',
  redirect: (context, state) => state.fullPath == '/yoga-sutra' ? "${state.path!}/${BBR.Routing.yogaSutraChapters.path}" : null,
  routes: [
    GoRoute(
      name: BBR.Routing.yogaSutraChapters.name,
      path: BBR.Routing.yogaSutraChapters.path,
      builder: (context, state) => const YogaSutraChaptersScreen(title: 'Yoga Sutra')),
    GoRoute(
      name: BBR.Routing.yogaSutra.name,
      path: BBR.Routing.yogaSutra.path,
      builder: (context, state) => YogaSutraScreen(title: 'Yoga Sutra', chapterNo: int.parse(state.pathParameters['chapterNo']!)))
  ]);
