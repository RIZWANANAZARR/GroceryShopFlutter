class ProductPaginationRequest {
  String SearchKey;
  String CompanyId;
  String ActiveFlag;

  ProductPaginationRequest({this.SearchKey, this.CompanyId, this.ActiveFlag});

  ProductPaginationRequest.fromJson(Map<String, dynamic> json) {
    SearchKey = json['SearchKey'];
    CompanyId = json['CompanyId'];
    ActiveFlag = json['ActiveFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyId;
    data['ActiveFlag'] = this.ActiveFlag;
    return data;
  }
}
