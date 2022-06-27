class ProductGroupDropDownRequest {
  String CompanyId;
  String BrandID;
  ProductGroupDropDownRequest({this.CompanyId, this.BrandID});

  ProductGroupDropDownRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    BrandID = json['BrandID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['BrandID'] = this.BrandID;
    return data;
  }
}
