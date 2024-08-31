import 'dart:collection';

import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaInfoModel.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaModel.dart';
import 'package:bhakti_bhoomi/services/vratKatha/AartiRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/HttpState.dart';
part 'vratKatha_event.dart';
part 'vratKatha_state.dart';

class VratKathaBloc extends Bloc<VratKathaEvent, VratKathaState> {
  VratKathaBloc({required VratKathaRepository vratKathaRepository}) : super(VratKathaState.initial()) {

    on<FetchVratKathaInfoPage>((event,emit)async{
       if (state.hasKathaInfoPage(pageNo: event.pageNo)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.VRAT_KATHA_INFO_PAGE)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.VRAT_KATHA_INFO_PAGE,const HttpState.loading())));
      try {
        final kathaInfoPage = await vratKathaRepository.getVratKathaInfoPage(pageNo: event.pageNo,pageSize: VratKathaState.pageSize,cancelToken: event.cancelToken);
        emit(state.copyWith(kathaInfos: LinkedHashMap.fromEntries([...state.kathaInfos.entries,...kathaInfoPage.data!.data.map((info)=>MapEntry(info.id,info))]),totalPages: kathaInfoPage.data!.totalPages,httpStates:state.httpStates.clone()..remove(Httpstates.VRAT_KATHA_INFO_PAGE)));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.VRAT_KATHA_INFO_PAGE, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.VRAT_KATHA_INFO_PAGE, HttpState.error(error: ErrorModel(message: e.toString())))));
      }
    });

    on<FetchVratKathInfo>((event,emit)async{
      throw UnimplementedError();
    });

    on<FetchVratKathaById>((event,emit)async{
      if (state.getVratKatha(event.kathaId)!=null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.VRAT_KATHA)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.VRAT_KATHA,const HttpState.loading())));
      try {
        final katha = await vratKathaRepository.getVratKathaById(kathaId: event.kathaId,cancelToken: event.cancelToken);
        emit(state.copyWith(kathas: Map.fromEntries([...state.kathas.entries,state.getEntry(katha.data!)]),httpStates:state.httpStates.clone()..remove(Httpstates.VRAT_KATHA)));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.VRAT_KATHA, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.VRAT_KATHA, HttpState.error(error: ErrorModel(message: e.toString())))));
      }
    });

    on<FetchVratKathaByTitle>((event,emit)async{
      throw UnimplementedError();
    });
  }
}
