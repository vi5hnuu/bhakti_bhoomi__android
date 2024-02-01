import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    BlocProvider.of<AuthBloc>(context).add(FetchUserInfoEvent(cancelToken: cancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Spirtual Shakti'),
            centerTitle: true,
            bottomOpacity: 1,
            elevation: 10,
            actions: [
              if (state.userInfo != null)
                InkWell(
                  onTap: () => GoRouter.of(context).pushNamed(Routing.profile),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(state.userInfo!.profileMeta!.secure_url),
                  ),
                )
            ],
          ),
          drawer: Drawer(
              child: SafeArea(
            child: state.userInfo != null
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(state.userInfo!.posterMeta!.secure_url))),
                        child: Text(state.userInfo!.firstName),
                      )
                    ],
                  )
                : state.error != null
                    ? Text(state.error!)
                    : const RefreshProgressIndicator(),
          )),
          body: Center(
            child: GridView.count(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
              ItemCard(
                title: "aarti",
                onPressed: () => GoRouter.of(context).pushNamed(Routing.aartiInfo),
              ),
              ItemCard(onPressed: () => {context.pushNamed(Routing.brahmasutraChaptersInfo)}, title: "brahmasutra"),
              ItemCard(onPressed: () => {BlocProvider.of<AuthBloc>(context).add(LogoutEvent())}, title: "logout"),
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
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)),
        onTap: onPressed,
        child: Text(title),
      ),
    );
  }
}
