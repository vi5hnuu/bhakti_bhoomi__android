import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramcharitmanas_event.dart';
part 'ramcharitmanas_state.dart';

class RamcharitmanasBloc extends Bloc<RamcharitmanasEvent, RamcharitmanasState> {
  RamcharitmanasBloc({required RamcharitmanasRepository ramcharitmanasRepository}) : super(RamcharitmanasState.initial()) {
    on<FetchRamcharitmanasInfo>((event, emit) async {
      if (state.info != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RAMCHARITMANAS_INFO)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_INFO,const HttpState.loading())));
        final ramcharitManasInfo = await ramcharitmanasRepository.getRamcharitmanasInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RAMCHARITMANAS_INFO), info: ramcharitManasInfo.data!));
      }   on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_INFO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });
    on<FetchRamcharitmanasVerseById>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasVerseByKandaAndVerseNo>((event, emit) async {
      if (state.verseExists(kand: event.kanda, verseNo: event.verseNo, lang: event.lang)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO,const HttpState.loading())));
        final verseData = await ramcharitmanasRepository.getRamcharitmanasVerseByKandaAndVerseNo(kanda: event.kanda, verseNo: event.verseNo, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO), verses: Map.fromEntries([...state.allVerses.entries, state.getVerseEntry(verseData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_VERSE_BY_KAND_VERSENO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });
    on<FetchRamcharitmanasMangalacharanByKanda>((event, emit) async {
      if (state.mangalacharanExists(kand: event.kanda, lang: event.lang)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RAMCHARITMANAS_MANGALACHARAN_BY_KAND)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_MANGALACHARAN_BY_KAND,const HttpState.loading())));
        final mangalacharanData = await ramcharitmanasRepository.getRamcharitmanasMangalacharanByKanda(kanda: event.kanda, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RAMCHARITMANAS_MANGALACHARAN_BY_KAND), mangalacharan: Map.fromEntries([...state.allMangalacharan.entries, state.getMangalacharanEntry(mangalacharanData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_MANGALACHARAN_BY_KAND, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMCHARITMANAS_MANGALACHARAN_BY_KAND, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });
    on<FetchRamcharitmanasAllMangalacharan>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasVersesByKand>((event, emit) {
      // TODO: implement event handler
    });
  }
}
