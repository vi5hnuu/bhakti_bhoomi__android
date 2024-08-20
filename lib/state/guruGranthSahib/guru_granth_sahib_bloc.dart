import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibInfoModel.dart';
import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibRagaModel.dart';
import 'package:bhakti_bhoomi/services/guruGranthSahib/GuruGranthSahibRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'guru_granth_sahib_event.dart';
part 'guru_granth_sahib_state.dart';

class GuruGranthSahibBloc extends Bloc<GuruGranthSahibEvent, GuruGranthSahibState> {
  GuruGranthSahibBloc({required  GuruGranthSahibRepository guruGranthSahibRepository}) : super(GuruGranthSahibState.initial()) {

    on<FetchGuruGranthSahibInfo>((event,emit) async{
      if (state.getInfo() != null) return emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.GURU_GRANTH_SAHIB_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.GURU_GRANTH_SAHIB_INFO,const HttpState.loading())));
      try {
        final info = await guruGranthSahibRepository.getInfo(cancelToken: event.cancelToken);
        info.data?.ragasInfo.sort((ragaA, ragaB) => ragaA.ragaNo-ragaB.ragaNo);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.GURU_GRANTH_SAHIB_INFO), guruGranthSahibInfo: info.data));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.GURU_GRANTH_SAHIB_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.GURU_GRANTH_SAHIB_INFO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchGuruGranthSahibRagaByRagaNoPartNo>((event,emit) async{
      if (state.getRaga(ragaNo: event.ragaNo, partNo: event.partNo) != null) return emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.GURU_GRANTH_SAHIB_RAGA)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.GURU_GRANTH_SAHIB_RAGA,const HttpState.loading())));
      try {
        final ragaRes = await guruGranthSahibRepository.getRagaByRagaNoPartNo(ragaNo: event.ragaNo,partNo: event.partNo,cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.GURU_GRANTH_SAHIB_RAGA), guruGranthSahibRagas: Map.fromEntries([...state.getRagas().entries,state.getEntry(ragaRes.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.GURU_GRANTH_SAHIB_RAGA, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.GURU_GRANTH_SAHIB_RAGA, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchGuruGranthSahibDescription>((event,emit) async{
      throw UnimplementedError();
    });

    on<FetchGuruGranthSahibRagaByRagaNamePartId>((event,emit) async{
      throw UnimplementedError();
    });

    on<FetchGuruGranthSahibRagaByRagaNamePartNo>((event,emit) async{
      throw UnimplementedError();
    });

    on<FetchGuruGranthSahibRagaByRagaNoPartId>((event,emit) async{
      throw UnimplementedError();
    });
  }
}
