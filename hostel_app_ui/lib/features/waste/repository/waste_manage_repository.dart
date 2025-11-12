import 'package:dio/dio.dart';
import 'package:hostel_app/app/core/api/endpoints.dart';
import 'package:hostel_app/app/core/result/result.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/shared/models/waste/waste_model.dart';
import 'package:hostel_app/features/waste/model/waste_create.dart';
import 'package:intl/intl.dart';

abstract class WasteRepository {
  Future<Result<bool, BackendError>> addWaste(
    WasteCreateModel waste,
  );
  Future<Result<bool, BackendError>> updateWaste(
    int id,
    WasteCreateModel waste,
  );

  Future<Result<WasteModel, Object>> fetchSingleWaste(
    DateTime date,
    TimingModel timing,
  );
  Future<Result<List<WasteModel>, BackendError>> fetchWastes(
    HostelModel? hostel,
    DateTime? from,
    DateTime? to,
  );
}

class WasteRepositoryImpl implements WasteRepository {
  final Dio _dioClient;

  WasteRepositoryImpl(this._dioClient);

  Future<Result<bool, BackendError>> addWaste(
    WasteCreateModel waste,
  ) async {
    try {
      await _dioClient.post(Endpoints.waste, data: waste.toJson());
      return Success(true);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  Future<Result<bool, BackendError>> updateWaste(
    int id,
    WasteCreateModel waste,
  ) async {
    try {
      await _dioClient.patch('${Endpoints.waste}${id}/', data: waste.toJson());
      return Success(true);
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }

  Future<Result<WasteModel, Object>> fetchSingleWaste(
    DateTime date,
    TimingModel timing,
  ) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await _dioClient.get(
        Endpoints.waste,
        queryParameters: {
          'timing': timing.id,
          'date': formattedDate,
        },
      );
      print(response.data);
      return Success(WasteModel.fromJson(response.data[0]));
    } catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<WasteModel>, BackendError>> fetchWastes(
    HostelModel? hostel,
    DateTime? from,
    DateTime? to,
  ) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    try {
      final response = await _dioClient.get(
        Endpoints.waste,
        queryParameters: {
          'hostel': hostel?.id,
          'date_range_after': from != null ? dateFormat.format(from) : null,
          'date_range_before': to != null ? dateFormat.format(to) : null,
        },
      );
      print(response.data);
      return Success(
        response.data
            .map<WasteModel>((val) => WasteModel.fromJson(val))
            .toList(),
      );
    } on DioException catch (e) {
      return Failure(BackendError.fromJson(e.response?.data));
    }
  }
}
