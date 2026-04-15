import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedListTile extends StatelessWidget {
  final int itemNo;
  final String text;
  final String? imageUrl;
  final VoidCallback? onTap;

  const RoundedListTile({super.key, required this.itemNo,this.imageUrl, required this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text('$itemNo', style: const TextStyle(color: Colors.white)),
      ),
      trailing: imageUrl != null
          ? ClipOval(child: CircleAvatar(radius: 24, child: CachedNetworkImage(
              imageUrl: imageUrl!, fit: BoxFit.fitHeight,
              placeholder: (_, __) => const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported_outlined),
            )))
          : null,
      key: key,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64), side: BorderSide(color: Theme.of(context).primaryColor)),
      title: Text(text,softWrap: false,maxLines: 1,overflow: TextOverflow.ellipsis,),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      onTap: onTap,
    );
  }
}
