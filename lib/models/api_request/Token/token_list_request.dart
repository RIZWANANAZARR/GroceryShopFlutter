/*
CompanyId:4135
CustomerID:17
DeviceID:test123
TokenNo:fkjsd123
LoginUserID:sahil
pkID:0

*/

class TokenListApiRequest {
  String CompanyId;
  String CustomerID;

  TokenListApiRequest({
    this.CompanyId,
    this.CustomerID,
  });

  TokenListApiRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    CustomerID = json['CustomerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['CustomerID'] = this.CustomerID;

    return data;
  }
}
