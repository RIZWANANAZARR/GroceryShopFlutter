class GroupUploadImageRequest {
  String pkID;
  String FileName;
  String LoginUserID;
  String CompanyId;

  GroupUploadImageRequest(
      {this.pkID, this.FileName, this.LoginUserID, this.CompanyId});

  GroupUploadImageRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    FileName = json['FileName'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['pkID'] = this.pkID;
    data['FileName'] = this.FileName;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
