import 'dart:async';
import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/pages/about-us/AboutUsScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/LoginScreen.dart';
import 'package:bhakti_bhoomi/pages/createPost/CreatePostScreen.dart';
import 'package:bhakti_bhoomi/pages/home/homeScreen.dart';
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
import 'package:bhakti_bhoomi/state/vratkatha/vratKatha_bloc.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

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

class _MyAppState extends State<MyApp> {
  static final _whiteListedRoutes = [BBR.Routing.login.fullPath,BBR.Routing.verify.fullPath, BBR.Routing.register.fullPath, BBR.Routing.forgotPassword.fullPath, BBR.Routing.splash.fullPath, BBR.Routing.otp.fullPath];
  final router=GoRouter(
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authState=BlocProvider.of<AuthBloc>(context).state;
        if (!_whiteListedRoutes.contains(state.fullPath) && !authState.isAuthtenticated) {
          return "/auth/${BBR.Routing.login.path}";
        }else if(state.fullPath?.startsWith("/admin")==true && !authState.isAdmin){
          return "/home";
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
          name: BBR.Routing.home.name,
          path: BBR.Routing.home.path,
          builder: (context, state) => const Home(title: 'Spirtual Shakti'),

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

  @override
  void initState() {
    globalEventSubscription=(globalEventDispatcher.stream as Stream<GlobalEvent>).listen((event){
      final onWhiteListedUrl=router.routerDelegate.currentConfiguration.matches.any((loc) => loc.matchedLocation.startsWith("/auth") || loc.matchedLocation=='/splash');
      if((event is LogOutInitEvent) && !onWhiteListedUrl){
        NotificationService.showSnackbar(text: "Session expired, Please log-in again");
      }else if((event is LogOutCompleteEvent)){
        router.goNamed(BBR.Routing.login.name);
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
        BlocProvider<AuthBloc>(lazy: false, create: (ctx) => AuthBloc(authRepository: AuthRepository()))
      ],
      child:MaterialApp.router(
        scaffoldMessengerKey: NotificationService.messengerKey,
        title: 'Spirtual Shakti',
        key: parentNavKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.highContrastLight(primary: Color.fromRGBO(165, 62, 72, 1)),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    globalEventSubscription?.cancel();
    super.dispose();
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