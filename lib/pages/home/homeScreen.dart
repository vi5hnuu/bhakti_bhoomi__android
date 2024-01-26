import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// https://spirtual-shakti-vi.onrender.com/
class Home extends StatelessWidget {
  final String title;
  const Home({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spirtual Shakti'),
        centerTitle: true,
        bottomOpacity: 1,
        elevation: 10,
      ),
      drawer: Drawer(child: Text("data")),
      body: Center(
        child: GridView.count(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
          ElevatedButton(onPressed: () => BlocProvider.of<AuthBloc>(context).add(LogoutEvent()), child: Text("logout")),
          ItemCard(
            title: "aarti",
            onPressed: () => GoRouter.of(context).pushNamed(Routing.aartiInfo),
          ),
          ItemCard(onPressed: () => {context.pushNamed(Routing.brahmasutra)}, title: "brahmasutra"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.chalisa)}, title: "chalisa"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapters)}, title: "chanakyaneeti"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.mahabharatBookInfos)}, title: "mahabharat"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.mantra)}, title: "mantra"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.ramcharitmanasInfo)}, title: "ramcharitmanas"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.rigveda)}, title: "rigveda"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.valmikiRamayan)}, title: "valmiikiramayan"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.bhagvadGeetaChapters)}, title: "bhagvadgeeta"),
          ItemCard(onPressed: () => {GoRouter.of(context).pushNamed(Routing.yogaSutra)}, title: "yoga-sutra"),
        ]),
      ),
    );
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
