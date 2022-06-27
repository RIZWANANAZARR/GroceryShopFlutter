class TokenListResponse {
  List<TokenListResponseDetails> details;
  int totalCount;

  TokenListResponse({this.details, this.totalCount});

  TokenListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new TokenListResponseDetails.fromJson(v));
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

class TokenListResponseDetails {
  int pkID;
  int customerID;
  String customerName;
  String deviceID;
  String tokenNo;
  String createdBy;
  String createdDate;

  TokenListResponseDetails(
      {this.pkID,
      this.customerID,
      this.customerName,
      this.deviceID,
      this.tokenNo,
      this.createdBy,
      this.createdDate});

  TokenListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    deviceID = json['DeviceID'];
    tokenNo = json['TokenNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['DeviceID'] = this.deviceID;
    data['TokenNo'] = this.tokenNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
