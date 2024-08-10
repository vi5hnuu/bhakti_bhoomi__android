import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  final String title;
  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Spiritual Shakti',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 1,
            shadowColor: Colors.grey,
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              if (state.userInfo != null)
                GestureDetector(
                  onTap: () => GoRouter.of(context).pushNamed(Routing.profile),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(state.userInfo!.profileMeta!.secure_url),
                    ),
                  ),
                )
            ],
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          drawerScrimColor: Colors.white.withOpacity(0.7),
          drawerEdgeDragWidth: 64,
          drawer: Drawer(
              backgroundColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5, left: 5, right: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            foregroundImage: (state.userInfo?.profileMeta?.secure_url != null) ? NetworkImage(state.userInfo!.profileMeta!.secure_url) : null,
                            child: state.isLoading(forr: Httpstates.USER_INFO)
                                ? SpinKitPulse(
                                    color: Theme.of(context).primaryColor,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          if (state.userInfo != null)
                            Text(
                              '${state.userInfo!.firstName} ${state.userInfo!.lastName}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                        ],
                      )),
                ],
              )),
          body: GridView.count(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
            ItemCard(title: "aarti", onPressed: () => GoRouter.of(context).pushNamed(Routing.aartiInfo),),
            ItemCard(onPressed: () => {context.pushNamed(Routing.brahmasutraChaptersInfo)}, title: "brahmasutra"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.chalisaInfo)}, title: "chalisa"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapters)}, title: "chanakyaneeti"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.mahabharatBookInfos)}, title: "mahabharat"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.mantraInfo)}, title: "mantra"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.ramcharitmanasInfo)}, title: "ramcharitmanas"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.rigvedaMandalasInfo)}, title: "rigveda"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.valmikiRamayanKandsInfo)}, title: "valmiikiramayan"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.bhagvadGeetaChapters)}, title: "bhagvadgeeta"),
            ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.yogaSutraChapters)}, title: "yoga-sutra"),
          ]),
        );
      },
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

class ItemCard extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;

  const ItemCard({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.2)),
        onTap: onPressed,
        child: Center(child: Text(title, style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
      ),
    );
  }
}
