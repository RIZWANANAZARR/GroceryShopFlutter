class ProductPaginationDeleteRequest {

  String CompanyId;


  ProductPaginationDeleteRequest({this.CompanyId});

  ProductPaginationDeleteRequest.fromJson(Map<String, dynamic> json) {

    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}

