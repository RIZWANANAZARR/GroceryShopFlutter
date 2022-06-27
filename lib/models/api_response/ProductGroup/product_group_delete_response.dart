class ProductGroupDeleteResponse {
  List<ProductGroupDeleteDetails> details;
  int totalCount;

  ProductGroupDeleteResponse({this.details, this.totalCount});

  ProductGroupDeleteResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductGroupDeleteDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class ProductGroupDeleteDetails {
  String column1;

  ProductGroupDeleteDetails({this.column1});

  ProductGroupDeleteDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1']==null?"":json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}