class CompanyDetailsApiRequest {
  String serialKey;

  CompanyDetailsApiRequest({this.serialKey});

  CompanyDetailsApiRequest.fromJson(Map<String, dynamic> json) {
    serialKey = json['SerialKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SerialKey'] = this.serialKey;
    return data;
  }
}