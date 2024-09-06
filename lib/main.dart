import 'dart:async';
import 'package:bhakti_bhoomi/pages/about-us/AboutUsScreen.dart';
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
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final _whiteListedRoutes = [BBR.Routing.login.path, BBR.Routing.register.path, BBR.Routing.forgotPassword.path, BBR.Routing.splash.path, BBR.Routing.otp.path];
  final router=GoRouter(
      debugLogDiagnostics: true,
      // errorBuilder: (context, state) => const Home(title: 'Spirtual Shakti Error'),
      redirect: (context, state) {
        final authState=BlocProvider.of<AuthBloc>(context).state;
        if (!_whiteListedRoutes.contains(state.fullPath) && !authState.isAuthtenticated) {
          return "/auth/${BBR.Routing.login.path}";
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
  StreamSubscription<GlobalEvent>? subscription;

  @override
  void initState() {
    subscription=(globalEventDispatcher.stream as Stream<GlobalEvent>).listen((event){
      if(event is LogOutInitEvent){
        scaffoldMessengerKey.currentState?.showSnackBar(notificationSnackbar(text: "Session expired, Please log-in again"));
      }else if(event is LogOutCompleteEvent){
        router.goNamed(BBR.Routing.login.name);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parentNavKey=GlobalKey<NavigatorState>();

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
        scaffoldMessengerKey: scaffoldMessengerKey,
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
    subscription?.cancel();
    super.dispose();
  }
}

class GoRouterObserver extends NavigatorObserver {

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
  }
}