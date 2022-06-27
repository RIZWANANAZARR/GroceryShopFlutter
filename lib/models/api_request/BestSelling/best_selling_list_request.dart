


class BestSellingListRequest {
  String Top10;
  String CompanyId;

  BestSellingListRequest({this.Top10,this.CompanyId});

  BestSellingListRequest.fromJson(Map<String, dynamic> json) {
    Top10 = json['Top10'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Top10'] = this.Top10;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}