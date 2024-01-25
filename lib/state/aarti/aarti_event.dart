part of 'aarti_bloc.dart';

@immutable
abstract class AartiEvent {
  const AartiEvent();
}

class FetchAartiInfoEvent extends AartiEvent {}

class FetchAartiEvent extends AartiEvent {
  final String aartiId;
  const FetchAartiEvent({required this.aartiId});
}
