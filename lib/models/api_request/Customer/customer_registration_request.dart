

class CustomerRegistrationRequest {

  String CustomerName;
  String Address;
  String EmailAddress;
  String ContactNo;
  String LoginUserID;
  String BlockCustomer;
  String ProfileImage;
  String Password;
  String CompanyId;
  String CustomerType;

  CustomerRegistrationRequest({
    this.CustomerName,
    this.Address,
    this.EmailAddress,
    this.ContactNo,
    this.LoginUserID,
    this.BlockCustomer,
    this.ProfileImage,
    this.Password,
    this.CompanyId,
    this.CustomerType
  });




  CustomerRegistrationRequest.fromJson(Map<String, dynamic> json) {
    CustomerName = json['CustomerName'];
    Address = json['Address'];
    EmailAddress = json['EmailAddress'];
    ContactNo = json['ContactNo'];
    LoginUserID = json['LoginUserID'];
    BlockCustomer = json['BlockCustomer'];
    ProfileImage = json['ProfileImage'];
    Password = json['Password'];
    CompanyId = json['CompanyId'];
    CustomerType = json['CustomerType'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerName'] = this.CustomerName;
    data['Address'] = this.Address;
    data['EmailAddress'] = this.EmailAddress;
    data['ContactNo'] = this.ContactNo;
    data['LoginUserID'] = this.LoginUserID;
    data['BlockCustomer'] = this.BlockCustomer;
    data['ProfileImage'] = this.ProfileImage;
    data['Password'] = this.Password;
    data['CompanyId'] = this.CompanyId;
    data['CustomerType']=this.CustomerType;

    return data;
  }
}