class ForgotResponse {
  List<ForgotResponseDetails> details;
  int totalCount;

  ForgotResponse({this.details, this.totalCount});

  ForgotResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ForgotResponseDetails.fromJson(v));
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

class ForgotResponseDetails {
  int customerID;
  String customername;
  String emailAddress;
  String contactNo;
  String password;

  ForgotResponseDetails(
      {this.customerID,
      this.customername,
      this.emailAddress,
      this.contactNo,
      this.password});

  ForgotResponseDetails.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customername = json['Customername'] == null ? "" : json['Customername'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    contactNo = json['ContactNo'] == null ? "" : json['ContactNo'];
    password = json['Password'] == null ? "" : json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['Customername'] = this.customername;
    data['EmailAddress'] = this.emailAddress;
    data['ContactNo'] = this.contactNo;
    data['Password'] = this.password;
    return data;
  }
}
