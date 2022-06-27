class OrderProductListRequest {
  /*Status:closed
CustomerID:12
CompanyId:4135*/

  String Status;
  String OrderNo;
  String CompanyId;
  String CustomerType;

  OrderProductListRequest(
      {this.Status, this.OrderNo, this.CompanyId, this.CustomerType});

  OrderProductListRequest.fromJson(Map<String, dynamic> json) {
    Status = json['Status'];
    OrderNo = json['OrderNo'];
    CompanyId = json['CompanyId'];
    CustomerType = json['CustomerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Status'] = this.Status;
    data['OrderNo'] = this.OrderNo;
    data['CompanyId'] = this.CompanyId;
    data['CustomerType'] = this.CustomerType;
    return data;
  }
}
