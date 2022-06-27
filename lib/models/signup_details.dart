class SignUpDetails {
  String Email="";
  String UserName="";
  String Password="";
  String Address="";



  SignUpDetails({this.Email,this.UserName,this.Password,this.Address});

  SignUpDetails.fromJson(Map<String, dynamic> json) {
    Email = json['Email'];
    UserName = json['UserName'];
    Password = json['Password'];
    Address = json['Address'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.Email;
    data['UserName'] = this.UserName;
    data['Password'] = this.Password;
    data['Address'] = this.Address;

    return data;
  }
}