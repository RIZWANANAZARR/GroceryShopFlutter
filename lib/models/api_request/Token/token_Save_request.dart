/*
CompanyId:4135
CustomerID:17
DeviceID:test123
TokenNo:fkjsd123
LoginUserID:sahil
pkID:0

*/

class TokenSaveApiRequest {
  String CompanyId;
  String CustomerID;
  String DeviceID;
  String TokenNo;
  String LoginUserID;
  String pkID;

  TokenSaveApiRequest(
      {this.CompanyId,
      this.CustomerID,
      this.DeviceID,
      this.TokenNo,
      this.LoginUserID,
      this.pkID});

  TokenSaveApiRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    CustomerID = json['CustomerID'];
    DeviceID = json['DeviceID'];
    TokenNo = json['TokenNo'];
    LoginUserID = json['LoginUserID'];
    pkID = json['pkID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['CustomerID'] = this.CustomerID;
    data['DeviceID'] = this.DeviceID;
    data['TokenNo'] = this.TokenNo;
    data['LoginUserID'] = this.LoginUserID;
    data['pkID'] = this.pkID;

    return data;
  }
}
