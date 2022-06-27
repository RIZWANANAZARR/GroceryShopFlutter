/*

pkID:
ListMode:
LoginUserID:sahil
SearchKey:
CompanyId:4135
*/

class ManagePaymentListRequest {
  String pkID;
  String ListMode;
  String LoginUserID;
  String SearchKey;
  String CompanyId;
/*LoginUserID:admin
CompanyId:4094
SearchKey:*/

  ManagePaymentListRequest(
      {this.pkID,
      this.ListMode,
      this.LoginUserID,
      this.SearchKey,
      this.CompanyId});

  ManagePaymentListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ListMode = json['ListMode'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ListMode'] = this.ListMode;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
