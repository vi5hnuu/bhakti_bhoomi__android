import 'dart:async';

import 'package:bhakti_bhoomi/pages/aarti/AartiInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/aarti/AartiScreen.dart';
import 'package:bhakti_bhoomi/pages/about-us/AboutUsScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/ForgotPasswordScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/LoginScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/OtpScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/RegisterScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/UpdatePasswordScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/VerifyScreen.dart';
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraChaptersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraQuatersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraScreen.dart';
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaScreen.dart';
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiChaptersScreen.dart';
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/guru-granth-sahib/GuruGranthSahibRagaPartsScreen.dart';
import 'package:bhakti_bhoomi/pages/guru-granth-sahib/GuruGranthSahibScreen.dart';
import 'package:bhakti_bhoomi/pages/home/homeScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatBooksInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatChaptersInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatShlokScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraInfoScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraScreen.dart';
import 'package:bhakti_bhoomi/pages/profileScreen.dart';
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
import 'package:bhakti_bhoomi/services/guruGranthSahib/GuruGranthSahibRepository.dart';
import 'package:bhakti_bhoomi/services/mahabharat/MahabharatRepository.dart';
import 'package:bhakti_bhoomi/services/mantra/MantraRepository.dart';
import 'package:bhakti_bhoomi/services/ramayan/RamayanRepository.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaRepository.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
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
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final whiteListedRoutes = [Routing.login.path, Routing.register.path, Routing.forgotPassword.path, Routing.splash.path, Routing.otp.path];

  MyApp({super.key});

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
        BlocProvider<GuruGranthSahibBloc>(lazy: false, create: (ctx) => GuruGranthSahibBloc(guruGranthSahibRepository: GuruGranthSahibRepository())),
        BlocProvider<AuthBloc>(lazy: false, create: (ctx) => AuthBloc(authRepository: AuthRepository()))
      ],
      child: MaterialApp.router(
        title: 'Spirtual Shakti',
        key: parentNavKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.highContrastLight(primary: Color.fromRGBO(165, 62, 72, 1)),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
            debugLogDiagnostics: true,
            // errorBuilder: (context, state) => const Home(title: 'Spirtual Shakti Error'),
            redirect: (context, state) {
              if (whiteListedRoutes.contains(state.path) && !BlocProvider.of<AuthBloc>(context).state.isAuthtenticated) {
                return Routing.login.path;
              }
              return null;
            },
            initialLocation: Routing.splash.path,
            routes: [
              GoRoute(
                name: Routing.splash.name,
                path: Routing.splash.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const SplashScreen(title: "Splash"),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.aboutUs.name,
                path: Routing.aboutUs.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const AboutUsScreen(title: "About Us"),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.login.name,
                path: Routing.login.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: LoginScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.verify.name,
                path: Routing.verify.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: VerifyScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.forgotPassword.name,
                path: Routing.forgotPassword.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ForgotPasswordScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.otp.name,
                path: Routing.otp.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: OtpScreen(usernameEmail: state.pathParameters['usernameEmail']!),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.updatePassword.name,
                path: Routing.updatePassword.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const UpdatePasswordScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.register.name,
                path: Routing.register.path,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const RegisterScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.profile.name,
                path: Routing.profile.path,
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                name: Routing.home.name,
                path: Routing.home.path,
                builder: (context, state) => const Home(title: 'Spirtual Shakti'),
              ),
              GoRoute(
                name: Routing.aartiInfo.name,
                path: Routing.aartiInfo.path,
                builder: (context, state) => AartiInfoScreen(title: "Aarti's"),
              ),
              GoRoute(
                name: Routing.aarti.name,
                path: Routing.aarti.path,
                builder: (context, state) => AartiScreen(title: 'Aartis', aartiId: state.pathParameters['id']!),
              ),
              GoRoute(
                name: Routing.brahmasutraChaptersInfo.name,
                path: Routing.brahmasutraChaptersInfo.path,
                builder: (context, state) => const BrahmasutraChaptersInfoScreen(title: 'Brahmasutra'),
              ),
              GoRoute(
                name: Routing.brahmasutraQuatersInfo.name,
                path: Routing.brahmasutraQuatersInfo.path,
                builder: (context, state) => BrahmasutraQuatersInfoScreen(title: 'Brahmasutra', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.brahmasutra.name,
                path: Routing.brahmasutra.path,
                builder: (context, state) => BrahmasutraScreen(title: 'Brahmasutra', chapterNo: int.parse(state.pathParameters['chapterNo']!), quaterNo: int.parse(state.pathParameters['quaterNo']!)),
              ),
              GoRoute(
                name: Routing.chalisaInfo.name,
                path: Routing.chalisaInfo.path,
                builder: (context, state) => const ChalisaInfoScreen(title: 'Chalisa'),
              ),
              GoRoute(
                name: Routing.chalisa.name,
                path: Routing.chalisa.path,
                builder: (context, state) => ChalisaScreen(title: 'Chalisa', chalisaId: state.pathParameters['chalisaId']!),
              ),
              GoRoute(
                name: Routing.chanakyaNitiChapters.name,
                path: Routing.chanakyaNitiChapters.path,
                builder: (context, state) => const ChanakyaNeetiChaptersScreen(title: 'ChanaKya Niti'),
              ),
              GoRoute(
                name: Routing.chanakyaNitiChapterShlok.name,
                path: Routing.chanakyaNitiChapterShlok.path,
                builder: (context, state) => ChanakyaNeetiShlokScreen(title: 'ChanaKya Niti', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.mahabharatBookInfos.name,
                path: Routing.mahabharatBookInfos.path,
                builder: (context, state) => MahabharatBookInfoScreen(title: 'MahaBharat'),
              ),
              GoRoute(
                  name: Routing.mahabharatBookChaptersInfos.name,
                  path: Routing.mahabharatBookChaptersInfos.path,
                  builder: (context, state) => MahabharatChaptersInfoScreen(title: 'Mahabharat', bookNo: int.parse(state.pathParameters['bookNo']!))),
              GoRoute(
                  name: Routing.mahabharatBookChapterShloks.name,
                  path: Routing.mahabharatBookChapterShloks.path,
                  builder: (context, state) => MahabharatShlokScreen(
                        title: 'Mahabharat',
                        bookNo: int.parse(state.pathParameters['bookNo']!),
                        chapterNo: int.parse(state.pathParameters['chapterNo']!),
                      )),
              GoRoute(
                name: Routing.mantraInfo.name,
                path: Routing.mantraInfo.path,
                builder: (context, state) => const MantraInfoScreen(title: 'Mantra'),
              ),
              GoRoute(
                name: Routing.mantra.name,
                path: Routing.mantra.path,
                builder: (context, state) => MantraScreen(title: 'Mantra', mantraId: state.pathParameters['mantraId']!),
              ),
              GoRoute(
                name: Routing.ramcharitmanasInfo.name,
                path: Routing.ramcharitmanasInfo.path,
                builder: (context, state) => const RamcharitmanasInfoScreen(title: 'RamCharitManas'),
              ),
              GoRoute(
                name: Routing.ramcharitmanasKandVerses.name,
                path: Routing.ramcharitmanasKandVerses.path,
                builder: (context, state) => RamcharitmanasVersesScreen(title: 'RamCharitManas', kand: state.pathParameters['kand']!),
              ),
              GoRoute(
                name: Routing.ramcharitmanasMangalaCharan.name,
                path: Routing.ramcharitmanasMangalaCharan.path,
                builder: (context, state) => RamcharitmanasMangalacharanScreen(title: 'RamCharitManas', kand: state.pathParameters['kand']!),
              ),
              GoRoute(
                name: Routing.rigvedaMandalasInfo.name,
                path: Routing.rigvedaMandalasInfo.path,
                builder: (context, state) => const RigvedaMandalasInfoScreen(title: ''
                    'RigVeda'),
              ),
              GoRoute(
                name: Routing.rigvedaMandalaSuktas.name,
                path: Routing.rigvedaMandalaSuktas.path,
                builder: (context, state) => RigvedaSuktaScreen(title: 'RigVeda', mandala: int.parse(state.pathParameters['mandala']!)),
              ),
              GoRoute(
                name: Routing.valmikiRamayanKandsInfo.name,
                path: Routing.valmikiRamayanKandsInfo.path,
                builder: (context, state) => const ValmikiRamayanKandsScreen(title: 'Valmiki Ramayan kanda'),
              ),
              GoRoute(
                name: Routing.valmikiRamayanSargasInfo.name,
                path: Routing.valmikiRamayanSargasInfo.path,
                builder: (context, state) => ValmikiRamayanSargasScreen(title: 'Valmiki Ramayan', kand: state.pathParameters['kand']!),
              ),
              GoRoute(
                name: Routing.valmikiRamayanShlok.name,
                path: Routing.valmikiRamayanShlok.path,
                builder: (context, state) => ValmikiRamayanShlokScreen(title: 'Valmiki Ramayan', kand: state.pathParameters['kand']!, sargaNo: int.parse(state.pathParameters['sargaNo']!)),
              ),
              GoRoute(
                name: Routing.bhagvadGeetaChapters.name,
                path: Routing.bhagvadGeetaChapters.path,
                builder: (context, state) => const BhagvadGeetaChaptersScreen(title: 'Bhagvad Geeta'),
              ),
              GoRoute(
                name: Routing.bhagvadGeetaChapterShloks.name,
                path: Routing.bhagvadGeetaChapterShloks.path,
                builder: (context, state) => BhagvadGeetaShlokScreen(title: 'Bhagvad Geeta shlok', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.yogaSutraChapters.name,
                path: Routing.yogaSutraChapters.path,
                builder: (context, state) => const YogaSutraChapters(title: 'Yoga Sutra'),
              ),
              GoRoute(
                name: Routing.yogaSutra.name,
                path: Routing.yogaSutra.path,
                builder: (context, state) => YogaSutraScreen(title: 'Yoga Sutra', chapterNo: int.parse(state.pathParameters['chapterNo']!)),
              ),
              GoRoute(
                name: Routing.guruGranthSahibInfo.name,
                path: Routing.guruGranthSahibInfo.path,
                builder: (context, state) => const GuruGranthSahibInfoScreen(title: 'Guru Granth Sahib'),
              ),
              GoRoute(
                name: Routing.guruGranthSahibRagaParts.name,
                path: Routing.guruGranthSahibRagaParts.path,
                builder: (context, state) => GuruGranthSahibRagaPartsScreen(ragaNo: int.parse(state.pathParameters['ragaNo']!),title: 'Guru Granth Sahib'),
              ),
            ]),
      ),
    );
  }
}
