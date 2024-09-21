import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaScreen.dart';
import 'package:go_router/go_router.dart';

final chalisaRoutes=GoRoute(
    path: BBR.Routing.chalisaInfo.baseUrl,
    redirect: (context, state) => state.fullPath == BBR.Routing.chalisaInfo.baseUrl ? BBR.Routing.chalisaInfo.fullPath : null,
    routes: [
      GoRoute(
        name: BBR.Routing.chalisaInfo.name,
        path: BBR.Routing.chalisaInfo.path,
        builder: (context, state) => const ChalisaInfoScreen(title: 'Chalisa')),
      GoRoute(
        name: BBR.Routing.chalisa.name,
        path: BBR.Routing.chalisa.path,
        builder: (context, state) => ChalisaScreen(title: 'Chalisa', chalisaId: state.pathParameters['chalisaId']!))
    ]);
