import 'package:bhakti_bhoomi/constants/about-us-info.dart';
import 'package:bhakti_bhoomi/state/aarti/aarti_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  final String title;

  const AboutUsScreen({super.key, required this.title});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final CancelToken cancelToken = CancelToken();
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: "Kalam",
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<AartiBloc, AartiState>(builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...aboutUsInfo.contributors.map((contributor)=>Stack(
                children: [
                  Positioned(
                      right: 10,
                      top: 10
                      ,child: Column(
                    children: [
                      if(contributor.socialLinks.linkedin!=null) IconButton(
                        onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.linkedin!)),
                        icon:Icon(FontAwesomeIcons.linkedin,color: Theme.of(context).primaryColor,size: 32,),
                      ),
                      if(contributor.socialLinks.instagram!=null)IconButton(
                        onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.instagram!)),
                        icon: Icon(FontAwesomeIcons.instagram,color: Theme.of(context).primaryColor,size: 32,),
                      ),
                    ],
                  )),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(fit: BoxFit.contain,contributor.photoUrl,loadingBuilder: (context, child, loadingProgress) => loadingProgress!=null ? Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SpinKitCircle(size: 48,color: Colors.deepOrange),
                              Text(((loadingProgress.cumulativeBytesLoaded/(loadingProgress.expectedTotalBytes ?? 1)).floor()*100).toString())
                            ],):child),
                        ),
                      ),
                    ),
                    Text(
                      contributor.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: "Kalam",fontSize: 18,height: 3,fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      contributor.role,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16,height: 2, color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.normal),
                    ),
                    const SizedBox(height: 10),
                    ...contributor.description.map((desc)=>Text(
                      desc,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16,height: 2, color: Colors.black,fontWeight: FontWeight.w400),
                    )),
                    const Divider(color: Colors.grey,thickness: 0.5,indent: 100,endIndent: 100,height: 72,)
                  ],
                )],
              )),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }

  Future<void> _launchUrl(Uri url) async {//launch in app and fallback to browser else error
    try {
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView) || !await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
      }
    } catch (e) {
      print(e);
    }
  }
}