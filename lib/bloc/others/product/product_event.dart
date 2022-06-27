part of 'product_bloc.dart';

@immutable
abstract class ProductGroupEvents {}

///all events of AuthenticationEvents

class ProductGroupCallEvent extends ProductGroupEvents {
  final ProductGroupListRequest request;

  ProductGroupCallEvent(this.request);
}

class ProductGroupSearchCallEvent extends ProductGroupEvents {
  final ProductGroupListRequest request;

  ProductGroupSearchCallEvent(this.request);
}

class ProductGroupSaveCallEvent extends ProductGroupEvents {
  final int id;
  final ProductGroupSaveRequest request;

  ProductGroupSaveCallEvent(this.id, this.request);
}

class ProductMasterSaveCallEvent extends ProductGroupEvents {
  final int id;
  // File imageFile;
  final ProductMasterSaveRequest request;

  ProductMasterSaveCallEvent(this.id, /*this.imageFile,*/ this.request);
}

class ProductMasterPaginationCallEvent extends ProductGroupEvents {
  final int pageno;
  final ProductPaginationRequest request;

  ProductMasterPaginationCallEvent(this.pageno, this.request);
}

class ProductMasterPaginationSearchCallEvent extends ProductGroupEvents {
  final int pageno;
  final ProductPaginationRequest request;

  ProductMasterPaginationSearchCallEvent(this.pageno, this.request);
}

class ProductMasterDeleteCallEvent extends ProductGroupEvents {
  final int id;
  final ProductPaginationDeleteRequest request;

  ProductMasterDeleteCallEvent(this.id, this.request);
}

class ProductBrandCallEvent extends ProductGroupEvents {
  final ProductBrandListRequest request;

  ProductBrandCallEvent(this.request);
}

class ProductBrandSaveCallEvent extends ProductGroupEvents {
  final int id;
  final ProductBrandSaveRequest request;

  ProductBrandSaveCallEvent(this.id, this.request);
}

class ProductBrandDeleteCallEvent extends ProductGroupEvents {
  final int id;
  final ProductBrandDeleteRequest request;

  ProductBrandDeleteCallEvent(this.id, this.request);
}

class ProductBrandSearchCallEvent extends ProductGroupEvents {
  final ProductBrandSearchRequest request;

  ProductBrandSearchCallEvent(this.request);
}

class ProductBrandSearchMainCallEvent extends ProductGroupEvents {
  final ProductBrandSearchRequest request;

  ProductBrandSearchMainCallEvent(this.request);
}

class ProductGroupDeleteCallEvent extends ProductGroupEvents {
  final int id;
  final ProductGroupDeleteRequest request;

  ProductGroupDeleteCallEvent(this.id, this.request);
}

class ProductImageSaveRequestEvent extends ProductGroupEvents {
  File imageFile;
  String headerMsg;
  final ProductImageSaveRequest request;

  ProductImageSaveRequestEvent(this.headerMsg, this.imageFile, this.request);
}

class ProductImageDeleteCallEvent extends ProductGroupEvents {
  final int id;
  final ProductImageDeleteRequest request;

  ProductImageDeleteCallEvent(this.id, this.request);
}

class BrandUploadImageRequestEvent extends ProductGroupEvents {
  File imageFile;
  String headerMsg;
  final BrandUploadImageRequest request;

  BrandUploadImageRequestEvent(this.headerMsg, this.imageFile, this.request);
}

class BrandImageDeleteCallEvent extends ProductGroupEvents {
  final int id;
  final BrandImageDeleteRequest request;

  BrandImageDeleteCallEvent(this.id, this.request);
}

class GroupUploadImageRequestEvent extends ProductGroupEvents {
  File imageFile;
  String headerMsg;
  final GroupUploadImageRequest request;

  GroupUploadImageRequestEvent(this.headerMsg, this.imageFile, this.request);
}

class GroupImageDeleteCallEvent extends ProductGroupEvents {
  final int id;
  final GroupImageDeleteRequest request;

  GroupImageDeleteCallEvent(this.id, this.request);
}

class CategoryListRequestCallEvent extends ProductGroupEvents {
  final CategoryListRequest categoryListRequest;

  CategoryListRequestCallEvent(this.categoryListRequest);
}

class TabProductGroupListCallEvent extends ProductGroupEvents {
  final TabProductGroupListRequest request;

  TabProductGroupListCallEvent(this.request);
}

class ProductGroupDropDownRequestCallEvent extends ProductGroupEvents {
  final ProductGroupDropDownRequest request;

  ProductGroupDropDownRequestCallEvent(this.request);
}
