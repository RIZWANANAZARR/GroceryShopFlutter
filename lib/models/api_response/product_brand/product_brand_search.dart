class ProductBrandSearchResponse {
  List<ProductBrandSearchDetails> details;
  int totalCount;

  ProductBrandSearchResponse({this.details, this.totalCount});

  ProductBrandSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductBrandSearchDetails.fromJson(v));
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

class ProductBrandSearchDetails {
  int rowNum;
  int pkID;
  String brandName;
  String brandAlias;
  String brandImage;
  bool activeFlag;
  String activeFlagDesc;

  ProductBrandSearchDetails(
      {this.rowNum,
        this.pkID,
        this.brandName,
        this.brandAlias,
        this.brandImage,
        this.activeFlag,
        this.activeFlagDesc});

  ProductBrandSearchDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    brandName = json['BrandName'];
    brandAlias = json['BrandAlias'];
    brandImage = json['BrandImage'];
    activeFlag = json['ActiveFlag'];
    activeFlagDesc = json['ActiveFlagDesc'];
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