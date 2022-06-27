class OrderCustomerListRequest {
  /*SearchKey:sahil
Status:open
CompanyId:4135*/

  String SearchKey;
  String Status;
  String CompanyId;

  OrderCustomerListRequest({this.SearchKey, this.Status, this.CompanyId});

  OrderCustomerListRequest.fromJson(Map<String, dynamic> json) {
    SearchKey = json['SearchKey'];
    Status = json['Status'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['SearchKey'] = this.SearchKey;
    data['Status'] = this.Status;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
