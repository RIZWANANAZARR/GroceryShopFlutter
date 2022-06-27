class ProductGroupSaveResponse {
  List<ProductGroupSaveDetails> details;
  int totalCount;

  ProductGroupSaveResponse({this.details, this.totalCount});

  ProductGroupSaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductGroupSaveDetails.fromJson(v));
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

class ProductGroupSaveDetails {
  int column1;
  String column2;
  int column3;

  ProductGroupSaveDetails({this.column1, this.column2, this.column3});

  ProductGroupSaveDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'] == null ? 0 : json['Column1'];
    column2 = json['Column2'] == null ? "" : json['Column2'];
    column3 = json['Column3'] == null ? 0 : json['Column3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    data['Column2'] = this.column2;
    data['Column3'] = this.column3;

    return data;
  }
}
