import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/mantra/MantraInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraScreen.dart';
import 'package:go_router/go_router.dart';

final mantraRoutes=GoRoute(
  path: '/mantra',
  redirect: (context, state) => state.fullPath == '/mantra' ? "${state.path!}/${BBR.Routing.mantraInfo.path}" : null,
  routes: [
    GoRoute(
      name: BBR.Routing.mantraInfo.name,
      path: BBR.Routing.mantraInfo.path,
      builder: (context, state) => const MantraInfoScreen(title: 'Mantra')),
    GoRoute(
      name: BBR.Routing.mantra.name,
      path: BBR.Routing.mantra.path,
      builder: (context, state) => MantraScreen(title: 'Mantra', mantraId: state.pathParameters['mantraId']!))
  ]);
