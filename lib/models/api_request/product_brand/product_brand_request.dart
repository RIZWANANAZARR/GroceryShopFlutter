class ProductBrandListRequest {
  String LoginUserID;
  String CompanyId;
  String ActiveFlag;
  String SearchKey;
/*LoginUserID:admin
CompanyId:4094*/

  ProductBrandListRequest(
      {this.ActiveFlag, this.LoginUserID, this.CompanyId, this.SearchKey});

  ProductBrandListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    ActiveFlag = json['ActiveFlag'];
    CompanyId = json['CompanyId'];
    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['ActiveFlag'] = this.ActiveFlag;
    data['CompanyId'] = this.CompanyId;
    data['SearchKey'] = this.SearchKey;
    return data;
  }
}
