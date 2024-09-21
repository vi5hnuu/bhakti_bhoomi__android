import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanKandsScreen.dart';
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanSargasScreen.dart';
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanShlokScreen.dart';
import 'package:go_router/go_router.dart';

final valmikiRamayanRoutes=GoRoute(
  path: BBR.Routing.valmikiRamayanKandsInfo.baseUrl,
  redirect: (context, state) => state.fullPath == BBR.Routing.valmikiRamayanKandsInfo.baseUrl ? BBR.Routing.valmikiRamayanKandsInfo.fullPath : null,
  routes: [
    GoRoute(
      name: BBR.Routing.valmikiRamayanKandsInfo.name,
      path: BBR.Routing.valmikiRamayanKandsInfo.path,
      builder: (context, state) => const ValmikiRamayanKandsScreen(title: 'Valmiki Ramayan kanda')),
    GoRoute(
      name: BBR.Routing.valmikiRamayanSargasInfo.name,
      path: BBR.Routing.valmikiRamayanSargasInfo.path,
      builder: (context, state) => ValmikiRamayanSargasScreen(title: 'Valmiki Ramayan', kand: state.pathParameters['kand']!)),
    GoRoute(
      name: BBR.Routing.valmikiRamayanShlok.name,
      path: BBR.Routing.valmikiRamayanShlok.path,
      builder: (context, state) => ValmikiRamayanShlokScreen(title: 'Valmiki Ramayan', kand: state.pathParameters['kand']!, sargaNo: int.parse(state.pathParameters['sargaNo']!)))
  ]);
