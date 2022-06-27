class LoginResponse {
  List<LoginResponseDetails> details;
  int totalCount;

  LoginResponse({this.details, this.totalCount});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new LoginResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class LoginResponseDetails {
  int customerID;
  String customerName;
  String contactNo;
  String address;
  String emailAddress;
  String password;
  String customerType;
  bool BlockCustomer;

  LoginResponseDetails(
      {this.customerID,
      this.customerName,
      this.contactNo,
      this.address,
      this.emailAddress,
      this.password,
      this.customerType,
      this.BlockCustomer});

  LoginResponseDetails.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    contactNo = json['ContactNo'];
    address = json['Address'];
    emailAddress = json['EmailAddress'];
    password = json['Password'];
    customerType = json['CustomerType'] == null ? "" : json['CustomerType'];
    BlockCustomer =
        json['BlockCustomer'] == null ? false : json['BlockCustomer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactNo'] = this.contactNo;
    data['Address'] = this.address;
    data['EmailAddress'] = this.emailAddress;
    data['Password'] = this.password;
    data['CustomerType'] = this.customerType;
    data['BlockCustomer'] = this.BlockCustomer;
    return data;
  }
}
