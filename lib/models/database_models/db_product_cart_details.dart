class ProductCartModel {
  /*String name;
   String description;
   double price;
   int Qty;
   String Nutritions;
   String imagePath;*/
  int id;
  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  int Quantity;
  double DiscountPercent;
  String LoginUserID;
  String CompanyId;
  String ProductSpecification;
  String ProductImage;
  double vat;

  ProductCartModel(
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
      this.ProductImage,
      this.vat,
      {this.id});
  //ProductCartModel(this.name, this.description, this.price, this.Qty,this.Nutritions, this.imagePath,{this.id });

  /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['Qty'] = this.Qty;
    data['Nutritions'] = this.Nutritions;
    data['imagePath'] = this.imagePath;
    return data;
  }*/

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
    data['vat'] = this.vat;

    return data;
  }

  @override
  String toString() {
    return 'ProductCartModel{id: $id, ProductName: $ProductName, ProductAlias: $ProductAlias, ProductID: $ProductID, CustomerID: $CustomerID, Unit: $Unit, UnitPrice: $UnitPrice, Quantity: $Quantity, DiscountPer: $DiscountPercent, LoginUserID: $LoginUserID, ComapanyID: $CompanyId, ProductSpecification: $ProductSpecification, ProductImage: $ProductImage,vat :$vat}';
  }
}
