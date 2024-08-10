import 'package:bhakti_bhoomi/models/HttpState.dart';

mixin WithHttpState{
  final Map<String, HttpState> httpStates={};

  bool isLoading({required final String forr}){
    return httpStates.containsKey(forr) && httpStates[forr]!.loading;
  }

  bool anyLoading({required final List<String> forr}){
    for(final key in forr){
      if(httpStates.containsKey(key) && httpStates[key]!.loading) return true;
    }
    return false;
  }

  bool anyError({required final List<String> forr}){
    for(final key in forr){
      if(httpStates[key]?.error!=null) return true;
    }
    return false;
  }

  String? getAnyError({required final List<String> forr}){
    for(final key in forr){
      if(httpStates[key]?.error!=null) return httpStates[key]?.error;
    }
    return null;
  }

  bool isError({required final String forr}){
    return httpStates.containsKey(forr) && httpStates[forr]!.error!=null;
  }

  String? getError({required final String forr}){
    return httpStates[forr]?.error;
  }

  bool hasHttpState({required final String forr}){
    return httpStates[forr]!=null;
  }

  printStates(){
    for(final kv in httpStates.entries){
      print("http state ${kv.key} --> ${kv.value.error}/${kv.value.loading}");
    }
  }
}