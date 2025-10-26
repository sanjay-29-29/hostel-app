import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/result/result.dart';

abstract class WasteManageRepository {
  Future<Result<String, Exception>> addWasteData();
}

class WasteManageRepositoryImpl implements WasteManageRepository {
  final Dio _dioClient;

  WasteManageRepositoryImpl(this._dioClient);

  Future<Result<String, Exception>> addWasteData() async {
    try {
      await _dioClient.post('/waste', data: {/* waste data */});
      return Success('Waste data added successfully');
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
