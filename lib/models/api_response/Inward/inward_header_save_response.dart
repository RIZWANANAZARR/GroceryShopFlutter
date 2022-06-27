class InwardHeaderSaveResponse {
  List<InwardHeaderSaveResponseDetails> details;
  int totalCount;

  InwardHeaderSaveResponse({this.details, this.totalCount});

  InwardHeaderSaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new InwardHeaderSaveResponseDetails.fromJson(v));
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

class InwardHeaderSaveResponseDetails {
  int column1;
  String column2;
  String column3;
  int column4;

  InwardHeaderSaveResponseDetails(
      {this.column1, this.column2, this.column3, this.column4});

  InwardHeaderSaveResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
    column2 = json['Column2'];
    column3 = json['Column3'];
    column4 = json['Column4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    data['Column2'] = this.column2;
    data['Column3'] = this.column3;
    data['Column4'] = this.column4;

    return data;
  }
}
