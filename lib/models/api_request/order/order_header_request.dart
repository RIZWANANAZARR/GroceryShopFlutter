class OrderHeaderJsonDetails {
  /*

        pkID
        OrderNo
        OrderDate
        CustomerID
        Latitude
        Longitude
        DeliveryDate
        BasicAmt
        DiscountAmt
        Remarks
        NetAmt
        LoginUserID
        CompanyId

  */

  String pkID;
  String OrderNo;
  String OrderDate;
  String CustomerID;
  String Latitude;
  String Longitude;
  String DeliveryDate;
  String BasicAmt;
  String DiscountAmt;
  String Remarks;
  String NetAmt;
  String LoginUserID;
  String CompanyId;

  OrderHeaderJsonDetails(
      {this.pkID,
      this.OrderNo,
      this.OrderDate,
      this.CustomerID,
      this.Latitude,
      this.Longitude,
      this.DeliveryDate,
      this.BasicAmt,
      this.DiscountAmt,
      this.Remarks,
      this.NetAmt,
      this.LoginUserID,
      this.CompanyId});

  OrderHeaderJsonDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    OrderNo = json['OrderNo'];
    OrderDate = json['OrderDate'];
    CustomerID = json['CustomerID'];
    Latitude = json['Latitude'];
    Longitude = json['Longitude'];
    DeliveryDate = json['DeliveryDate'];
    BasicAmt = json['BasicAmt'];
    DiscountAmt = json['DiscountAmt'];
    Remarks = json['Remarks'];
    NetAmt = json['NetAmt'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['OrderNo'] = this.OrderNo;
    data['OrderDate'] = this.OrderDate;
    data['CustomerID'] = this.CustomerID;
    data['Latitude'] = this.Latitude;
    data['Longitude'] = this.Longitude;
    data['DeliveryDate'] = this.DeliveryDate;
    data['BasicAmt'] = this.BasicAmt;
    data['DiscountAmt'] = this.DiscountAmt;
    data['Remarks'] = this.Remarks;
    data['NetAmt'] = this.NetAmt;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
