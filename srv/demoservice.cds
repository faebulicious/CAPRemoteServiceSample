using {PRODUCT_0001 as APIProduct} from './external/PRODUCT_0001.csn';

@path: '/demo'
service DemoService {
  entity Product as projection on APIProduct.Product {
    *
  };

  entity ProductDescription as projection on APIProduct.ProductDescription {
    *
  };

  entity ProductPlant as projection on APIProduct.ProductPlant {
    *
  };

  entity ProductData {
    key Product : String(40);
    key Plant : String(4);
        ProductSalesOrg : String(4);
        ProductType : String(4);
        ProfileCode : String(2);
        Description: String(60);
        Stock : Integer;
  };
}

annotate DemoService.ProductPlant with @(
  UI: {
    SelectionFields: [
        Product,
        _Product.BaseUnit,
        _Product._ProductDescription.Language
    ],
    LineItem: [
        {
            Value: Product
        },
        {
            Value: Plant
        },
        {
            Value: _Product.BaseUnit
        },
        {
            Value: _Product._ProductDescription.Description
        }
    ],
  }
);
