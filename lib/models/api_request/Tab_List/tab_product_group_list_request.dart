/*BrandID:1
CompanyId:4135*/

class TabProductGroupListRequest {
  String BrandID;
  String CompanyId;
  String ActiveFlag;
  String SearchKey;

  TabProductGroupListRequest(
      {this.BrandID, this.CompanyId, this.ActiveFlag, this.SearchKey});

  TabProductGroupListRequest.fromJson(Map<String, dynamic> json) {
    BrandID = json['BrandID'];
    CompanyId = json['CompanyId'];
    ActiveFlag = json['ActiveFlag'];
    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.BrandID;
    data['CompanyId'] = this.CompanyId;
    data['ActiveFlag'] = this.ActiveFlag;
    data['SearchKey'] = this.SearchKey;
    return data;
  }
}
