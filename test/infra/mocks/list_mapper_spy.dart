import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

import '../../mocks/fakers.dart';

final class ListMapperSpy<Dto> extends ListMapper<Dto> {
  dynamic toDtoListInput;
  List<Dto>? toJsonArrInput;
  int toDtoListCallsCount = 0;
  int toJsonArrCallsCount = 0;
  List<Dto> toDtoListOutput;
  JsonArr toJsonArrOutput = anyJsonArr();

  ListMapperSpy({
    required this.toDtoListOutput
  });

  @override
  List<Dto> toDtoList(dynamic arr) {
    toDtoListInput = arr;
    toDtoListCallsCount++;
    return toDtoListOutput;
  }

  @override
  JsonArr toJsonArr(List<Dto> list) {
    toJsonArrInput = list;
    toJsonArrCallsCount++;
    return toJsonArrOutput;
  }

  @override
  Dto toDto(Json json) => throw UnimplementedError();

  @override
  Json toJson(Dto dto) => throw UnimplementedError();
}
