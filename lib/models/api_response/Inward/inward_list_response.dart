class InwardListResponse {
  List<InwardListResponseDetails> details;
  int totalCount;

  InwardListResponse({this.details, this.totalCount});

  InwardListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new InwardListResponseDetails.fromJson(v));
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

class InwardListResponseDetails {
  int rowNum;
  int pkID;
  String inwardNo;
  String inwardDate;
  int customerID;
  String customerName;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String createdEmployeeName;
  String updatedEmployeeName;

  InwardListResponseDetails(
      {this.rowNum,
        this.pkID,
        this.inwardNo,
        this.inwardDate,
        this.customerID,
        this.customerName,
        this.createdBy,
        this.createdDate,
        this.updatedBy,
        this.updatedDate,
        this.createdEmployeeName,
        this.updatedEmployeeName});

  InwardListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum']==null?0:json['RowNum'];
    pkID = json['pkID']==null?0:json['pkID'];
    inwardNo = json['InwardNo']==null?"":json['InwardNo'];
    inwardDate = json['InwardDate']==null?"":json['InwardDate'];
    customerID = json['CustomerID']==null?0:json['CustomerID'];
    customerName = json['CustomerName']==null?"":json['CustomerName'];
    createdBy = json['CreatedBy']==null?"":json['CreatedBy'];
    createdDate = json['CreatedDate']==null?"":json['CreatedDate'];
    updatedBy = json['UpdatedBy']==null?"":json['UpdatedBy'];
    updatedDate = json['UpdatedDate']==null?"":json['UpdatedDate'];
    createdEmployeeName = json['CreatedEmployeeName']==null?"":json['CreatedEmployeeName'];
    updatedEmployeeName = json['UpdatedEmployeeName']==null?"":json['UpdatedEmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InwardNo'] = this.inwardNo;
    data['InwardDate'] = this.inwardDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    return data;
  }
}