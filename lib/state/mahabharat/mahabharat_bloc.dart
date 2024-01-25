import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bhakti_bhoomi/services/mahabharat/MahabharatRepository.dart';
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
      if (state.allBooksInfo != null) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final booksInfoObj = await mahabharatRepository.getMahabharatInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, bookInfo: booksInfoObj.data));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: _handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });

    //rarely used if used means we knoe id means already in cache;
    on<FetchMahabharatShlokById>((event, emit) async {
      if (state.existsShlokByKey(shlokId: event.id)) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final shlokObj = await mahabharatRepository.getMahabharatShlokById(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(
            isLoading: false,
            shloks: Map.fromIterable([
              state.allShloks,
              {shlokObj.data!.id: shlokObj.data}
            ])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: _handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });

    on<FetchMahabharatShlokByShlokNo>((event, emit) async {
      if (state.existsShlokByValue(bookNo: event.bookNo, chapterNo: event.chapterNo, shlokNo: event.shlokNo)) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final shlokObj = await mahabharatRepository.getMahabharatShlokByShlokNo(bookNo: event.bookNo, chapterNo: event.chapterNo, shlokNo: event.shlokNo, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, shloks: Map.fromEntries([...state.allShloks.entries, MahabharatState.shlokEntry(shlokObj.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: _handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });

    //we do not use this if used fetched or not we fetch all shloks for this page as searching might take time
    on<FetchMahabharatShloksByBookChapter>((event, emit) async {
      //since mahabharatInfo is already fetched
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final shloksObj =
            await mahabharatRepository.getMahabharatShloksByBookChapter(bookNo: event.bookNo, chapterNo: event.bookNo, pageNo: event.pageNo, pageSize: event.pageSize, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, shloks: Map.fromEntries([...state.allShloks.entries, ...((shloksObj.data!).map((shlok) => MahabharatState.shlokEntry(shlok)))])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: _handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
  }

  String? _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return null;
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return "please check your internet connection.";
      default:
        return e.message;
    }
  }
}
