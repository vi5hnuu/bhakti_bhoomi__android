import 'dart:async';
import 'package:bhakti_bhoomi/pages/about-us/AboutUsScreen.dart';
import 'package:bhakti_bhoomi/pages/bookmarks/BookmarksScreen.dart';
import 'package:bhakti_bhoomi/pages/createPost/CreatePostScreen.dart';
import 'package:bhakti_bhoomi/pages/home/homeScreen.dart';
import 'package:bhakti_bhoomi/pages/library/LibraryScreen.dart';
import 'package:bhakti_bhoomi/pages/shell/MainShell.dart';
import 'package:bhakti_bhoomi/pages/shell/PracticeScreen.dart';
import 'package:bhakti_bhoomi/pages/shell/CommunityScreen.dart';
import 'package:bhakti_bhoomi/pages/shell/ProfileTabScreen.dart';
import 'package:bhakti_bhoomi/pages/welcome/WelcomeScreen.dart';
import 'package:bhakti_bhoomi/pages/practice/JapaMalaScreen.dart';
import 'package:bhakti_bhoomi/pages/practice/JourneyScreen.dart';
import 'package:bhakti_bhoomi/pages/practice/DeitiesScreen.dart';
import 'package:bhakti_bhoomi/pages/practice/RitualsScreen.dart';
import 'package:bhakti_bhoomi/pages/splash/Splash.dart';
import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;
import 'package:bhakti_bhoomi/routing/routes/aartiRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/authRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/bhagvadGeetaRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/brahmasutraRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/chalisaRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/chanakyaNeetiRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/guruGranthSahibRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/mahabharatRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/mantraRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/ramcharitmanasRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/rigVedaRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/valmikiRamayanRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/vratKathaRoutes.dart';
import 'package:bhakti_bhoomi/routing/routes/yogaSutraRoutes.dart';
import 'package:bhakti_bhoomi/services/aarti/AartiRepository.dart';
import 'package:bhakti_bhoomi/services/auth/AuthRepository.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaRepository.dart';
import 'package:bhakti_bhoomi/services/brahmaSutra/BrahmaSutraRepository.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaRepository.dart';
import 'package:bhakti_bhoomi/services/chanakyaNeeti/ChanakyaNeetiRepository.dart';
import 'package:bhakti_bhoomi/services/guruGranthSahib/GuruGranthSahibRepository.dart';
import 'package:bhakti_bhoomi/services/mahabharat/MahabharatRepository.dart';
import 'package:bhakti_bhoomi/services/mantra/MantraRepository.dart';
import 'package:bhakti_bhoomi/services/ramayan/RamayanRepository.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaRepository.dart';
import 'package:bhakti_bhoomi/services/vratKatha/AartiRepository.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraRepository.dart';
import 'package:bhakti_bhoomi/singletons/AudioPlayerSingleton.dart';
import 'package:bhakti_bhoomi/singletons/GlobalEventDispatcherSingleton.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:bhakti_bhoomi/state/guruGranthSahib/guru_granth_sahib_bloc.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/vratkatha/vratKatha_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:bhakti_bhoomi/theme/app_theme.dart';

final parentNavKey=GlobalKey<NavigatorState>();

