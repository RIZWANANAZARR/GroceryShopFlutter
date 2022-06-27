/*BrandID:1
CompanyId:4135*/

class TabProductListRequest {
  String GroupID;
  String CompanyId;
  String ActiveFlag;

  TabProductListRequest({this.GroupID, this.CompanyId, this.ActiveFlag});

  TabProductListRequest.fromJson(Map<String, dynamic> json) {
    GroupID = json['GroupID'];
    CompanyId = json['CompanyId'];
    ActiveFlag = json['ActiveFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupID'] = this.GroupID;
    data['CompanyId'] = this.CompanyId;
    data['ActiveFlag'] = this.ActiveFlag;
    return data;
  }
}
