class ProductCartDetailsRequest {
  String CompanyId;
  String CustomerID;

  ProductCartDetailsRequest({this.CompanyId,this.CustomerID});

  ProductCartDetailsRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    CustomerID = json['CustomerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['CustomerID'] =this.CustomerID;
    return data;
  }
}