void main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Routes that require the user to be authenticated
  static final _authRequiredPaths = [
    BBR.Routing.profile.fullPath,
  ];
  final router=GoRouter(
      debugLogDiagnostics: false,
      redirect: (context, state) {
        final authState=BlocProvider.of<AuthBloc>(context).state;
        final fullPath = state.fullPath ?? '';
        // Redirect to home if authenticated user tries to open login/register
        final authScreenPaths = [BBR.Routing.login.fullPath, BBR.Routing.register.fullPath];
        if (authScreenPaths.contains(fullPath) && authState.isAuthenticated) {
          return BBR.Routing.home.fullPath;
        }
        // Protect routes that require login (profile, etc.)
        if (_authRequiredPaths.any((p) => fullPath.startsWith(p)) && !authState.isAuthenticated) {
          return BBR.Routing.login.fullPath;
        }
        // Admin-only routes
        if (fullPath.startsWith("/admin") && !authState.isAdmin) {
          return BBR.Routing.home.fullPath;
        }
        return null;
      },
      observers: [GoRouterObserver()],
      initialLocation: BBR.Routing.splash.path,
      routes: [
        GoRoute(
          name: BBR.Routing.splash.name,
          path: BBR.Routing.splash.path,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashScreen(title: "Splash"),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          name: BBR.Routing.aboutUs.name,
          path: BBR.Routing.aboutUs.path,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const AboutUsScreen(title: "About Us"),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          name: BBR.Routing.createPost.name,
          path: BBR.Routing.createPost.path,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const CreatePostScreen(title: "Create Post"),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          name: BBR.Routing.welcome.name,
          path: BBR.Routing.welcome.path,
          builder: (context, state) => const WelcomeScreen(),
        ),
        // Practice features (local) — pushed over the shell.
        GoRoute(name: BBR.Routing.japa.name, path: BBR.Routing.japa.path, builder: (context, state) => const JapaMalaScreen()),
        GoRoute(name: BBR.Routing.journey.name, path: BBR.Routing.journey.path, builder: (context, state) => const JourneyScreen()),
        GoRoute(name: BBR.Routing.deities.name, path: BBR.Routing.deities.path, builder: (context, state) => const DeitiesScreen()),
        GoRoute(name: BBR.Routing.rituals.name, path: BBR.Routing.rituals.path, builder: (context, state) => const RitualsScreen()),
        // Bottom-nav shell: the five primary destinations. Detail screens are
        // pushed on the root navigator so they cover the bottom bar.
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                name: BBR.Routing.home.name,
                path: BBR.Routing.home.path,
                builder: (context, state) => const Home(title: 'Bhakti Bhoomi'),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: BBR.Routing.library.name,
                path: BBR.Routing.library.path,
                builder: (context, state) => const LibraryScreen(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: BBR.Routing.practice.name,
                path: BBR.Routing.practice.path,
                builder: (context, state) => const PracticeScreen(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: BBR.Routing.community.name,
                path: BBR.Routing.community.path,
                builder: (context, state) => const CommunityScreen(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: BBR.Routing.profileTab.name,
                path: BBR.Routing.profileTab.path,
                builder: (context, state) => const ProfileTabScreen(),
              ),
            ]),
          ],
        ),
        GoRoute(
          name: BBR.Routing.bookmarks.name,
          path: BBR.Routing.bookmarks.path,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const BookmarksScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          ),
        ),
        authRoutes,
        aartiRoutes,
        brahmasutraRoutes,
        chalisaRoutes,
        chanakyaNeetiRoutes,
        mahabharatRoutes,
        mantraRoutes,
        ramcharitmanasRoutes,
        rigVedaRoutes,
        valmikiRamayanRoutes,
        bhagvadGeetaRoutes,
        yogaSutraRoutes,
        guruGranthSahibRoutes,
        vratKathaRoutes
      ]);
  StreamSubscription<GlobalEvent>? globalEventSubscription;
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  Offset position = const Offset(100, 100);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);//lifecycycle events
    globalEventSubscription=(globalEventDispatcher.stream as Stream<GlobalEvent>).listen((event){
      final onWhiteListedUrl=router.routerDelegate.currentConfiguration.matches.any((loc) => loc.matchedLocation.startsWith("/auth") || loc.matchedLocation=='/splash');
      if((event is LogOutInitEvent) && !onWhiteListedUrl){
        NotificationService.showSnackbar(text: "Session expired, Please log-in again");
      }else if((event is LogOutCompleteEvent)){
        router.goNamed(BBR.Routing.home.name);
      }
    });

    connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet) ||
          connectivityResult.contains(ConnectivityResult.vpn)) {
        NotificationService.showSnackbar(color: Colors.green,text: "Connected to mobile internet 😀");
      }else if (connectivityResult.contains(ConnectivityResult.none)) {
        NotificationService.showSnackbar(duration: const Duration(seconds: 5),text: "No Internet Connection 😥");
      }
    });
    super.initState();
  }

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
        BlocProvider<GuruGranthSahibBloc>(create: (ctx) => GuruGranthSahibBloc(guruGranthSahibRepository: GuruGranthSahibRepository())),
        BlocProvider<VratKathaBloc>(create: (ctx) => VratKathaBloc(vratKathaRepository: VratKathaRepository())),
        BlocProvider<BookmarkBloc>(create: (ctx) => BookmarkBloc()),
        BlocProvider<LikeBloc>(create: (ctx) => LikeBloc()),
        BlocProvider<AuthBloc>(lazy: false, create: (ctx) => AuthBloc(authRepository: AuthRepository()))
      ],
      child:Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            MaterialApp.router(
              key: parentNavKey,
              scaffoldMessengerKey: NotificationService.messengerKey,
              title: 'Spirtual Shakti',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              routerConfig: router,
            ),
            // Positioned(
            //   left: position.dx,
            //   top: position.dy,
            //   child: GestureDetector(
            //     onPanUpdate: (details) {
            //       setState(()=>position = Offset(position.dx + details.delta.dx, position.dy + details.delta.dy));
            //     },
            //     onPanEnd: (details) {
            //       if (_isAtEdgeOfScreen(context)) {
            //         setState(() {
            //         });
            //       }
            //     },
            //     child: Padding(padding: EdgeInsets.all(4.0),child: FloatingActionButton(
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
            //       elevation: 2,
            //       onPressed: () {
            //       },
            //       child: Icon(Icons.music_note),
            //     ),),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  bool _isAtEdgeOfScreen(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Define the "edge" threshold (e.g., 50 pixels from the screen edge)
    const edgeThreshold = 50.0;

    return position.dx <= edgeThreshold || // Left edge
        position.dy <= edgeThreshold || // Top edge
        position.dx >= screenSize.width - edgeThreshold || // Right edge
        position.dy >= screenSize.height - edgeThreshold; // Bottom edge
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    globalEventSubscription?.cancel();
    AudioPlayerSingleton().player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioPlayerSingleton().player.pause();
    }
  }
}

class GoRouterObserver extends NavigatorObserver {

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
  }
}