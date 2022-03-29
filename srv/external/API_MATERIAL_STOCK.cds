/* checksum : bddd0b13d1468de86059591d94c5034b */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service API_MATERIAL_STOCK {};

@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Material Master'
entity API_MATERIAL_STOCK.A_MaterialStock {

  /**
   * Alphanumeric key uniquely identifying the material.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Material'
  @sap.quickinfo : 'Material Number'
  key Material : String(40);

  /**
   * Unit of measure in which stocks of the material are managed. The system converts all the quantities you enter in other units of measure (alternative units of measure) to the base unit of measure.
   * 
   * You define the base unit of measure and also alternative units of measure and their conversion factors in the material master record.Since all data is updated in the base unit of measure, your entry is particularly important for the conversion of alternative units of measure. A quantity in the alternative unit of measure can only be shown precisely if its value can be shown with the decimal places available. To ensure this, please note the following:The base unit of measure is the unit satisfying the highest necessary requirement for precision.The conversion of alternative units of measure to the base unit should result in simple decimal fractions (not, for example, 1/3 = 0.333...).Inventory ManagementIn Inventory Management, the base unit of measure is the same as the stockkeeping unit.ServicesServices have units of measure of their own, including the following:Service unitUnit of measure at the higher item level. The precise quantities of the individual services are each at the detailed service line level.BlanketUnit of measure at service line level for services to be provided once only, and for which no precise quantities can or are to be specified.
   */
  @sap.label : 'Base Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  MaterialBaseUnit : String(3);
  @cds.ambiguous : 'missing on condition?'
  to_MatlStkInAcctMod : Association to many API_MATERIAL_STOCK.A_MatlStkInAcctMod {  };
};

@cds.persistence.skip : true
@sap.creatable : 'false'
@sap.updatable : 'false'
@sap.deletable : 'false'
@sap.content.version : '1'
@sap.label : 'Material Stock'
entity API_MATERIAL_STOCK.A_MatlStkInAcctMod {

  /**
   * Material in respect of which the stock is managed.
   * 
   * For inventory management on a material-exact basis, this material is the same as the actual material. In the case of value-based inventory management, this material can differ from the actual material.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Stock Material'
  @sap.quickinfo : 'Material in Respect of Which Stock is Managed'
  key Material : String(40);

  /**
   * Key uniquely identifying a plant.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Plant'
  key Plant : String(4);

  /**
   * Number of the storage location in which the material is stored. A plant may contain one or more storage locations.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Storage Location'
  key StorageLocation : String(4);

  /**
   * Assigns a material that is manufactured in batches or production lots to a specific batch.
   * 
   * NoteThe system determines the stock types on the basis of stock identifiers.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Batch SID'
  @sap.quickinfo : 'Batch Number (Stock Identifier)'
  key Batch : String(10);

  /**
   * Specifies an alphanumeric key that uniquely identifies the supplier in the SAP system.
   * 
   * NoteThe system determines the stock on the basis of stock identifiers.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Supplier SID'
  @sap.quickinfo : 'Supplier for Special Stock'
  key Supplier : String(10);

  /**
   * Gives an alphanumeric key, which clearly identifies the customer or supplier in the SAP system.
   * 
   * NoteThe system determines the stock on the basis of stock identifiers.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Customer SID'
  @sap.quickinfo : 'Customer for Special Stock'
  key Customer : String(10);

  /**
   * Key that identifies the WBS element that is assigned to a sales order stock
   */
  @sap.display.format : 'NonNegative'
  @sap.label : 'WBS Element'
  @sap.quickinfo : 'Valuated Sales Order Stock WBS Element'
  key WBSElementInternalID : String(24);

  /**
   * Uniquely identifies a sales order.
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Sales Order'
  @sap.quickinfo : 'Sales Order Number of Valuated Sales Order Stock'
  key SDDocument : String(10);

  /**
   * Uniquely identifies an item in a sales order.
   */
  @sap.display.format : 'NonNegative'
  @sap.label : 'Sales order item'
  @sap.quickinfo : 'Sales Order Item of Valuated Sales Order Stock'
  key SDDocumentItem : String(6);
  @sap.display.format : 'UpperCase'
  @sap.label : 'Special Stock Type'
  key InventorySpecialStockType : String(1);

  /**
   * Unique stock type that identifies the purpose of the stock.
   * 
   * NoteThe system determines the stock on the basis of stock identifiers.The following keys are possible for this field:01: Unrestricted-Use Stock02: Stock in Quality Inspection03: Returns04: Stock Transfer (Storage Location)05: Stock Transfer (Plant)06: Stock in Transit07: Blocked Stock08: Restricted-Use Stock09: Tied Empties10: Valuated Goods Receipt Blocked Stock
   */
  @sap.display.format : 'UpperCase'
  @sap.label : 'Stock Type'
  @sap.quickinfo : 'Stock Type of Goods Movement (Stock Identifier)'
  key InventoryStockType : String(2);

  /**
   * Unit of measure in which stocks of the material are managed. The system converts all the quantities you enter in other units of measure (alternative units of measure) to the base unit of measure.
   * 
   * You define the base unit of measure and also alternative units of measure and their conversion factors in the material master record.Since all data is updated in the base unit of measure, your entry is particularly important for the conversion of alternative units of measure. A quantity in the alternative unit of measure can only be shown precisely if its value can be shown with the decimal places available. To ensure this, please note the following:The base unit of measure is the unit satisfying the highest necessary requirement for precision.The conversion of alternative units of measure to the base unit should result in simple decimal fractions (not, for example, 1/3 = 0.333...).Inventory ManagementIn Inventory Management, the base unit of measure is the same as the stockkeeping unit.ServicesServices have units of measure of their own, including the following:Service unitUnit of measure at the higher item level. The precise quantities of the individual services are each at the detailed service line level.BlanketUnit of measure at service line level for services to be provided once only, and for which no precise quantities can or are to be specified.
   */
  @sap.label : 'Base Unit of Measure'
  @sap.semantics : 'unit-of-measure'
  MaterialBaseUnit : String(3);
  @sap.unit : 'MaterialBaseUnit'
  MatlWrhsStkQtyInMatlBaseUnit : Decimal(31, 14);
  @cds.ambiguous : 'missing on condition?'
  to_MaterialStock : Association to API_MATERIAL_STOCK.A_MaterialStock {  };
};

