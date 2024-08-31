part of 'vratKatha_bloc.dart';

@Immutable("cannot modify aarti state")
class VratKathaState extends Equatable with WithHttpState {
  final Map<String, VratkathaModel> kathas; //kathaId,katha
  final Map<String,VratkathaInfoModel> kathaInfos;//kathaId,kathaInfo
  static const pageSize=20;
  final int totalPages;

  VratKathaState._({
    Map<String,HttpState>? httpStates,
    this.kathas=const {},
    this.kathaInfos=const {},
    this.totalPages=0,
  }){
    this.httpStates.addAll(httpStates ?? {});
  }

  VratKathaState.initial()
      : this._(
          httpStates: const {},
          kathas: const {},
          kathaInfos: const {},
          totalPages: 0
        );

  VratKathaState copyWith({
    Map<String, HttpState>? httpStates,
    Map<String, VratkathaModel>? kathas,
    Map<String,VratkathaInfoModel>? kathaInfos,
    int? totalPages
  }) {
    return VratKathaState._(
      httpStates: httpStates ?? this.httpStates,
      kathas: kathas ?? this.kathas,
      kathaInfos: kathaInfos ?? this.kathaInfos,
      totalPages: totalPages ?? this.totalPages
    );
  }

  VratkathaModel? getVratKatha(String kathaId) {
    return kathas[kathaId];
  }

  MapEntry<String, VratkathaModel> getEntry(VratkathaModel katha) => MapEntry(katha.id, katha);

  hasKathaInfoPage({required int pageNo}){
    if(pageNo<=0) throw Exception("pageNo should be greater than 0");
    return (kathaInfos.isNotEmpty && (kathaInfos.length*1.0/pageSize).ceil()==totalPages) ? true : kathaInfos.length>=(pageNo*pageSize);
  }

  getKathaInfo({required String kathaId}){
    return kathaInfos[kathaId];
  }

  getKathaInfoAt({required int at}){
    return kathaInfos.values.length>at ? kathaInfos.values.elementAt(at) : null;
  }

  @override
  List<Object?> get props => [httpStates, kathas, kathaInfos];
}
