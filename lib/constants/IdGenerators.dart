import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:dio/dio.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class IdGenerators {
  static const _uuid=Uuid();

  static  generateId(){
    return  _uuid.v1();
  }
}
