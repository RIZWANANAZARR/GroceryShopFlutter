class ProfileListResponse {
  List<ProfileListResponseDetails> details;
  int totalCount;

  ProfileListResponse({this.details, this.totalCount});

  ProfileListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProfileListResponseDetails.fromJson(v));
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

class ProfileListResponseDetails {
  int rowNum;
  int customerID;
  String customerName;
  String address;
  String contactNo;
  String customerType;
  String emailAddress;
  bool blockCustomer;
  String password;
  String profileImage;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;

  ProfileListResponseDetails(
      {this.rowNum,
        this.customerID,
        this.customerName,
        this.address,
        this.contactNo,
        this.customerType,
        this.emailAddress,
        this.blockCustomer,
        this.password,
        this.profileImage,
        this.createdBy,
        this.createdDate,
        this.updatedBy,
        this.updatedDate});

  ProfileListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    address = json['Address'];
    contactNo = json['ContactNo'];
    customerType = json['customerType'];
    emailAddress = json['EmailAddress'];
    blockCustomer = json['BlockCustomer'];
    password = json['Password'];
    profileImage = json['ProfileImage'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['Address'] = this.address;
    data['ContactNo'] = this.contactNo;
    data['customerType'] = this.customerType;
    data['EmailAddress'] = this.emailAddress;
    data['BlockCustomer'] = this.blockCustomer;
    data['Password'] = this.password;
    data['ProfileImage'] = this.profileImage;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}



