class OrderAllDetailDeleteRequest {
  String OrderNo;
  String CompanyId;

  OrderAllDetailDeleteRequest({this.OrderNo, this.CompanyId});

  OrderAllDetailDeleteRequest.fromJson(Map<String, dynamic> json) {
    OrderNo = json['OrderNo'];

    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.OrderNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
