import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/vrat-katha/VratKathaInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/vrat-katha/VratKathaScreen.dart';
import 'package:go_router/go_router.dart';

final vratKathaRoutes=GoRoute(
  path: '/vrat-katha',
  redirect: (context, state) => state.fullPath == '/vrat-katha' ? "${state.path!}/${BBR.Routing.vratKathaInfo.path}" : null,
  routes: [
    GoRoute(
      name: BBR.Routing.vratKathaInfo.name,
      path: BBR.Routing.vratKathaInfo.path,
      builder: (context, state) => const VratKathaInfoScreen(title: "Vrat Katha's")),
    GoRoute(
      name: BBR.Routing.vratKatha.name,
      path: BBR.Routing.vratKatha.path,
      builder: (context, state) => VratKathaScreen(kathaId: state.pathParameters['kathaId']!,title: 'Vrat Katha')),
  ]);
