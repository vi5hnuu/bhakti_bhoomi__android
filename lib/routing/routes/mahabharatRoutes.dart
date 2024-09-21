import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatBooksInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatChaptersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatShlokScreen.dart';
import 'package:go_router/go_router.dart';

final mahabharatRoutes=GoRoute(
  path: BBR.Routing.mahabharatBookInfos.baseUrl,
  redirect: (context, state) => state.fullPath == BBR.Routing.mahabharatBookInfos.baseUrl ? BBR.Routing.mahabharatBookInfos.fullPath : null,
  routes: [
    GoRoute(
      name: BBR.Routing.mahabharatBookInfos.name,
      path: BBR.Routing.mahabharatBookInfos.path,
      builder: (context, state) => MahabharatBookInfoScreen(title: 'MahaBharat')),
    GoRoute(
        name: BBR.Routing.mahabharatBookChaptersInfos.name,
        path: BBR.Routing.mahabharatBookChaptersInfos.path,
        builder: (context, state) => MahabharatChaptersInfoScreen(title: 'Mahabharat', bookNo: int.parse(state.pathParameters['bookNo']!))),
    GoRoute(
        name: BBR.Routing.mahabharatBookChapterShloks.name,
        path: BBR.Routing.mahabharatBookChapterShloks.path,
        builder: (context, state) => MahabharatShlokScreen(
          title: 'Mahabharat',
          bookNo: int.parse(state.pathParameters['bookNo']!),
          chapterNo: int.parse(state.pathParameters['chapterNo']!),
        ))
  ]);
