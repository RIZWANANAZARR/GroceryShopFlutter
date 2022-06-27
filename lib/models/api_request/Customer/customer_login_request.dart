/*EmailAddress:sahil.patel0605@gmail.com
Password:sahil0605
CompanyId:4094*/

class LoginRequest {
  String CompanyId;
  String EmailAddress;
  String Password;

  LoginRequest({this.CompanyId,this.EmailAddress,this.Password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    EmailAddress = json['EmailAddress'];
    Password = json['Password'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['EmailAddress'] =this.EmailAddress;
    data['Password'] =this.Password;

    return data;
  }
}