import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bhakti_bhoomi/services/mahabharat/MahabharatRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/mahabharat/MahabharatBookInfoModel.dart';

part 'mahabharat_event.dart';
part 'mahabharat_state.dart';

//caching detail
/*
  1. info is fetched first -> cached
  2. for each book chapter page -> shloks shown [we dont use this]
  3. fetch shlok by book,chapter,shlokNo
  4. fetch shlokById(this event or method is rarely used as beforeHand we dont know id and if we know id we already have that shlok)
*/
class MahabharatBloc extends Bloc<MahabharatEvent, MahabharatState> {
  MahabharatBloc({required MahabharatRepository mahabharatRepository}) : super(MahabharatState.initial()) {
    on<FetchMahabharatInfoEvent>((event, emit) async {
      if (state.allBooksInfo != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.MAHABHARATA_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_INFO,const HttpState.loading())));
      try {
        final booksInfoObj = await mahabharatRepository.getMahabharatInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.MAHABHARATA_INFO), bookInfo: booksInfoObj.data));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_INFO, HttpState.error(error: e.toString()))));
      }
    });

    //rarely used if used means we knoe id means already in cache;
    on<FetchMahabharatShlokById>((event, emit) async {
      if (state.existsShlokByKey(shlokId: event.id)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.MAHABHARATA_SHLOK_BY_ID)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOK_BY_ID,const HttpState.loading())));

      try {
        final shlokObj = await mahabharatRepository.getMahabharatShlokById(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(
            httpStates:state.httpStates.clone()..remove(Httpstates.MAHABHARATA_SHLOK_BY_ID),
            shloks: Map.fromIterable([
              state.allShloks,
              {shlokObj.data!.id: shlokObj.data}
            ])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOK_BY_ID, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOK_BY_ID, HttpState.error(error: e.toString()))));
      }
    });

    on<FetchMahabharatShlokByShlokNo>((event, emit) async {
      if (state.existsShlokByValue(bookNo: event.bookNo, chapterNo: event.chapterNo, shlokNo: event.shlokNo)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO,const HttpState.loading())));

      try {
        final shlokObj = await mahabharatRepository.getMahabharatShlokByShlokNo(bookNo: event.bookNo, chapterNo: event.chapterNo, shlokNo: event.shlokNo, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO), shloks: Map.fromEntries([...state.allShloks.entries, MahabharatState.shlokEntry(shlokObj.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO, HttpState.error(error: e.toString()))));
      }
    });

    //we do not use this if used fetched or not we fetch all shloks for this page as searching might take time
    on<FetchMahabharatShloksByBookChapter>((event, emit) async {
      //since mahabharatInfo is already fetched
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOKS_BY_BOOKNO_CHAPTERNO,const HttpState.loading())));

        final shloksObj = await mahabharatRepository.getMahabharatShloksByBookChapter(bookNo: event.bookNo, chapterNo: event.chapterNo, pageNo: event.pageNo, pageSize: event.pageSize, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.MAHABHARATA_SHLOKS_BY_BOOKNO_CHAPTERNO), shloks: Map.fromEntries([...state.allShloks.entries, ...((shloksObj.data!).map((shlok) => MahabharatState.shlokEntry(shlok)))])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOKS_BY_BOOKNO_CHAPTERNO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.MAHABHARATA_SHLOKS_BY_BOOKNO_CHAPTERNO, HttpState.error(error: e.toString()))));
      }
    });
  }
}
