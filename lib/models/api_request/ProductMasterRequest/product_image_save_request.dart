/*CompanyId:4135
LoginUserId:admin
pkID:40135
fileName:1526648287301.jpg*/

class ProductImageSaveRequest {
  String CompanyId;
  String LoginUserId;
  String ProductID;
  String fileName;

  ProductImageSaveRequest(
      {this.CompanyId, this.LoginUserId, this.ProductID, this.fileName});

  ProductImageSaveRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserId = json['LoginUserId'];
    ProductID = json['ProductID'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserId'] = this.LoginUserId;
    data['ProductID'] = this.ProductID;
    data['fileName'] = this.fileName;

    return data;
  }
}
