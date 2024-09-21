import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/mantra/MantraInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraScreen.dart';
import 'package:go_router/go_router.dart';

final mantraRoutes=GoRoute(
  path: BBR.Routing.mantraInfo.baseUrl,
  redirect: (context, state) => state.fullPath == BBR.Routing.mantraInfo.baseUrl ? BBR.Routing.mantraInfo.fullPath : null,
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
