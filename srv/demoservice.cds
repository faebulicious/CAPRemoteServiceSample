using {PRODUCT_0001 as APIProduct} from './external/PRODUCT_0001.csn';
using {API_MATERIAL_STOCK as APIStock} from './external/API_MATERIAL_STOCK';

@path: '/demo'
@impl: './demoservice.js'
service DemoService {
  entity Product as projection on APIProduct.Product {
    key Product,
        @Common.Label: 'BeGru'
        AuthorizationGroup,
        @Common.Label: 'Basis-ME'
        BaseUnit,
        _ProductDescription, //: redirected to ProductDescription
  };

  entity ProductDescription as projection on APIProduct.ProductDescription {
    key Product,
    @cds.
    key Language,
        @Common.Label: 'Beschreibung'
        ProductDescription as Description
  };

  entity ProductData as projection on APIProduct.ProductPlant {
    key Product,
    key Plant,
        ProfileCode,
        _Product,
        ' ' as Description: String(60),
  };

  entity ProductStock as projection on APIStock.A_MatlStkInAcctMod {
    key Material as Product,
    key Plant,
        MaterialBaseUnit,
        MatlWrhsStkQtyInMatlBaseUnit
  }
}

annotate DemoService.ProductData with @(
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
            Value: Description
        },
        {
            Value: _Product._ProductDescription.Description
        }
    ],
  }
);
