class LoginUserDetialsAPIRequest {
  String userID;
  String password;
  int companyId;


  LoginUserDetialsAPIRequest({this.userID, this.password, this.companyId});

  LoginUserDetialsAPIRequest.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    password = json['Password'];
    companyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['Password'] = this.password;
    data['CompanyId'] = this.companyId;
    return data;
  }
}

