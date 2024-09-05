import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/rigveda/RigvedaMandalasInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/rigveda/RigvedaSuktaScreen.dart';
import 'package:go_router/go_router.dart';

final rigVedaRoutes=GoRoute(
  path: '/rig-veda',
  redirect: (context, state) => state.fullPath == '/rig-veda' ? "${state.path!}/${BBR.Routing.rigvedaMandalasInfo.path}" : null,
  routes: [
    GoRoute(
      name: BBR.Routing.rigvedaMandalasInfo.name,
      path: BBR.Routing.rigvedaMandalasInfo.path,
      builder: (context, state) => const RigvedaMandalasInfoScreen(title: 'RigVeda')),
    GoRoute(
      name: BBR.Routing.rigvedaMandalaSuktas.name,
      path: BBR.Routing.rigvedaMandalaSuktas.path,
      builder: (context, state) => RigvedaSuktaScreen(title: 'RigVeda', mandala: int.parse(state.pathParameters['mandala']!)))
  ]);
