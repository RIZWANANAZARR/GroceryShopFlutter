/*

InwardNo:IN-JUN22-003
CompanyId:4135
*/

class InwardProductListRequest {
  String InwardNo;
  String CompanyId;

  InwardProductListRequest({this.InwardNo, this.CompanyId});

  InwardProductListRequest.fromJson(Map<String, dynamic> json) {
    InwardNo = json['InwardNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InwardNo'] = this.InwardNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
