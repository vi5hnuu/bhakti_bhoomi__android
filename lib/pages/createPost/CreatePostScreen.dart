import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bhakti_bhoomi/models/post/Post.dart' as post_models;
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostMeta{
  String? selectedId;
  PostMeta({this.selectedId});

  PostMeta clone(){
    return PostMeta(selectedId: selectedId);
  }
}

class CreatePostScreen extends StatefulWidget {
  final String title;

  const CreatePostScreen({super.key, required this.title});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final CancelToken cancelToken = CancelToken();
  post_models.Post post=post_models.Post(tags: const [],content: [
    post_models.Text(value: "vishnu kumar"),
  ]);
  PostMeta postMeta=PostMeta();
  
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ReorderableListView.builder(itemBuilder: (context, index) {
            return _getItem(index:index);
          },buildDefaultDragHandles: true,scrollDirection: Axis.vertical,shrinkWrap: false,
              header:DefaultTextStyle(
                style: TextStyle(
                    fontSize: 27,
                    height: 2.5,
                    fontFamily: 'Kalam',
                    color: Theme.of(context).primaryColor
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(textAlign: TextAlign.center,speed: const Duration(milliseconds: 200),
                        '😎😎 Frame Post 😎😎'),
                  ],
                  repeatForever: false,
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                ),
              ) ,
              itemCount: post.content.length, onReorder: _onReorder)),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: CustomElevatedButton(onPressed: () {},backgroundColor: Colors.red, child: const Text("Cancel",style: TextStyle(color: Colors.white))), flex: 3),
              const SizedBox(width: 7),
              Expanded(child: CustomElevatedButton(onPressed: () {},backgroundColor: Colors.green, child: const Text("Create",style: TextStyle(color: Colors.white))),flex: 7,)
            ],
          )
        ],
      ),
    );
  }

   _getItem({required int index}){
    final selectedContent=post.content[index];
    return Column(
      key: Key(post.content[index].id),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TypedItem(contentType: selectedContent.type,
          initiallySelected: postMeta.selectedId == selectedContent.id,
          content: selectedContent,
          onAdd:(value) => _switchType(index: index,to: post_models.ItemType.stringToEnum(value)),
          onEdit: () {
            postMeta.selectedId = selectedContent.id;
            setState(() => postMeta = postMeta.clone());
          },
            onDone: () {
              postMeta.selectedId = null;
              setState(() => postMeta = postMeta.clone());
            },
            onReset: () {
              postMeta.selectedId = null;
              setState(() => postMeta = postMeta.clone());
            },
          onSwitch: (value) => _switchType(index: index, to: post_models.ItemType.stringToEnum(value))),

      ],
    );
  }


  _onReorder(oldIndex, newIndex){
    if (newIndex > oldIndex) newIndex -= 1;
    final item=post.content.elementAt(oldIndex);
    post.content[oldIndex]=post.content.elementAt(newIndex);
    post.content[newIndex]=item;
    setState(()=>post=post.clone());
  }

  _switchType({required int index,required post_models.ItemType to}){
    switch(to){
      case post_models.ItemType.text:
        post.content[index]=post_models.Text(value: "value");break;
      default:
        post.content[index]=post_models.File(url: "",fileName: "",fileSize: "");break;
    }
    setState(() =>post=post.clone());
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

class TypedItem extends StatelessWidget{
  final post_models.ItemType contentType;
  final post_models.Type content;
  final bool isSelected;
  Function()? onEdit;
  Function()? onDone;
  Function()? onReset;
  Function(String)? onSwitch;
  Function(String)? onAdd;

  TypedItem({super.key,this.onAdd,this.onDone,this.onReset, required this.content,required this.contentType,this.onEdit,this.onSwitch,bool? initiallySelected}):isSelected=initiallySelected ?? false{
    if(contentType!=content.type) throw Exception("contentType and content type does not match");
  }

  @override
  Widget build(BuildContext context) {
    switch(contentType){
      case post_models.ItemType.text :
        return Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                minVerticalPadding: 0,
                trailing: isSelected ? PopupMenuButton<String>(initialValue: contentType.name,
                    onSelected: onSwitch,
                    itemBuilder: (context) =>
                        post_models.ItemType.values.map((type) =>
                            PopupMenuItem<String>(value: type.name,
                                child: Text("${type.name[0].toUpperCase()}${type.name.substring(1)}"))).toList(growable: false),
                    child: const Icon(Icons.compare_arrows)):null,
                leading: const Icon(Icons.drag_indicator),
                title: GestureDetector(
                  onTap: onEdit,
                  child: TextFormField(decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                  ),autofocus: isSelected,enabled: isSelected),
                ),
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.all(0),
              ),
              if(isSelected) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: PopupMenuButton<String>(initialValue: contentType.name,
                        onSelected: onAdd,
                        itemBuilder: (context) => post_models.ItemType.values.map((type)=>PopupMenuItem<String>(value: type.name, child: Text("${type.name[0].toUpperCase()}${type.name.substring(1)}"))).toList(growable: false),
                        icon: const Icon(Icons.add)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(highlightColor: Colors.lightGreenAccent.withOpacity(0.5),color: Colors.green,onPressed: onDone, icon: Icon(Icons.check)),
                        IconButton(onPressed: onReset, icon: const Icon(Icons.refresh),highlightColor: Colors.redAccent.withOpacity(0.3),color: Colors.red)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      default:return Text("hello");
    }
  }

}