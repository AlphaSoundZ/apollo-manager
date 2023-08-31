class GetResponseBody {
  GetResponseBody({
    required this.status,
    required this.message,
    required this.code,
    required this.version,
    required this.timestamp,
    required this.request,
    required this.method,
    required this.page,
    required this.data,
    this.params = const {},
    this.search = const {},
  });

  final String status;
  final String message;
  final int code;
  final String version;
  final int timestamp;
  final String request;
  final String method;
  final ResponseBodyPage page;
  final dynamic data;
  final Map<String, dynamic> search;
  final Map<String, dynamic> params;

  factory GetResponseBody.fromJson(Map<String, dynamic> json) {
    return GetResponseBody(
      status: json['status'].toString(),
      message: json['message'].toString(),
      code: int.parse(json['code'].toString()),
      version: json['version'].toString(),
      timestamp: int.parse(json['timestamp'].toString()),
      request: json['request'].toString(),
      method: json['method'].toString(),
      page: ResponseBodyPage.fromJson(json['page']),
      data: json['data'],
      search: json['search'] ?? {},
      params: json['params'] ?? {},
    );
  }

  factory GetResponseBody.empty() {
    return GetResponseBody(
      status: '',
      message: '',
      code: 0,
      version: '',
      timestamp: 0,
      request: '',
      method: '',
      page: ResponseBodyPage(total: 0, current: 0, size: 0, totalRows: 0),
      data: [], // Setzen Sie dies auf den entsprechenden Datentyp
      search: {},
      params: {},
    );
  }

  bool isEmpty() {
    return code == 0;
  }
}

class ResponseBodyPage {
  ResponseBodyPage({
    required this.total,
    required this.current,
    required this.size,
    required this.totalRows,
  });

  final int total;
  final int current;
  final int size;
  final int totalRows;

  factory ResponseBodyPage.fromJson(Map<String, dynamic> json) {
    return ResponseBodyPage(
      total: json['total'],
      current: json['current'],
      size: json['size'],
      totalRows: json['total_rows'],
    );
  }
}
