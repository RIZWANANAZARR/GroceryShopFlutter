class ProductBrandSearchRequest {
  String LoginUserID;
  String CompanyId;
  int pkID;
  String SearchKey;


  ProductBrandSearchRequest({this.LoginUserID, this.CompanyId,this.pkID,this.SearchKey});

  ProductBrandSearchRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    pkID = json['pkID'];
    CompanyId = json['CompanyId'];
    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    return data;
  }
}

