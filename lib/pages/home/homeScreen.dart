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
                  onTap: () => GoRouter.of(context).pushNamed(Routing.profile.name),
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
                  ListTile(
                    title: const Text("About Us",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                    splashColor: Theme.of(context).primaryColor,
                    leading: Icon(Icons.info_outline, color: Theme.of(context).primaryColor,size: 24),
                    trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor,size: 16),
                    onTap: () => GoRouter.of(context).pushNamed(Routing.aboutUs.name),
                  )
                ],
              )),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: const EdgeInsets.all(15),child: Image.asset("assets/header/hindu.webp",width: double.infinity,height: 70,fit: BoxFit.cover)),
                GridView.count(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
                  ItemCard(title: "aarti", onPressed: () => GoRouter.of(context).pushNamed(Routing.aartiInfo.name),),
                  ItemCard(onPressed: () => {context.pushNamed(Routing.brahmasutraChaptersInfo.name)}, title: "brahmasutra"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.chalisaInfo.name)}, title: "chalisa"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapters.name)}, title: "chanakyaneeti"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.mahabharatBookInfos.name)}, title: "mahabharat"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.mantraInfo.name)}, title: "mantra"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.ramcharitmanasInfo.name)}, title: "ramcharitmanas"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.rigvedaMandalasInfo.name)}, title: "rigveda"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.valmikiRamayanKandsInfo.name)}, title: "valmiikiramayan"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.bhagvadGeetaChapters.name)}, title: "bhagvadgeeta"),
                  ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.yogaSutraChapters.name)}, title: "yoga-sutra"),
                ]),
                Padding(padding: const EdgeInsets.all(15),child: Image.asset("assets/header/sikh.webp",width: double.infinity,height: 70,fit: BoxFit.cover)),
                GridView.count(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
                  ItemCard(title: "Guru Granth Sahib", onPressed: () => GoRouter.of(context).pushNamed(Routing.guruGranthSahibInfo.name),),
                ]),
              ],
            )
          ),
        );
      },
    );
  }

  @override
  void dispose() {
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
