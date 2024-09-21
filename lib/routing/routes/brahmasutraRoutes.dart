import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraChaptersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraQuatersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraScreen.dart';
import 'package:go_router/go_router.dart';

final brahmasutraRoutes = GoRoute(
    path: BBR.Routing.brahmasutraChaptersInfo.baseUrl,
    redirect: (context, state) => state.fullPath == BBR.Routing.brahmasutraChaptersInfo.baseUrl ? BBR.Routing.brahmasutraChaptersInfo.fullPath : null,
    routes: [
      GoRoute(
      name: BBR.Routing.brahmasutraChaptersInfo.name,
      path: BBR.Routing.brahmasutraChaptersInfo.path,
      builder: (context, state) => const BrahmasutraChaptersInfoScreen(title: 'Brahmasutra')),
      GoRoute(
        name: BBR.Routing.brahmasutraQuatersInfo.name,
        path: BBR.Routing.brahmasutraQuatersInfo.path,
        builder: (context, state) => BrahmasutraQuatersInfoScreen(title: 'Brahmasutra', chapterNo: int.parse(state.pathParameters['chapterNo']!))),
      GoRoute(
        name: BBR.Routing.brahmasutra.name,
        path: BBR.Routing.brahmasutra.path,
        builder: (context, state) => BrahmasutraScreen(title: 'Brahmasutra', chapterNo: int.parse(state.pathParameters['chapterNo']!), quaterNo: int.parse(state.pathParameters['quaterNo']!)))
    ]);
