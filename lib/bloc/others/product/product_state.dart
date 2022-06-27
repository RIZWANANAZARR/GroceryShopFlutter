part of 'product_bloc.dart';

abstract class ProductStates extends BaseStates {
  const ProductStates();
}

///all states of AuthenticationStates

class ProductGroupInitialState extends ProductStates {}

class ProductGroupResponseState extends ProductStates {
  ProductGroupListResponse response;

  ProductGroupResponseState(this.response);
}

class ProductGroupSearchResponseState extends ProductStates {
  ProductGroupListResponse response;

  ProductGroupSearchResponseState(this.response);
}

class ProductGroupSaveResponseState extends ProductStates {
  ProductGroupSaveResponse response;

  ProductGroupSaveResponseState(this.response);
}

class ProductMasterSaveResponseState extends ProductStates {
  ProductMasterSaveResponse response;

  ProductMasterSaveResponseState(this.response);
}

class ProductMasterPaginationResponseState extends ProductStates {
  final int newpage;
  ProductPaginationResponse response;

  ProductMasterPaginationResponseState(this.newpage, this.response);
}

class ProductMasterPaginationSearchResponseState extends ProductStates {
  final int newpage;
  ProductPaginationResponse response;

  ProductMasterPaginationSearchResponseState(this.newpage, this.response);
}

class ProductMasterDeleteResponseState extends ProductStates {
  ProductMasterDeleteResponse response;

  ProductMasterDeleteResponseState(this.response);
}

class ProductBrandResponseState extends ProductStates {
  ProductBrandResponse response;

  ProductBrandResponseState(this.response);
}

class ProductBrandSaveResponseState extends ProductStates {
  ProductBrandSaveResponse response;

  ProductBrandSaveResponseState(this.response);
}

class ProductBrandDeleteResponseState extends ProductStates {
  ProductBrandDeleteResponse response;

  ProductBrandDeleteResponseState(this.response);
}

class ProductBrandSearchResponseState extends ProductStates {
  ProductBrandResponse response;

  ProductBrandSearchResponseState(this.response);
}

class ProductBrandSearchMainResponseState extends ProductStates {
  ProductBrandSearchResponse response;

  ProductBrandSearchMainResponseState(this.response);
}

class ProductGroupDeleteResponseState extends ProductStates {
  ProductGroupDeleteResponse response;

  ProductGroupDeleteResponseState(this.response);
}

class ProductImageSaveResponseState extends ProductStates {
  ProductImageSaveResponse response;
  String headerMsg;
  ProductImageSaveResponseState(this.response, this.headerMsg);
}

class ProductImageDeleteResponseState extends ProductStates {
  ProductImageDeleteResponse response;

  ProductImageDeleteResponseState(this.response);
}

class BrandImageUploadResponseState extends ProductStates {
  BrandImageUploadResponse response;
  String headerMsg;
  BrandImageUploadResponseState(this.response, this.headerMsg);
}

class BrandImageDeleteResponseState extends ProductStates {
  BrandImageDeleteResponse response;

  BrandImageDeleteResponseState(this.response);
}

class GroupImageUploadResponseState extends ProductStates {
  GroupImageUploadResponse response;
  String headerMsg;
  GroupImageUploadResponseState(this.response, this.headerMsg);
}

class GroupImageDeleteResponseState extends ProductStates {
  GroupImageDeleteResponse response;

  GroupImageDeleteResponseState(this.response);
}

class CategoryListResponseState extends ProductStates {
  CategoryListResponse response;

  CategoryListResponseState(this.response);
}

class TabProductGroupListResponseState extends ProductStates {
  TabProductGroupListResponse response;

  TabProductGroupListResponseState(this.response);
}

class ProductGroupDropDownResponseState extends ProductStates {
  ProductGroupDropDownResponse response;

  ProductGroupDropDownResponseState(this.response);
}
