class InWardProductModel {
  /* "pkID": 10023,
        "ProductID": 8,
        "Quantity": 5,
        "Unit": "ltr",
        "UnitRate": 350,
        "Amount": 0,
        "NetAmount": 0,
        "LoginUserID": "admin",
        "CompanyId": 4135*/

  int id;
  int ProductID, CompanyId;
  double Quantity, UnitRate, Amount, NetAmount;
  String ProductName, Unit, LoginUserID, InwardNo;

  InWardProductModel(
      this.InwardNo,
      this.ProductID,
      this.CompanyId,
      this.Quantity,
      this.UnitRate,
      this.Amount,
      this.NetAmount,
      this.ProductName,
      this.Unit,
      this.LoginUserID,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InwardNo'] = this.InwardNo;
    data['ProductID'] = this.ProductID;
    data['CompanyId'] = this.CompanyId;
    data['Quantity'] = this.Quantity;
    data['UnitRate'] = this.UnitRate;
    data['Amount'] = this.Amount;
    data['NetAmount'] = this.NetAmount;
    data['ProductName'] = this.ProductName;
    data['Unit'] = this.Unit;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }

  @override
  String toString() {
    return 'InWardProductModel{id: $id, InwardNo: $InwardNo, ProductID: $ProductID, CompanyId: $CompanyId, Quantity: $Quantity, UnitRate: $UnitRate, Amount: $Amount, NetAmount: $NetAmount, ProductName: $ProductName, Unit: $Unit, LoginUserID: $LoginUserID}';
  }
}
