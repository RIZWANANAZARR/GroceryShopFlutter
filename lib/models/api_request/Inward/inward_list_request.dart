/*LoginUserID:admin
SearchKey:
CompanyId:4135*/

class InwardListRequest {
  String LoginUserID;
  String SearchKey;
  String CompanyId;

  InwardListRequest({this.LoginUserID, this.SearchKey, this.CompanyId});

  InwardListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
