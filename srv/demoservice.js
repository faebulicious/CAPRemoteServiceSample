class DemoService extends cds.ApplicationService {
  async init() {

    const ProductAPI = await cds.connect.to('PRODUCT_0001');
    const StockAPI = await cds.connect.to('API_MATERIAL_STOCK');

    const { Product, ProductDescription, ProductData, ProductStock } = this.entities;

    this.on("READ", [Product, ProductDescription], (req) => {
      return ProductAPI.run(req.query);
    });

    this.on("READ", ProductData, async (req) => {


      const sLanguage = this.getLanguage(req.query.SELECT) || 'DE';
      console.log(sLanguage);

      console.log(Product);

      // if (!this.hasLanguage(req.query.SELECT)) {
        // if (!req.query.SELECT.where) {
        //   req.query.SELECT.where = [];
        // }
        // req.query.SELECT.where.push(
        //   {
        //     ref: [
        //       '_Product',
        //       {
        //         id: '_ProductDescription',
        //         where: [
        //           {
        //             ref: ['Language']
        //           },
        //           '=',
        //           {
        //             val: 'DE'
        //           }
        //         ]
        //       }
        //     ]
        //   }
        // )
      // }

      const aProducts = await ProductAPI.run(req.query);

      aProducts.forEach(oProduct => {
        const oDesc = oProduct._Product?._ProductDescription?.find(oDesc => oDesc.Language === sLanguage);
        if (oDesc) {
          oProduct.Description = oDesc.Description;
        } else {
          oProduct.Description = '';
        }
      });

      const aProductIDs = aProducts.map(oProduct => oProduct.Product);

      const aStock = await StockAPI.run(SELECT.from(ProductStock).where({ Product: aProductIDs }));

      return aProducts;
    });

    this.on("READ", ProductStock, (req) => {
       StockAPI.run(req.query);
    });

    await super.init();
  }

  getLanguage(oQuery) {
    let sLanguage;
    
    oQuery.where?.forEach(oWhere => {
      oWhere.ref?.forEach(oRef => {
        if (oRef.id === '_ProductDescription') {
          let isLanguage = false;
          oRef.where.forEach(oDescWhere => {
            if (oDescWhere.ref && oDescWhere.ref[0] === 'Language') {
              isLanguage = true;
            }
            if (isLanguage && oDescWhere.val) {
              sLanguage = oDescWhere.val;
            }
          });
        }
      });
    });
    return sLanguage;
  }
}
module.exports = { DemoService };