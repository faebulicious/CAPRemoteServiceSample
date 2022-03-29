class DemoService extends cds.ApplicationService {
  async init() {

    const ProductAPI = await cds.connect.to('PRODUCT_0001');
    const StockAPI = await cds.connect.to('API_MATERIAL_STOCK');

    const { ProductPlant } = ProductAPI.entities;
    const { A_MatlStkInAcctMod : ProductStock } = StockAPI.entities;
    const { ProductData } = this.entities;

    this.on("READ", ProductData, async (req) => {

      // Build Query including Multi-Level Associations:
      // ProductPlant --> Product --> Product Description
      // ProductPlant --> Product --> Product Sales Delivery
      const oQuery = SELECT.from(ProductPlant, p => {
        p.Product, p.Plant, p.ProfileCode, p._Product (x => {
          // Works not due to a CDS BUG!
          //x.ProductType, x._ProductDescription[Language='DE'] (d => { // Limit to Language DE
          //x.ProductType, x._ProductDescription[1: Language='DE'] (d => { // Reduce cardinality to one
          x.ProductType, x._ProductDescription (d => {
            d.ProductDescription
          }),
          x._ProductSalesDelivery (s => {
            s.ProductSalesOrg, s.ProductDistributionChnl
          }) 
        })
      // }).where({Product: 'D20_EPDM_SMRT_S'}); // Stock material example
      }).limit(100);

      const aProducts = await ProductAPI.tx(req).run(oQuery);

      // Create new Array with Product IDs only
      const aID = aProducts.map(oData => oData.Product);

      // Fetch Stock for Products
      const aStock = await StockAPI.tx(req).run(SELECT.from(ProductStock).columns(`Material as Product`,`Plant`,`MaterialBaseUnit as BaseUnit`, `MatlWrhsStkQtyInMatlBaseUnit as Stock`).where({Material: aID}));

      // Create a result map for aggregation of multiple stocks
      // and faster Access to the result
      const mStock = new Map();
      aStock.forEach((oStock) => {
        const sStockKey = this.getStockKey(oStock);
        let iStock = mStock.get(sStockKey) || 0;
        mStock.set(sStockKey, iStock + oStock.Stock);
      });

      // Flatten association to entity structure, add stock and
      // remove association structure
      return aProducts.map(oData => {
        oData.ProductType = oData._Product?.ProductType || '';
        oData.Description = oData._Product?._ProductDescription?.[0]?.ProductDescription || '';
        oData.ProductSalesOrg = oData._Product?._ProductSalesDelivery?.[0]?.ProductSalesOrg || '';

        oData.Stock = mStock.get(this.getStockKey(oData)) || 0;

        delete oData._Product;
        return oData;
      });
    });

    await super.init();
  }

  getStockKey(oData) {
    return `${oData.Product} ${oData.Plant}`;
  }
}
module.exports = { DemoService };