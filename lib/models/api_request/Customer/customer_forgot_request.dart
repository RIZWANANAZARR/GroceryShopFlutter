
class ForgotRequest {
  String CompanyId;
  String ContactNo;
  String EmailAddress;

  ForgotRequest({this.CompanyId,this.ContactNo,this.EmailAddress});

  ForgotRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    ContactNo = json['ContactNo'];
    EmailAddress = json['EmailAddress'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['ContactNo'] =this.ContactNo;
    data['EmailAddress'] =this.EmailAddress;

    return data;
  }
}