# Rapptr File Formats

## Portfolio Data

When uploading company structures and portfolios to Rapptr, we recommend that this is done at once using our CSV portfolio file template. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Portfolios.csv) and a sample file with multiple aggregation structures [here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/PortfoliosMultipleAggregationStructures.csv). For more guidance on how to structure your portfolio file, please refer to this [Help Centre article](https://fundapps.zendesk.com/hc/en-us/articles/210134023-Portfolio-File).

Please see [here](http://docs.fundapps.co/disclosureProperties.html#portfolioProperties) for the portfolio property descriptions 

*PortfolioId* needs to be unique. In the scenario where a PortfolioId is uploaded which already exists in Rapptr, the previous portfolio details associated with that PortfolioId will be overridden, so if any columns are blank (e.g. disclosure form properties, then existing values will be overridden)

## Transaction Data

We accept transaction data in CSV format. You can find a [sample file here](Transactions.csv).

### File Column Detail

Column Name     | Description                          | Data type                                                            | Required 
----------------|--------------------------------------|----------------------------------------------------------------------|---------
PortfolioId     | ID of the portfolio                  | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X 
AssetId         | ID of the asset                      | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X 
TransactionId   | ID of the transaction                | [String(100)](https://github.com/fundapps/api-examples#data-types)   | X 
ExecutionDate   | Date the transaction was executed    | [Date](https://github.com/fundapps/api-examples#data-types)          | X 
TransactionType | See below for possible types         | [String(50)](https://github.com/fundapps/api-examples#data-types)    | X 
Price           | Price transaction was executed at    | [Decimal(28,8)](https://github.com/fundapps/api-examples#data-types) | X 
Quantity        | Quantity purchased/sold              | [Decimal(28,8)](https://github.com/fundapps/api-examples#data-types) | X 
BrokerName      | Broker transaction was executed with | [String(255)](https://github.com/fundapps/api-examples#data-types)   |   

### Recognised Transaction Types

Type            | Description                                                                                 |
----------------|---------------------------------------------------------------------------------------------|
Buy             | A standard purchase / buy transaction                                                       |
Sell            | A standard sale /sell transaction                                                           |
CorporateAction | The issue of bonus shares, stock splits - everything related to actions taken by the issuer |
Expiry          | The expiry of a derivative contract                                                         |
Exercise        | The exercise of an option, future etc.                                                      |
Adjustment      | Internal transfer of Assets                                                                 |
Maturity        | The maturity of a convertible bond, for example                                             |
TakeOn          | Asset resulting from a new account being opened                                             |
Withdrawal      | Asset withdrawn due to an account being closed                                              |

### Data Requirements

- *TransactionId* needs to be unique. In the scenario where a TransactionId is uploaded which already exists in Rapptr, this will result in a validation error.
- *AssetId* and *PortfolioId* values need to match the fields with the same name in Position data; this is key in order to be able to query the correct transactions for disclosure forms.


## Issuer Register Data

We accept issuer register data in CSV format. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Issuer%20Register.csv).

### File Column Detail

Column Name                      | Description                                                                                                         | Data type                                                          | Required  
---------------------------------|---------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------     |---
Id                               | The IssuerId that is currently used in your position file. We recommend using the LEI where available               | [String(255)](https://github.com/fundapps/api-examples#data-types) | X 
LEI                              | The Legal Entity Identifier of the issuer                                                                           | [String(20)](https://github.com/fundapps/api-examples#data-types) |   
LegalName                        | The legal name of the issuer. This field could refer to the IssuerName that is currently used in your position file | [String(255)](https://github.com/fundapps/api-examples#data-types) | X 
Address                          | The issuer's address                                                                                                | [String(255)](https://github.com/fundapps/api-examples#data-types) | X 
City                             | The city the issuer is located                                                                                      | [String(255)](https://github.com/fundapps/api-examples#data-types) | X 
Province                         | The province of the issuer (if any)                                                                                 | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
PostCode                         | The post code of the issuer (if any)                                                                                | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
Country                          | The country the issuer is located                                                                                   | [String(255)](https://github.com/fundapps/api-examples#data-types) | X 
ContactPerson                    | The primary issuer contact                                                                                          | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
ContactPersonPosition            | The primary issuer contact's position                                                                               | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
EmailAddress                     | The primary issuer contact's email address                                                                          | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
DenominatorWebsite               | The URL where the denominator can be found                                                                          | [String(Max)](https://github.com/fundapps/api-examples#data-types) |   
TelephoneNumber                  | The primary issuer contact's telephone number                                                                       | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
AustralianCompanyNumber          | The ACN is a 9 digit number. Under the Corporations Act 2001, every company in Australia has been issued an ACN     | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
AustralianRegisteredSchemeNumber | The ARSN is a 9 digit number issued to Australian managed investment schemes by the ASIC                            | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
SouthAfricanRegistrationNumber   | The South African company registration number                                                                       | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
IssuersRegisterCourt             | German company registration court. For more information consult [Germany's Company Register](https://www.unternehmensregister.de/ureg/search1.2.html?submitaction=language&language=en) | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
RegisterType                     | German company registration type. Possible values could include: Cooperative Register, Commercial Register Excerpt, Commercial Register, Partnership Register. For more information consult [Germany's Company Register](https://www.unternehmensregister.de/ureg/search1.2.html?submitaction=language&language=en) | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
RegisterNumber                   | German company registration number                                                                                  | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
PhilippineSecId                  | The identification number issued by the Securities and Exchange Commission in the Philippines                       | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
PhilippineBirTaxId               | The company tax identification number issued by the Bureau of Internal Revenue (BIR)                                | [String(255)](https://github.com/fundapps/api-examples#data-types) |   
MalaysiaCompanyNumber            | The Company Number given to each listed issuer in Malaysia, when registered with the exchange                       | [String(255)](https://github.com/fundapps/api-examples#data-types) |   


### Data Requirements

- *Id* (or IssuerId) needs to be unique. In the scenario where an IssuerId is uploaded which already exists as part of the Issuer Register, this will result in a validation error.
- the *Id* value needs to match the IssuerId field the Position file; this is key in order to be able to query the correct issuer information for disclosure forms.

## Imported Disclosure Data
We accept information about imported disclosures in CSV format. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Imported%20Disclosures.csv). Unlike the the other import files, these should be sent to support@fundapps.co as we upload directly into the databases.  

### File Column Detail

Column Name                 | Description                                                                                                                             | Data type                                                            | Required  
----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|-----------
RapptrRuleID                | ID of the rule for which this disclosure was made                                                                                       | [String](https://github.com/fundapps/api-examples#data-types)        | X 
AggregationStructure        | The aggregation structure where the rule triggered on                                                                                   | [String](https://github.com/fundapps/api-examples#data-types)        | X  
PortfolioOrEntityID         | ID of portfolio/entity where the rule triggered                                                                                         | [String](https://github.com/fundapps/api-examples#data-types)        | X  
ISIN                        | ISIN of the instrument which triggered the rule                                                                                         | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
IssuerID                    | ID of the issuer                                                                                                                        | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
IssuerName                  | Name of the issuer                                                                                                                      | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
OwnershipPercentageAtFiling | Inputting 6.25 here is equivalent to 6.25%                                                                                              | [Decimal(28,8)](https://github.com/fundapps/api-examples#data-types) | X  
DisclosureDate              | Date of disclosure. This must reference the actual trade date when the disclosure value was calculated. Choosing a weekend is not valid | [Date](https://github.com/fundapps/api-examples#data-types)          | X  

### Data Requirements

- IssuerId needs to be needs to be consistent throughout time so that the system can link the imported disclosure to another disclosure in the future.
