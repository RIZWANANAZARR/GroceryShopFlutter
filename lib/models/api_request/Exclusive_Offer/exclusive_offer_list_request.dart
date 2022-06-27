/*PercentTo:01
PercentFrom:10
CompanyId:4094*/

class ExclusiveOfferListRequest {
  String PercentTo;
  String PercentFrom;
  String CompanyId;

  ExclusiveOfferListRequest({this.PercentTo,this.PercentFrom,this.CompanyId});

  ExclusiveOfferListRequest.fromJson(Map<String, dynamic> json) {
    PercentTo = json['PercentTo'];
    PercentFrom = json['PercentFrom'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PercentTo'] = this.PercentTo;
    data['PercentFrom'] = this.PercentFrom;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}