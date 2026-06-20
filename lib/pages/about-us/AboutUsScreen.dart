import 'package:bhakti_bhoomi/constants/about-us-info.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/om_medallion.dart';
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
    return AppScaffold(
      title: 'About Us',
      subtitle: 'भक्ति भूमि',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: OmMedallion(size: 76)),
            const SizedBox(height: 12),
            Text('Bhakti Bhoomi', textAlign: TextAlign.center, style: AppTypography.textTheme.displaySmall),
            const SizedBox(height: 4),
            Text('Sacred texts, daily rituals & quiet practice.',
                textAlign: TextAlign.center, style: AppTypography.textTheme.bodyMedium),
            const SizedBox(height: 24),
            ...aboutUsInfo.contributors.map((contributor) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: AppCard(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 110,
                          width: 110,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: contributor.photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const SpinKitCircle(size: 40, color: AppColors.gold),
                              errorWidget: (_, __, ___) => Container(color: AppColors.surfaceAlt, child: const Icon(Icons.person, color: AppColors.textFaint)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(contributor.name, textAlign: TextAlign.center, style: AppTypography.textTheme.headlineSmall),
                        Text(contributor.role, textAlign: TextAlign.center, style: AppTypography.textTheme.labelMedium),
                        const SizedBox(height: 10),
                        ...contributor.description.map((desc) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(desc, textAlign: TextAlign.center, style: AppTypography.textTheme.bodyMedium),
                            )),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (contributor.socialLinks.linkedin != null)
                              IconButton(onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.linkedin!)), icon: const FaIcon(FontAwesomeIcons.linkedin, color: AppColors.terracotta, size: 24)),
                            if (contributor.socialLinks.instagram != null)
                              IconButton(onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.instagram!)), icon: const FaIcon(FontAwesomeIcons.instagram, color: AppColors.terracotta, size: 24)),
                            if (contributor.socialLinks.github != null)
                              IconButton(onPressed: () => _launchUrl(Uri.parse(contributor.socialLinks.github!)), icon: const FaIcon(FontAwesomeIcons.github, color: AppColors.terracotta, size: 24)),
                          ],
                        ),
                      ],
                    ),
                  ),
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
