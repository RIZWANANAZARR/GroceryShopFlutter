class LoginUserDetialsResponse {
  List<LoginUserDetails> details;
  int totalCount;

  LoginUserDetialsResponse({this.details, this.totalCount});

  LoginUserDetialsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new LoginUserDetails.fromJson(v));
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

class LoginUserDetails {
  int pkID;
  String userID;
  String userPassword;
  int companyID;
  String companyName;
  String serialKey;
  int stateCode;
  String companyType;
  String screenFullName;
  String roleCode;
  String roleName;
  bool activeFlag;
  String orgCode;
  String orgName;
  int orgTypeCode;
  String orgType;
  int employeeID;
  String employeeName;
  String activeFlagDesc;
  String StateName;
  int CityCode;
  String CityName;


  LoginUserDetails(
      {this.pkID,
      this.userID,
      this.userPassword,
      this.companyID,
      this.companyName,
      this.serialKey,
      this.stateCode,
      this.companyType,
      this.screenFullName,
      this.roleCode,
      this.roleName,
      this.activeFlag,
      this.orgCode,
      this.orgName,
      this.orgTypeCode,
      this.orgType,
      this.employeeID,
      this.employeeName,
      this.activeFlagDesc,
  this.StateName,
  this.CityCode,
  this.CityName});

  LoginUserDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    userID = json['UserID'];
    userPassword = json['UserPassword'];
    companyID = json['CompanyID'];
    companyName = json['CompanyName'];
    serialKey = json['SerialKey'];
    stateCode = json['StateCode'];
    companyType = json['CompanyType'];
    screenFullName = json['ScreenFullName'];
    roleCode = json['RoleCode'];
    roleName = json['RoleName'];
    activeFlag = json['ActiveFlag'];
    orgCode = json['OrgCode'];
    orgName = json['OrgName'];
    orgTypeCode = json['OrgTypeCode'];
    orgType = json['OrgType'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    activeFlagDesc = json['ActiveFlagDesc'];
    StateName = json['StateName'];
    CityCode = json['CityCode'];
    CityName = json['CityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['UserID'] = this.userID;
    data['UserPassword'] = this.userPassword;
    data['CompanyID'] = this.companyID;
    data['CompanyName'] = this.companyName;
    data['SerialKey'] = this.serialKey;
    data['StateCode'] = this.stateCode;
    data['CompanyType'] = this.companyType;
    data['ScreenFullName'] = this.screenFullName;
    data['RoleCode'] = this.roleCode;
    data['RoleName'] = this.roleName;
    data['ActiveFlag'] = this.activeFlag;
    data['OrgCode'] = this.orgCode;
    data['OrgName'] = this.orgName;
    data['OrgTypeCode'] = this.orgTypeCode;
    data['OrgType'] = this.orgType;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    data['StateName'] = this.StateName;
    data['CityCode'] = this.CityCode;
    data['CityName'] = this.CityName;
    return data;
  }
}
