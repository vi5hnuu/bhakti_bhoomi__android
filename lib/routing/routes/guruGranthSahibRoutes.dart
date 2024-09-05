import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/guru-granth-sahib/GuruGranthSahibRagaPartsScreen.dart';
import 'package:bhakti_bhoomi/pages/guru-granth-sahib/GuruGranthSahibScreen.dart';
import 'package:go_router/go_router.dart';

final guruGranthSahibRoutes=GoRoute(
  path: '/guru-granth-sahib',
  redirect: (context, state) => state.fullPath == '/guru-granth-sahib' ? "${state.path!}/${BBR.Routing.guruGranthSahibInfo.path}" : null,
  routes: [
    GoRoute(
      name: BBR.Routing.guruGranthSahibInfo.name,
      path: BBR.Routing.guruGranthSahibInfo.path,
      builder: (context, state) => const GuruGranthSahibInfoScreen(title: 'Guru Granth Sahib')),
    GoRoute(
      name: BBR.Routing.guruGranthSahibRagaParts.name,
      path: BBR.Routing.guruGranthSahibRagaParts.path,
      builder: (context, state) => GuruGranthSahibRagaPartsScreen(ragaNo: int.parse(state.pathParameters['ragaNo']!),title: 'Guru Granth Sahib'))
  ]);
