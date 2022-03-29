using {PRODUCT_0001 as APIProduct} from '../srv/external/PRODUCT_0001.csn';

namespace db;

entity Product as projection on APIProduct.Product {
    key Product,
        CrossPlantStatus,
        BaseUnit,
        NetWeight
}

entity ProductPlant as projection on APIProduct.ProductPlant {
    key Product,
    key Plant,
        ProfileCode
}
