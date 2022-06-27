class CategoryListRequest {
  String BrandID;
  String ProductGroupID;
  String ProductID;
  String CompanyId;
  String SearchKey;
  String ActiveFlag;

  CategoryListRequest(
      {this.BrandID,
      this.ProductGroupID,
      this.ProductID,
      this.CompanyId,
      this.SearchKey,
      this.ActiveFlag});

  CategoryListRequest.fromJson(Map<String, dynamic> json) {
    BrandID = json['BrandID'];
    ProductGroupID = json['ProductGroupID'];
    ProductID = json['ProductID'];
    CompanyId = json['CompanyId'];
    SearchKey = json['SearchKey'];
    ActiveFlag = json['ActiveFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.BrandID;
    data['ProductGroupID'] = this.ProductGroupID;
    data['ProductID'] = this.ProductID;
    data['CompanyId'] = this.CompanyId;
    data['SearchKey'] = this.SearchKey;
    data['ActiveFlag'] = this.ActiveFlag;

    return data;
  }
}
