class DemoService extends cds.ApplicationService {
  async init() {
    const ProductAPI = await cds.connect.to("PRODUCT_0001");
    const StockAPI = await cds.connect.to("API_MATERIAL_STOCK");

    const { ProductPlant } = ProductAPI.entities;
    const { A_MatlStkInAcctMod: ProductStock } = StockAPI.entities;
    const { ProductData, ProductPlant: ProductDataSrv } = this.entities;

    this.oCurrentRequest = undefined;

    this.on("READ", ProductDataSrv, (req) => {
      console.log(req.query.SELECT);
      return ProductAPI.run(req.query);
    });

    this.on("READ", ProductData, async (req) => {
      this.oCurrentRequest = req.query.SELECT;

      console.log(this.oCurrentRequest);

      // Build Query including Multi-Level Associations:
      // ProductPlant --> Product --> Product Description
      // ProductPlant --> Product --> Product Sales Delivery

      const aColumns = [];
      aColumns.push({ ref: "Product" }); // Key Field
      aColumns.push({ ref: "Plant" }); // Key Field
      if (this.isColumnRequest("ProfileCode")) {
        aColumns.push({ ref: "ProfileCode" });
      }
      if (
        this.isColumnRequest("ProductSalesOrg") ||
        this.isColumnRequest("ProductType") ||
        this.isColumnRequest("Description")
      ) {
        const oProduct = {
          ref: ["_Product"],
          expand: [],
        };
        aColumns.push(oProduct);

        if (this.isColumnRequest("ProductType")) {
          oProduct.expand.push({ ref: "ProductType" });
        }

        if (this.isColumnRequest("Description")) {
          oProduct.expand.push({
            ref: ["_ProductDescription"],
            expand: [
              {
                ref: ["ProductDescription"],
              },
            ],
          });
        }

        if (this.isColumnRequest("ProductSalesOrg")) {
          oProduct.expand.push({
            ref: ["_ProductSalesDelivery"],
            expand: [
              {
                ref: ["ProductSalesOrg"],
              },
            ],
          });
        }
      }

      console.log(aColumns);

      const oQuery = SELECT.from(ProductPlant)
        .columns(aColumns)
        .where(
          `exists _Product._ProductSalesDelivery[ProductSalesOrg='DE10'] AND _Product.ProductType='SERV'`
        )
        .limit(this.oCurrentRequest.limit || 100);

      // Query using arrow function for projections
      // const oQuery = SELECT.from(ProductPlant, (p) => {
      //   p.Product,
      //     p.Plant,
      //     p.ProfileCode,
      //     p._Product((x) => {
      //       // Works not due to a CDS BUG!
      //       //x.ProductType, x._ProductDescription[Language='DE'] (d => { // Limit to Language DE
      //       //x.ProductType, x._ProductDescription[1: Language='DE'] (d => { // Reduce cardinality to one
      //       x.ProductType,
      //         x._ProductDescription((d) => {
      //           d.ProductDescription;
      //         }),
      //         x._ProductSalesDelivery((s) => {
      //           s.ProductSalesOrg, s.ProductDistributionChnl;
      //         });
      //     });
      // })
      //   .where(
      //     `exists _Product._ProductSalesDelivery[ProductSalesOrg='DE10'] AND _Product.ProductType='SERV'`
      //   )
      //   .limit(this.oCurrentRequest.limit || 100);

      const aProducts = await ProductAPI.tx(req).run(oQuery);

      // Create new Array with Product IDs only
      const aID = aProducts.map((oData) => oData.Product);

      // Fetch Stock for Products
      const aStock = await StockAPI.tx(req).run(
        SELECT.from(ProductStock)
          .columns(
            `Material as Product`,
            `Plant`,
            `MaterialBaseUnit as BaseUnit`,
            `MatlWrhsStkQtyInMatlBaseUnit as Stock`
          )
          .where({ Material: aID })
      );

      // Create a result map for aggregation of multiple stocks
      // and faster Access to the result

      const mStock = new Map();
      if (this.isColumnRequest("Stock")) {
        aStock.forEach((oStock) => {
          const sStockKey = this.getStockKey(oStock);
          let iStock = mStock.get(sStockKey) || 0;
          mStock.set(sStockKey, iStock + oStock.Stock);
        });
      }

      // Flatten association to entity structure, add stock and
      // remove association structure
      const aData = aProducts.map((oData) => {
        if (this.isColumnRequest("ProductType"))
          oData.ProductType = oData._Product?.ProductType || "";
        if (this.isColumnRequest("Description"))
          oData.Description =
            oData._Product?._ProductDescription?.[0]?.ProductDescription || "";
        if (this.isColumnRequest("ProductSalesOrg"))
          oData.ProductSalesOrg =
            oData._Product?._ProductSalesDelivery?.[0]?.ProductSalesOrg || "";

        if (this.isColumnRequest("Stock"))
          oData.Stock = mStock.get(this.getStockKey(oData)) || 0;

        delete oData._Product;
        return oData;
      });

      // TODO: Handle Order By

      // Count data if requestes
      if (req.query.SELECT.count) {
        aData["$count"] = aData.length;
      }

      return aData;
    });

    await super.init();
  }

  isColumnRequest(sColName) {
    if (!this.oCurrentRequest.columns) {
      return true;
    }

    if (
      this.oCurrentRequest.columns.some(
        (oColumn) =>
          oColumn === sColName ||
          oColumn.ref === sColName ||
          oColumn.ref[0] === sColName
      )
    ) {
      return true;
    }

    return false;
  }

  x() {
    return this.x, this.y;
  }

  getStockKey(oData) {
    return `${oData.Product} ${oData.Plant}`;
  }
}
module.exports = { DemoService };
