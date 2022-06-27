/*BrandID:30
GroupID:2
ActiveFlag:0
CompanyId:4135*/

/*BrandID:1
CompanyId:4135*/

class TabProductListBrandIDGroupIDRequest {
  String BrandID;
  String GroupID;
  String CompanyId;
  String ActiveFlag;

  TabProductListBrandIDGroupIDRequest(
      {this.BrandID, this.GroupID, this.CompanyId, this.ActiveFlag});

  TabProductListBrandIDGroupIDRequest.fromJson(Map<String, dynamic> json) {
    BrandID = json['BrandID'];
    GroupID = json['GroupID'];
    CompanyId = json['CompanyId'];
    ActiveFlag = json['ActiveFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['BrandID'] = this.BrandID;
    data['GroupID'] = this.GroupID;
    data['CompanyId'] = this.CompanyId;
    data['ActiveFlag'] = this.ActiveFlag;
    return data;
  }
}
