import 'package:flutter/material.dart';

class RoundedListTile extends StatelessWidget {
  final int itemNo;
  final String text;
  final VoidCallback? onTap;

  const RoundedListTile({super.key, required this.itemNo, required this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text('$itemNo', style: const TextStyle(color: Colors.white)),
      ),
      key: key,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64), side: BorderSide(color: Theme.of(context).primaryColor)),
      title: Text(text,softWrap: false,maxLines: 1,overflow: TextOverflow.ellipsis,),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      onTap: onTap,
    );
  }
}
