class CartModel {


  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPercent;
  String LoginUserID;
  String CompanyId;
  String ProductSpecification;
  String ProductImage;


  CartModel({
      this.ProductName,
      this.ProductAlias,
      this.ProductID,
      this.CustomerID,
      this.Unit,
      this.UnitPrice,
      this.Quantity,
      this.DiscountPercent,
      this.LoginUserID,
      this.CompanyId,
      this.ProductSpecification,
      this.ProductImage});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.ProductName;
    data['ProductAlias'] = this.ProductAlias;
    data['ProductID'] = this.ProductID;
    data['CustomerID'] = this.CustomerID;
    data['Unit'] = this.Unit;
    data['UnitPrice'] = this.UnitPrice;
    data['Quantity'] = this.Quantity;
    data['DiscountPercent'] = this.DiscountPercent;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['ProductSpecification'] = this.ProductSpecification;
    data['ProductImage'] = this.ProductImage;


    return data;

  }


  @override
  String toString() {
    return 'ProductCartModel{ProductName: $ProductName, ProductAlias: $ProductAlias, ProductID: $ProductID, CustomerID: $CustomerID, Unit: $Unit, UnitPrice: $UnitPrice, Quantity: $Quantity, DiscountPer: $DiscountPercent, LoginUserID: $LoginUserID, ComapanyID: $CompanyId, ProductSpecification: $ProductSpecification, ProductImage: $ProductImage}';
  }


}