class CompanyDetailsResponse {


  List<CompanyProfile> details;
  int totalCount;

  CompanyDetailsResponse({this.details, this.totalCount});

  CompanyDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CompanyProfile.fromJson(v));
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

class CompanyProfile {
  int pkId;
  String companyName;
  String siteURL;
  String expiryDate;
  String mobileAppVersion;
  int portNo;
  int iSAMC;

  CompanyProfile(
      {
        this.pkId,
        this.companyName,
        this.siteURL,
        this.expiryDate,
        this.mobileAppVersion,
        this.portNo,
        this.iSAMC
      });

  CompanyProfile.fromJson(Map<String, dynamic> json) {
    pkId = json['pkId'];
    companyName = json['CompanyName'];
    siteURL = json['SiteURL'];
    expiryDate = json['ExpiryDate'];
    mobileAppVersion = json['MobileAppVersion'];
    portNo = json['PortNo'];
    iSAMC = json['ISAMC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkId'] = this.pkId;
    data['CompanyName'] = this.companyName;
    data['SiteURL'] = this.siteURL;
    data['ExpiryDate'] = this.expiryDate;
    data['MobileAppVersion'] = this.mobileAppVersion;
    data['PortNo'] = this.portNo;
    data['ISAMC'] = this.iSAMC;
    return data;
  }
}