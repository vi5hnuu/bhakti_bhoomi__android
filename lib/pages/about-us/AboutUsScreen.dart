import 'package:bhakti_bhoomi/constants/about-us-info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
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
                        icon:FaIcon(FontAwesomeIcons.linkedin,color: Theme.of(context).primaryColor,size: 32,),
                      ),
                      if(contributor.socialLinks.instagram!=null)IconButton(
                        onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.instagram!)),
                        icon: FaIcon(FontAwesomeIcons.instagram,color: Theme.of(context).primaryColor,size: 32,),
                      ),
                      if(contributor.socialLinks.github!=null)IconButton(
                        onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.github!)),
                        icon: FaIcon(FontAwesomeIcons.github,color: Theme.of(context).primaryColor,size: 32,),
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
                          child: CachedNetworkImage(
                          imageUrl: contributor.photoUrl,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => const SpinKitCircle(size: 48, color: Colors.deepOrange),
                          errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
                        ),
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
        ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}