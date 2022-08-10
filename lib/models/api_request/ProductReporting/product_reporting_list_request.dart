/*SearchKey:
CompanyId:4135*/
class ProductReportingListRequest {
  String SearchKey;
  String CompanyId;

  ProductReportingListRequest({this.SearchKey, this.CompanyId});

  ProductReportingListRequest.fromJson(Map<String, dynamic> json) {
    SearchKey = json['SearchKey'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
