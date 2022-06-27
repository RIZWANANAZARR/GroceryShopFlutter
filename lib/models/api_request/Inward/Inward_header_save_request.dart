/*InwardNo:
InwardDate:2022-06-07
CustomerID:7
LoginUserID:admin
CompanyId:4135*/

class InwardHeaderSaveRequest {
  String InwardNo;
  String InwardDate;
  String CustomerID;
  String LoginUserID;
  String CompanyId;

  InwardHeaderSaveRequest(
      {this.InwardNo,
      this.InwardDate,
      this.CustomerID,
      this.LoginUserID,
      this.CompanyId});

  InwardHeaderSaveRequest.fromJson(Map<String, dynamic> json) {
    InwardNo = json['InwardNo'];
    InwardDate = json['InwardDate'];
    CustomerID = json['CustomerID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InwardNo'] = this.InwardNo;
    data['InwardDate'] = this.InwardDate;
    data['CustomerID'] = this.CustomerID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
