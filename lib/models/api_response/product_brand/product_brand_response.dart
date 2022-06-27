class ProductBrandResponse {
  List<ProductBrandDetails> details;
  int totalCount;

  ProductBrandResponse({this.details, this.totalCount});

  ProductBrandResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductBrandDetails.fromJson(v));
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

class ProductBrandDetails {
  int rowNum;
  int pkID;
  String brandName;
  String brandAlias;
  String brandImage;
  bool activeFlag;
  String activeFlagDesc;

  ProductBrandDetails(
      {this.rowNum,
      this.pkID,
      this.brandName,
      this.brandAlias,
      this.brandImage,
      this.activeFlag,
      this.activeFlagDesc});

  ProductBrandDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    brandName = json['BrandName'] == null ? "" : json['BrandName'];
    brandAlias = json['BrandAlias'] == null ? "" : json['BrandAlias'];
    brandImage = json['BrandImage'] == null ? "" : json['BrandImage'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    activeFlagDesc =
        json['ActiveFlagDesc'] == null ? "" : json['ActiveFlagDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['BrandName'] = this.brandName;
    data['BrandAlias'] = this.brandAlias;
    data['BrandImage'] = this.brandImage;
    data['ActiveFlag'] = this.activeFlag;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    return data;
  }
}
