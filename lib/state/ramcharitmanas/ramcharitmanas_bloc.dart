import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramcharitmanas_event.dart';
part 'ramcharitmanas_state.dart';

class RamcharitmanasBloc extends Bloc<RamcharitmanasEvent, RamcharitmanasState> {
  RamcharitmanasBloc({required RamcharitmanasRepository ramcharitmanasRepository}) : super(RamcharitmanasState.initial()) {
    on<FetchRamcharitmanasInfo>((event, emit) async {
      if (state.info != null) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final ramcharitManasInfo = await ramcharitmanasRepository.getRamcharitmanasInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, info: ramcharitManasInfo.data!));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchRamcharitmanasVerseById>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasVerseByKandaAndVerseNo>((event, emit) async {
      if (state.verseExists(kand: event.kanda, verseNo: event.verseNo, lang: event.lang)) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final verseData = await ramcharitmanasRepository.getRamcharitmanasVerseByKandaAndVerseNo(kanda: event.kanda, verseNo: event.verseNo, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, verses: Map.fromEntries([...state.allVerses.entries, state.getVerseEntry(verseData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchRamcharitmanasMangalacharanByKanda>((event, emit) async {
      if (state.mangalacharanExists(kand: event.kanda, lang: event.lang)) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final mangalacharanData = await ramcharitmanasRepository.getRamcharitmanasMangalacharanByKanda(kanda: event.kanda, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, mangalacharan: Map.fromEntries([...state.allMangalacharan.entries, state.getMangalacharanEntry(mangalacharanData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
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
