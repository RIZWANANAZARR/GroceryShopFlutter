class BrandImageDeleteResponse {
  List<BrandImageDeleteResponseDetails> details;
  int totalCount;

  BrandImageDeleteResponse({this.details, this.totalCount});

  BrandImageDeleteResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new BrandImageDeleteResponseDetails.fromJson(v));
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

class BrandImageDeleteResponseDetails {
  String column1;

  BrandImageDeleteResponseDetails({this.column1});

  BrandImageDeleteResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
