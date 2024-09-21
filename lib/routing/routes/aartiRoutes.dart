import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/aarti/AartiInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/aarti/AartiScreen.dart';
import 'package:go_router/go_router.dart';

final aartiRoutes=GoRoute(path: BBR.Routing.aartiInfo.baseUrl,
    redirect: (context, state) => state.fullPath == BBR.Routing.aartiInfo.baseUrl ? BBR.Routing.aartiInfo.fullPath : null,
    routes: [
      GoRoute(
        name: BBR.Routing.aartiInfo.name,
        path: BBR.Routing.aartiInfo.path,
        builder: (context, state) => const AartiInfoScreen(title: "Aarti's"),
      ),
      GoRoute(
        name: BBR.Routing.aarti.name,
        path: BBR.Routing.aarti.path,
        builder: (context, state) => AartiScreen(title: 'Aartis', aartiId: state.pathParameters['id']!),
      ),
    ]);