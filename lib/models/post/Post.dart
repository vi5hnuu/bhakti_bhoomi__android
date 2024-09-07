
import 'package:bhakti_bhoomi/constants/IdGenerators.dart';

class Post{
  final String id;
  final String? authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Type> content;
  final List<Tag> tags;
  Post({required this.tags,String? id,this.authorId,this.createdAt,this.updatedAt,required this.content}):id=id ?? IdGenerators.generateId();

  Post clone(){
    return Post(tags: this.tags, content: this.content,authorId: this.authorId,createdAt: this.createdAt,id: this.id,updatedAt: this.updatedAt);
  }
}

class Tag{
  String id;
  String name;
  Tag({String? id,required this.name}):id=id?? IdGenerators.generateId();
}

enum ItemType{
    text,
    image,
    video,
    link,
    audio,
    poll,
    file,
    location,
    event,
    radioGroup,
    checkboxGroup,
    dropDown;

  static ItemType stringToEnum(String name) {
    return ItemType.values.firstWhere((e) => e.name == name);
  }
}

class Type{
  final String id;
  final ItemType type;
  final String postId;
  Type({String? id,String? postId,required this.type}):id=id ?? IdGenerators.generateId(),postId=postId ?? IdGenerators.generateId();
}

class Text extends Type{
  final String value;
  final TextFormatting? formatting;

  Text({required this.value,this.formatting}):super(type: ItemType.text);
}

class TextFormatting{
  final bool bold;
  final bool italic;
  final bool underline;
  final String color;
  TextFormatting({this.bold=false,this.italic=false,this.underline=false,this.color='#000'});
}

class Image extends Type{
  final String url;
  final String? caption;
  final String altText;
  final Dimensions? dimensions;
  Image({required this.url,this.caption,required this.altText,this.dimensions}):super(type: ItemType.image);
}

class Dimensions{
  final int? width;
  final int? height;
  Dimensions({this.height,this.width});
}

class Video extends Type{
  final String url;
  final String? thumbnailUrl;
  final String? caption;
  final String duration;
  Video({required this.url,this.thumbnailUrl,this.caption,required this.duration}):super(type: ItemType.video);
}

class Audio extends Type{
  final String url;
  final String? thumbnailUrl;
  final String? caption;
  final String duration;
  Audio({required this.url,this.thumbnailUrl,this.caption,required this.duration}):super(type: ItemType.audio);
}

class Link extends Type{
  final String url;
  final String title;
  final String? description;
  final String? imageUrl;
  Link({required this.url,required this.title,this.description,this.imageUrl}):super(type: ItemType.link);
}

class Poll extends Type{
  final String question;
  final List<PollOption> options;
  final Map<String,int> votes;
  final DateTime expireAt;
  final bool AllowMultipleVotes;

  Poll({required this.question,required this.options,required this.votes,required this.expireAt,required this.AllowMultipleVotes}):super(type: ItemType.poll);
}

class PollOption{
  final String id;
  final String value;
  PollOption({required this.id,required this.value});
}

class File extends Type{
  final String url;
  final String fileName;
  final String fileSize;
  File({required this.url,required this.fileName,required this.fileSize}):super(type: ItemType.file);
}

class Location extends Type{
  double latitude;
  double longitude;
  final String? placeName;
  final String? address;
  Location({required this.latitude,required this.longitude,this.placeName,this.address}):super(type: ItemType.location);
}

class Event extends Type{
  final String eventName;
  final String eventDate;
  final Location location;
  final String description;

  Event({required this.eventName,required this.eventDate,required this.location,required this.description}):super(type: ItemType.event);
}
