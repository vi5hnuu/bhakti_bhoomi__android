import 'package:bhakti_bhoomi/pages/aarti/AartiInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/aarti/AartiScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/LoginScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/RegisterScreen.dart';
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraChaptersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraQuatersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraScreen.dart';
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaScreen.dart';
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/home/homeScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatBooksInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatChaptersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraScreen.dart';
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasMagalaCharanScreen.dart';
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasVersesScreen.dart';
import 'package:bhakti_bhoomi/pages/rigveda/RigvedaMandalasInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/rigveda/RigvedaSuktaScreen.dart';
import 'package:bhakti_bhoomi/pages/splash/Splash.dart';
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanKandsScreen.dart';
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanSargasScreen.dart';
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/yogasutra/YogaSutraChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/yogasutra/YogaSutraScreen.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/services/aarti/AartiRepository.dart';
import 'package:bhakti_bhoomi/services/auth/AuthRepository.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaRepository.dart';
import 'package:bhakti_bhoomi/services/brahmaSutra/BrahmaSutraRepository.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaRepository.dart';
import 'package:bhakti_bhoomi/services/chanakyaNeeti/ChanakyaNeetiRepository.dart';
import 'package:bhakti_bhoomi/services/mahabharat/MahabharatRepository.dart';
import 'package:bhakti_bhoomi/services/mantra/MantraRepository.dart';
import 'package:bhakti_bhoomi/services/ramayan/RamayanRepository.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaRepository.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraRepository.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AartiBloc>(create: (ctx) => AartiBloc(aartiRepository: AartiRepository())),
        BlocProvider<BrahmaSutraBloc>(create: (ctx) => BrahmaSutraBloc(brahmaSutraRepository: BrahmaSutraRepository())),
        BlocProvider<ChalisaBloc>(create: (ctx) => ChalisaBloc(chalisaRepository: ChalisaRepository())),
        BlocProvider<ChanakyaNeetiBloc>(create: (ctx) => ChanakyaNeetiBloc(chanakyaNeetiRepository: ChanakyaNeetiRepository())),
        BlocProvider<MahabharatBloc>(create: (ctx) => MahabharatBloc(mahabharatRepository: MahabharatRepository())),
        BlocProvider<MantraBloc>(create: (ctx) => MantraBloc(mantraRepository: MantraRepository())),
        BlocProvider<RamcharitmanasBloc>(create: (ctx) => RamcharitmanasBloc(ramcharitmanasRepository: RamcharitmanasRepository())),
        BlocProvider<RigvedaBloc>(create: (ctx) => RigvedaBloc(rigvedaRepository: RigvedaRepository())),
        BlocProvider<RamayanBloc>(create: (ctx) => RamayanBloc(ramayanRepository: RamayanRepository())),
        BlocProvider<BhagvadGeetaBloc>(create: (ctx) => BhagvadGeetaBloc(bhagvadGeetaRepository: BhagvadGeetaRepository())),
        BlocProvider<YogaSutraBloc>(create: (ctx) => YogaSutraBloc(yogaSutraRepository: YogaSutraRepository())),
        BlocProvider<AuthBloc>(lazy: false, create: (ctx) => AuthBloc(authRepository: AuthRepository()))
      ],
      child: MaterialApp.router(
        title: 'Spirtual Shakti',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
            debugLogDiagnostics: true,
            errorBuilder: (context, state) => const Home(title: 'Spirtual Shakti Error'),
            redirect: (context, state) {
              if (!['/register', '/login', '/splash'].contains(state.fullPath) && !BlocProvider.of<AuthBloc>(context).state.isAuthenticated) {
                return '/login';
              }
              return null;
            },
            initialLocation: '/splash',
            routes: [
              GoRoute(
                name: Routing.splash,
                path: '/splash',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: SplashScreen(title: "Splash"),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.login,
                path: '/login',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: LoginScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.register,
                path: '/register',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const RegisterScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.home,
                path: '/home',
                builder: (context, state) => const Home(title: 'Spirtual Shakti'),
              ),
              GoRoute(
                name: Routing.aartiInfo,
                path: '/aarti-info',
                builder: (context, state) => AartiInfoScreen(title: 'Aarti info'),
              ),
              GoRoute(
                name: Routing.aarti,
                path: '/aarti/:id',
                builder: (context, state) => AartiScreen(title: 'Aartis', aartiId: state.pathParameters['id']!),
              ),
              GoRoute(
                name: Routing.brahmasutraChaptersInfo,
                path: '/brahmasutra/chapters/info',
                builder: (context, state) => const BrahmasutraChaptersInfoScreen(title: 'Brahmasutra'),
              ),
              GoRoute(
                name: Routing.brahmasutraQuatersInfo,
                path: '/brahmasutra/chapter/:chapterNo/quaters/info',
                builder: (context, state) => BrahmasutraQuatersInfoScreen(title: 'Brahmasutra', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.brahmasutra,
                path: '/brahmasutra/chapter/:chapterNo/quater/:quaterNo/sutras',
                builder: (context, state) => BrahmasutraScreen(title: 'Brahmasutra', chapterNo: int.parse(state.pathParameters['chapterNo']!), quaterNo: int.parse(state.pathParameters['quaterNo']!)),
              ),
              GoRoute(
                name: Routing.chalisaInfo,
                path: '/chalisa/info',
                builder: (context, state) => const ChalisaInfoScreen(title: 'Chalisa'),
              ),
              GoRoute(
                name: Routing.chalisa,
                path: '/chalisa/:chalisaId',
                builder: (context, state) => ChalisaScreen(title: 'Chalisa', chalisaId: state.pathParameters['chalisaId']!),
              ),
              GoRoute(
                name: Routing.chanakyaNitiChapters,
                path: '/chanakya-niti-chapters',
                builder: (context, state) => const ChanakyaNeetiChaptersScreen(title: 'ChanaKya Niti'),
              ),
              GoRoute(
                name: Routing.chanakyaNitiChapterShlok,
                path: '/chanakya-niti/chapter/:chapterNo/shloks',
                builder: (context, state) => ChanakyaNeetiShlokScreen(title: 'ChanaKya Niti', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.mahabharatBookInfos,
                path: '/mahabharat-info',
                builder: (context, state) => MahabharatBookInfoScreen(title: 'MahaBharat'),
              ),
              GoRoute(
                  name: Routing.mahabharatBookChaptersInfos,
                  path: '/mahabharat/book/:bookNo/chapters',
                  builder: (context, state) => MahabharatChaptersInfoScreen(title: 'Mahabharat', bookNo: int.parse(state.pathParameters['bookNo']!))),
              GoRoute(
                  name: Routing.mahabharatBookChapterShloks,
                  path: '/mahabharat/book/:bookNo/chapter/:chapterNo/shloks',
                  builder: (context, state) => MahabharatShlokScreen(
                        title: 'Mahabharat',
                        bookNo: int.parse(state.pathParameters['bookNo']!),
                        chapterNo: int.parse(state.pathParameters['chapterNo']!),
                      )),
              GoRoute(
                name: Routing.mantraInfo,
                path: '/mantra/info',
                builder: (context, state) => const MantraInfoScreen(title: 'Mantra'),
              ),
              GoRoute(
                name: Routing.mantra,
                path: '/mantra/:mantraId',
                builder: (context, state) => MantraScreen(title: 'Mantra', mantraId: state.pathParameters['mantraId']!),
              ),
              GoRoute(
                name: Routing.ramcharitmanasInfo,
                path: '/ramcharitmanas-info',
                builder: (context, state) => const RamcharitmanasInfoScreen(title: 'RamCharitManas'),
              ),
              GoRoute(
                name: Routing.ramcharitmanasKandVerses,
                path: '/ramcharitmanas/kand/:kand/verses',
                builder: (context, state) => RamcharitmanasVersesScreen(title: 'RamCharitManas', kand: state.pathParameters['kand']!),
              ),
              GoRoute(
                name: Routing.ramcharitmanasMangalaCharan,
                path: '/ramcharitmanas/kand/:kand/mangalacharan',
                builder: (context, state) => RamcharitmanasMangalacharanScreen(title: 'RamCharitManas', kand: state.pathParameters['kand']!),
              ),
              GoRoute(
                name: Routing.rigvedaMandalasInfo,
                path: '/rigveda/mandalas/info',
                builder: (context, state) => const RigvedaMandalasInfoScreen(title: 'RigVeda'),
              ),
              GoRoute(
                name: Routing.rigvedaMandalaSuktas,
                path: '/rigveda/mandala/:mandala/suktas',
                builder: (context, state) => RigvedaSuktaScreen(title: 'RigVeda', mandala: int.parse(state.pathParameters['mandala']!)),
              ),
              GoRoute(
                name: Routing.valmikiRamayanKandsInfo,
                path: '/valmiki-ramayan/info',
                builder: (context, state) => const ValmikiRamayanKandsScreen(title: 'Valmiki Ramayan kanda'),
              ),
              GoRoute(
                name: Routing.valmikiRamayanSargasInfo,
                path: '/valmiki-ramayan/kand/:kand/sargas',
                builder: (context, state) => ValmikiRamayanSargasScreen(title: 'Valmiki Ramayan', kand: state.pathParameters['kand']!),
              ),
              GoRoute(
                name: Routing.valmikiRamayanShlok,
                path: '/valmiki-ramayan/kand/:kand/sarga/:sargaNo',
                builder: (context, state) => ValmikiRamayanShlokScreen(title: 'Valmiki Ramayan', kand: state.pathParameters['kand']!, sargaNo: int.parse(state.pathParameters['sargaNo']!)),
              ),
              GoRoute(
                name: Routing.bhagvadGeetaChapters,
                path: '/bhagvad-geeta-chapters',
                builder: (context, state) => BhagvadGeetaChaptersScreen(title: 'Bhagvad Geeta'),
              ),
              GoRoute(
                name: Routing.bhagvadGeetaChapterShloks,
                path: '/bhagvad-geeta/chapter/:chapterNo/shloks',
                builder: (context, state) => BhagvadGeetaShlokScreen(title: 'Bhagvad Geeta shlok', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.yogaSutraChapters,
                path: '/yoga-sutra/chapters',
                builder: (context, state) => const YogaSutraChapters(title: 'Yoga Sutra'),
              ),
              GoRoute(
                name: Routing.yogaSutra,
                path: '/yoga-sutra/chapter/:chapterNo',
                builder: (context, state) => YogaSutraScreen(title: 'Yoga Sutra', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
            ]),
      ),
    );
  }
}
