class ReportRequest {
  String? detail;
  String? type;
  String? email;

  ReportRequest({this.detail, this.type, this.email});

  ReportRequest.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    type = json['type'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detail'] = detail;
    data['type'] = type;
    data['email'] = email;
    return data;
  }
}