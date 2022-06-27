/*

LoginUserID:admin
CompanyId:4135
SearchKey:
*/

class ProfileListRequest {
  String LoginUserID;
  String SearchKey;
  String CompanyId;
  String CustomerType;
  String CustomerID;

  ProfileListRequest(
      {this.LoginUserID,
      this.SearchKey,
      this.CompanyId,
      this.CustomerType,
      this.CustomerID});

  ProfileListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    CompanyId = json['CompanyId'];
    CustomerType = json['CustomerType'];
    CustomerID = json['CustomerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyId;
    data['CustomerType'] = this.CustomerType;
    data['CustomerID'] = this.CustomerID;
    return data;
  }
}
