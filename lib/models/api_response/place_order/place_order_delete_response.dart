class PlaceOrderDeleteResponse {
  List<PlaceOrderDeleteResponseDetails> details;
  int totalCount;

  PlaceOrderDeleteResponse({this.details, this.totalCount});

  PlaceOrderDeleteResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PlaceOrderDeleteResponseDetails.fromJson(v));
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

class PlaceOrderDeleteResponseDetails {
  String column1;

  PlaceOrderDeleteResponseDetails({this.column1});

  PlaceOrderDeleteResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
