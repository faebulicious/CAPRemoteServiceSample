class DemoService extends cds.ApplicationService {
  async init() {

    const BusinessPartnerCloud = await cds.connect.to('API_BUSINESS_PARTNER');
    const BusinessPartnerOnPrem = await cds.connect.to('OP_API_BUSINESS_PARTNER_SRV');

    this.on("READ", "BusinessPartnerCloud", async (req) => {
      return BusinessPartnerCloud.run(req.query);
    });

    this.on("READ", "BusinessPartnerOnPrem", async (req) => {
      return BusinessPartnerOnPrem.run(req.query);
    });

    await super.init();
  }
}
module.exports = { DemoService, RestDemoService: DemoService };