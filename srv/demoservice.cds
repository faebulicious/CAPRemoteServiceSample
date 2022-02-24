using {db} from '../db/schema';

@path: '/demo'
@impl: './demoservice.js'
service DemoService {
  entity BusinessPartnerCloud as projection on db.BusinessPartnerCloud;
  entity BusinessPartnerOnPrem as projection on db.BusinessPartnerOnPrem;
}

@path: '/restdemo'
@protocol: 'rest'
@impl: './demoservice.js'
service RestDemoService {
  entity BusinessPartnerCloud as projection on db.BusinessPartnerCloud;
  entity BusinessPartnerOnPrem as projection on db.BusinessPartnerOnPrem;
}