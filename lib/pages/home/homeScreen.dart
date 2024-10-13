import 'package:audioplayers/audioplayers.dart';
import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
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
  bool isHinduAudioOnly=false;
  final player = AudioPlayer(playerId: 'mantra');

  @override
  void initState() {
    //isHinduOnlyAudioSwitch from secure storage
    SecureStorage().storage.read(key: Constants.STORAGE_HINDU_AUDIO).then((value) => {
      if(value!=null) setState(()=>isHinduAudioOnly=bool.parse(value))
    });
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
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5, left: 5, right: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
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
                  if(state.isAdmin) ListTile(
                    title: const Text("Create Post",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                    splashColor: Theme.of(context).primaryColor,
                    leading: Icon(Icons.post_add, color: Theme.of(context).primaryColor,size: 24),
                    trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor,size: 16),
                    onTap: () => GoRouter.of(context).pushNamed(Routing.createPost.name),
                  ),
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
                Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  children: [
                    Padding(padding: const EdgeInsets.all(15),child: Image.asset("assets/header/hindu.webp",height: 50,fit: BoxFit.fitHeight)),
                    Align(alignment: Alignment.centerRight, child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Switch(value: isHinduAudioOnly, onChanged: (value) =>setState((){
                        isHinduAudioOnly=value;
                        SecureStorage().storage.write(key: Constants.STORAGE_HINDU_AUDIO, value: isHinduAudioOnly.toString());
                      })),
                    ))
                  ],
                ),
                if(!isHinduAudioOnly) GridView.count(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
                  ItemCard(imageProvider: const AssetImage("assets/home/aarti.webp"),title: "aarti", onPressed: () => GoRouter.of(context).pushNamed(Routing.aartiInfo.name),),
                  ItemCard(imageProvider:const AssetImage("assets/home/brahmasutra.webp"),onPressed: () => {context.pushNamed(Routing.brahmasutraChaptersInfo.name)}, title: "brahmasutra"),
                  ItemCard(imageProvider:const AssetImage("assets/home/chalisa.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.chalisaInfo.name)}, title: "chalisa"),
                  ItemCard(imageProvider:const AssetImage("assets/home/chanakyaneeti.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapters.name)}, title: "chanakyaneeti"),
                  ItemCard(imageProvider:const AssetImage("assets/home/mahabharat.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.mahabharatBookInfos.name)}, title: "mahabharat"),
                  ItemCard(imageProvider:const AssetImage("assets/home/mantra.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.mantraInfo.name)}, title: "mantra"),
                  ItemCard(imageProvider:const AssetImage("assets/home/ramcharitmanas.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.ramcharitmanasInfo.name)}, title: "ramcharitmanas"),
                  ItemCard(imageProvider:const AssetImage("assets/home/rigved.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.rigvedaMandalasInfo.name)}, title: "rigveda"),
                  ItemCard(imageProvider:const AssetImage("assets/home/valmikiramayan.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.valmikiRamayanKandsInfo.name)}, title: "valmiikiramayan"),
                  ItemCard(imageProvider:const AssetImage("assets/home/bhagvadgeeta.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.bhagvadGeetaChapters.name)}, title: "bhagvadgeeta"),
                  ItemCard(imageProvider:const AssetImage("assets/home/yogasutra.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.yogaSutraChapters.name)}, title: "yoga-sutra"),
                  ItemCard(imageProvider:const AssetImage("assets/home/vratkatha.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.vratKathaInfo.name)}, title: "Vrat Katha's"),
                ]),
                if(isHinduAudioOnly) GridView.count(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
                  ItemCard(imageProvider:const AssetImage("assets/home/audio/mantra.webp"),onPressed: () => {GoRouter.of(context).pushNamed(Routing.mantraAudioInfo.name)}, title: "Mantra 🎵"),
                ]),
                Padding(padding: const EdgeInsets.all(15),child: Image.asset("assets/header/sikh.webp",height: 50,fit: BoxFit.fitHeight)),
                GridView.count(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(15), childAspectRatio: 1, scrollDirection: Axis.vertical, children: <Widget>[
                  ItemCard(imageProvider:const AssetImage("assets/home/gurugranthsahib.webp"),title: "Guru Granth Sahib", onPressed: () => GoRouter.of(context).pushNamed(Routing.guruGranthSahibInfo.name),),
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
    player.dispose();
  }
}

class ItemCard extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;
  final ImageProvider? imageProvider;

  const ItemCard({
    super.key,
    required this.title,
    this.imageProvider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        image: imageProvider==null ? null :  DecorationImage(
            image: imageProvider!,
            onError: (exception, stackTrace) => const Icon(Icons.image_not_supported_outlined),
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            filterQuality: FilterQuality.high
        ),
      ),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        overlayColor: WidgetStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.5),
        child: imageProvider!=null ? null : Center(child: Text(title, style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
      ),
    );
  }
}
