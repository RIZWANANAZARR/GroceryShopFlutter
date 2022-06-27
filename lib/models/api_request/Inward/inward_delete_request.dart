/*pkID:13
CompanyId:4135*/

class InwardDeleteRequest {
  String InwardNo;
  String CompanyId;

  InwardDeleteRequest({this.InwardNo, this.CompanyId});

  InwardDeleteRequest.fromJson(Map<String, dynamic> json) {
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
