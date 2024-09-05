import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasMagalaCharanScreen.dart';
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasVersesScreen.dart';
import 'package:go_router/go_router.dart';

final ramcharitmanasRoutes=GoRoute(
  path: '/ramcharitmanas',
  redirect: (context, state) => state.fullPath == '/ramcharitmanas' ? "${state.path!}/${BBR.Routing.ramcharitmanasInfo.path}" : null,
  routes: [
    GoRoute(
      name: BBR.Routing.ramcharitmanasInfo.name,
      path: BBR.Routing.ramcharitmanasInfo.path,
      builder: (context, state) => const RamcharitmanasInfoScreen(title: 'RamCharitManas')),
    GoRoute(
      name: BBR.Routing.ramcharitmanasKandVerses.name,
      path: BBR.Routing.ramcharitmanasKandVerses.path,
      builder: (context, state) => RamcharitmanasVersesScreen(title: 'RamCharitManas', kand: state.pathParameters['kand']!)),
    GoRoute(
      name: BBR.Routing.ramcharitmanasMangalaCharan.name,
      path: BBR.Routing.ramcharitmanasMangalaCharan.path,
      builder: (context, state) => RamcharitmanasMangalacharanScreen(title: 'RamCharitManas', kand: state.pathParameters['kand']!))
  ]);
