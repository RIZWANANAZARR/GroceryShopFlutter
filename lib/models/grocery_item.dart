class GroceryItem {
  /* String name;
   String description;
   double price;
   String Nutritions;
   String imagePath;*/
  int pkID;
  String ProductName;
  String ProductAlias;
  int ProductID;
  int CustomerID;
  String Unit;
  double UnitPrice;
  double Quantity;
  double DiscountPer;
  String LoginUserID;
  String ComapanyID;
  String ProductSpecification;
  String ProductImage;
  bool IsInCart;
  double Vat;

  GroceryItem(
      {this.pkID,
      this.ProductName,
      this.ProductAlias,
      this.ProductID,
      this.CustomerID,
      this.Unit,
      this.UnitPrice,
      this.Quantity,
      this.DiscountPer,
      this.LoginUserID,
      this.ComapanyID,
      this.ProductSpecification,
      this.ProductImage,
      this.IsInCart,
      this.Vat});

  // GroceryItem({this.name, this.description, this.price, this.imagePath,this.Nutritions});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.ProductName;
    data['ProductAlias'] = this.ProductAlias;
    data['ProductID'] = this.ProductID;
    data['CustomerID'] = this.CustomerID;
    data['Unit'] = this.Unit;
    data['UnitPrice'] = this.UnitPrice;
    data['Quantity'] = this.Quantity;
    data['DiscountPer'] = this.DiscountPer;
    data['LoginUserID'] = this.LoginUserID;
    data['ComapanyID'] = this.ComapanyID;
    data['ProductSpecification'] = this.ProductSpecification;
    data['ProductImage'] = this.ProductImage;
    data['IsInCart'] = this.IsInCart;
    data['Vat'] = this.Vat;
    return data;
  }
}

var demoItems = [
  GroceryItem(
      ProductName: "Organic Bananas",
      ProductAlias: "7pcs, Priceg",
      ProductID: 1,
      CustomerID: 1,
      Unit: "KG",
      UnitPrice: 0.00,
      Quantity: 2,
      DiscountPer: 0.5,
      LoginUserID: "admin",
      ComapanyID: "4094",
      ProductSpecification: "Test",
      ProductImage:
          "http://122.169.111.101:206/productgroupimages/Kurkure.jpg"),
];
/*
var demoItems = [
  GroceryItem(
      name: "Organic Bananas",
      description: "7pcs, Priceg",
      price: 10.08,
      Nutritions : "100gm",
      imagePath: "assets/images/grocery_images/banana.png"),
  GroceryItem(
      name: "Red Apple",
      description: "1kg, Priceg",
      price: 14.99,
      Nutritions : "10gm",
      imagePath: "assets/images/grocery_images/apple.png"),
  GroceryItem(
      name: "Bell Pepper Red",
      description: "1kg, Priceg",
      price: 9.99,
      Nutritions : "70gm",
      imagePath: "assets/images/grocery_images/pepper.png"),
  GroceryItem(
      name: "Ginger",
      description: "250gm, Priceg",
      price: 8.99,
      Nutritions : "40gm",
      imagePath: "assets/images/grocery_images/ginger.png"),
  GroceryItem(
      name: "Ginger",
      description: "250gm, Priceg",
      price: 8.45,
      Nutritions : "90gm",
      imagePath: "assets/images/grocery_images/beef.png"),
  GroceryItem(
      name: "Ginger",
      description: "250gm, Priceg",
      price: 5.87,
      Nutritions : "120gm",
      imagePath: "assets/images/grocery_images/chicken.png"),
];

var exclusiveOffers = [demoItems[0], demoItems[5], demoItems[2], demoItems[1]];

var bestSelling = [demoItems[2], demoItems[3],demoItems[0]];

var groceries = [demoItems[4], demoItems[5],demoItems[3],demoItems[2]];

var beverages = [
  GroceryItem(
      name: "Dite Coke",
      description: "355ml, Price",
      price: 10.99,
      Nutritions : "120gm",
      imagePath: "assets/images/beverages_images/diet_coke.png"),
  GroceryItem(
      name: "Sprite Can",
      description: "325ml, Price",
      price: 1.59,
      Nutritions : "40gm",
      imagePath: "assets/images/beverages_images/sprite.png"),
  GroceryItem(
      name: "Apple Juice",
      description: "2L, Price",
      price: 17.97,
      Nutritions : "10gm",
      imagePath: "assets/images/beverages_images/apple_and_grape_juice.png"),
  GroceryItem(
      name: "Orange Juice",
      description: "2L, Price",
      price: 87.57,
      Nutritions : "125gm",
      imagePath: "assets/images/beverages_images/orange_juice.png"),
  GroceryItem(
      name: "Coca Cola Can",
      description: "325ml, Price",
      price: 48.35,
      Nutritions : "90gm",
      imagePath: "assets/images/beverages_images/coca_cola.png"),
  GroceryItem(
      name: "Pepsi Can",
      description: "330ml, Price",
      price: 35.61,
      Nutritions : "96gm",
      imagePath: "assets/images/beverages_images/pepsi.png"),
];
*/
