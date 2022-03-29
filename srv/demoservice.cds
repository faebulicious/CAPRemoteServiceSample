using {PRODUCT_0001 as APIProduct} from './external/PRODUCT_0001.csn';
using {API_MATERIAL_STOCK as APIStock} from './external/API_MATERIAL_STOCK';

@path: '/demo'
@impl: './demoservice.js'
service DemoService {
  // entity Product as projection on APIProduct.Product {
  //   *
  // };

  // entity ProductDescription as projection on APIProduct.ProductDescription {
  //   *
  // };

  // entity ProductPlant as projection on APIProduct.ProductPlant {
  //   *
  // };

  entity ProductData {
    key Product : String(40);
    key Plant : String(4);
        ProductType : String(4);
        ProfileCode : String(2);
        ProductSalesOrg: String(4);
        Description: String(60);
        Price : Decimal(23,2);
        Stock : Integer;
  };
}

annotate DemoService.ProductData with @(
  // UI: {
  //   SelectionFields: [
  //       Product,
  //       _Product.BaseUnit,
  //       _Product._ProductDescription.Language
  //   ],
  //   LineItem: [
  //       {
  //           Value: Product
  //       },
  //       {
  //           Value: Plant
  //       },
  //       {
  //           Value: _Product.BaseUnit
  //       },
  //       {
  //           Value: Description
  //       },
  //       {
  //           Value: _Product._ProductDescription.Description
  //       }
  //   ],
  // }
);
