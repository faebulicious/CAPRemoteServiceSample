using {API_BUSINESS_PARTNER as APICloud} from '../srv/external/API_BUSINESS_PARTNER';
using {OP_API_BUSINESS_PARTNER_SRV as APIOnPrem} from '../srv/external/OP_API_BUSINESS_PARTNER_SRV';

namespace db;

entity BusinessPartnerCloud as projection on APICloud.A_BusinessPartner {
    key BusinessPartner as ID, BusinessPartnerFullName as fullName, BusinessPartnerIsBlocked as isBlocked
}

entity BusinessPartnerOnPrem as projection on APIOnPrem.A_BusinessPartner {
    key BusinessPartner as ID, BusinessPartnerFullName as fullName, BusinessPartnerIsBlocked as isBlocked
}
