class ResponseModel {
  bool success;
  int statusCode;
  dynamic data;
  List<String>? errorModel;

  ResponseModel(
      {required this.statusCode,
      this.success = false,
      this.data,
      this.errorModel});

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'data': data,
      'errorModel': errorModel,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
        success: map['success'] as bool,
        statusCode: map['statusCode'] as int,
        data: map['data'] as dynamic,
        errorModel: map['errorModel'] as List<String>?);
  }
}
