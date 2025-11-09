import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/shared/models/waste/waste_model.dart';

abstract class WasteManageRepository {
  Future<Result<String, Exception>> addWasteData();
  Future<Result<WasteModel, BackendError>> fetchWaste(
    DateTime date,
    TimingModel timing,
  );
}

class WasteManageRepositoryImpl implements WasteManageRepository {
  final Dio _dioClient;

  WasteManageRepositoryImpl(this._dioClient);

  Future<Result<String, Exception>> addWasteData() async {
    try {
      await _dioClient.post(Endpoints.waste, data: {/* waste data */});
      return Success('Waste data added successfully');
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<WasteModel, BackendError>> fetchWaste(
    DateTime date,
    TimingModel timing,
  ) async {
    try {
      final response = await _dioClient.get(
        Endpoints.waste,
        queryParameters: {
          'timing': timing.id,
        },
      );
      return Success(WasteModel.fromJson(response.data[0]));
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }
}
