import 'dart:async';

import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';

sealed class GlobalEvent{}

class LogOutEvent extends GlobalEvent{}

class GlobalEventDispatcherSingleton {
  final StreamController<GlobalEvent> _streamController;
  static final GlobalEventDispatcherSingleton _instance = GlobalEventDispatcherSingleton._();//single subscription can happen
  // GlobalEventDispatcherSingleton._():_streamController=StreamController<GlobalEvent>();
  GlobalEventDispatcherSingleton._():_streamController=StreamController<GlobalEvent>.broadcast();

  factory GlobalEventDispatcherSingleton() {
    return _instance;
  }

  get stream{
    return _streamController.stream;
  }

  dispatch({required GlobalEvent event}){
    _streamController.add(event);
  }
}

final GlobalEventDispatcherSingleton globalEventDispatcher=GlobalEventDispatcherSingleton();
