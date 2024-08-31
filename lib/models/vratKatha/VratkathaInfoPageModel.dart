
import 'package:bhakti_bhoomi/models/Pageable.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaInfoModel.dart';

class VratkathaInfoPageModel extends Pageable<VratkathaInfoModel> {
    VratkathaInfoPageModel({required super.data, required super.pageNo, required super.totalPages});

    factory VratkathaInfoPageModel.fromJson(Map<String, dynamic> json) {
        List<VratkathaInfoModel> data = [];
        json['data'].forEach((v) {
            data.add(VratkathaInfoModel.fromJson(v));
        });

        return VratkathaInfoPageModel(
            data: data,
            pageNo: json['pageNo'],
            totalPages: json['totalPages']
        );
    }
}