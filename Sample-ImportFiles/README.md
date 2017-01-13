# Rapptr File Formats

## Portfolio File

When uploading company structures and portfolios to Rapptr, we recommend that this is done at once using our CSV portfolio file template. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Portfolios.csv) and a sample file with multiple aggregation structures [here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/PortfoliosMultipleAggregationStructures.csv). For more guidance on how to structure your portfolio file, please refer to this [Help Centre article](https://fundapps.zendesk.com/hc/en-us/articles/210134023-Portfolio-File).

Please see [here](http://docs.fundapps.co/disclosureProperties.html#InstrumentProperties) for the portfolio file specs 

- *PortfolioId* needs to be unique. In the scenario where a PortfolioId is uploaded which already exists in Rapptr, the previous portfolio details associated with that PortfolioId will be overridden, so if any columns are blank (e.g. disclosure form properties, then existing values will be overridden)

## Transaction Data

We accept transaction data in CSV format. You can find a [sample file here](Transactions.csv).

### File Column Detail

Column Name     | Data Type (Format) | Required/Optional | Length | Notes
----------------|--------------------|-------------------|--------|----------------------------
PORTFOLIOID     | String             | Required          | 255    |
ASSETID         | String             | Required          | 255    |
TRANSACTIONID   | String             | Required          | 200    |
EXECUTIONDATE   | Date (yyyy-mm-dd)  | Required          |  -     | E.g. 2016-01-27
TRANSACTIONTYPE | String             | Required          |  -     | See below for valid options       
PRICE           | Decimal            | Required          |  -     | Precision: 28; Scale: 8
QUANTITY        | Decimal            | Required          |  -     | Precision: 28; Scale: 8
BROKERNAME      | String             | Optional          |  255   | 

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

We accept issuer register data in CSV format. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Issuers%20Register%20Upload.csv).

### File Column Detail

Column Name                       | Data Type (Format) | Required/Optional | Length  
----------------------------------|--------------------|-------------------|--------
Id                                | String             | Required          | 255    
Name                              | String             | Required          | 255    
Address                           | String             | Required          | 255    
City                              | String             | Required          | 255    
Province                          | String             | Optional          | 255    
PostCode                          | String             | Optional          | 255    
Country                           | String             | Required          | 255  

### Additional Issuer Register Fields

Column Name                       | Data Type (Format) | Required/Optional | Length 
----------------------------------|--------------------|-------------------|--------
ContactPerson                     | String             | Optional          | 255   
ContactPersonPosition             | String             | Optional          | 255     
EmailAddress                      | String             | Optional          | 255     
TelephoneNumber                   | String             | Optional          | 255      
AustralianCompanyNumber           | String             | Optional          | 255     
AustralianRegisteredSchemeNumber  | String             | Optional          | 255     
SouthAfricanRegistrationNumber    | String             | Optional          | 255     
IssuersRegisterCourt              | String             | Optional          | 255     
RegisterType                      | String             | Optional          | 255     
RegisterNumber                    | String             | Optional          | 255     


### Issuer Register Field Definitions

Type            | Description                                                                                                        |
----------------|--------------------------------------------------------------------------------------------------------------------|
Id                                | The IssuerId that is currently used in your position file                                       |
Name                              | The legal name of the issuer. This field could refer to the IssuerName that is currently used in                                      your position file                                                                              |
ContactPerson                     | The primary issuer contact                                                                      |
ContactPersonPosition             | The primary issuer contact's position                                                           |
EmailAddress                      | The primary issuer contact's email address                                                      |
TelephoneNumber                   | The primary issuer contact's telephone number                                                   |
AustralianCompanyNumber           | The Australian Company Number (ACN) is a unique, nine-digit number. Under the Corporations Act                                        2001, every company in Australia has been issued an ACN to ensure adequate identification of                                          companies when transacting business                                                             |
AustralianRegisteredSchemeNumber  | The Australian Registered Scheme Number (ARSN) is a nine digit number issued to Australian                                            managed investment schemes by Australian Securities and Investments Commission.                  |
SouthAfricanRegistrationNumber    | The South African company registration number                                                   |
IssuersRegisterCourt              | German company registration court. For more information consult or more information consult     [Germany's Company Register](https://www.unternehmensregister.de/ureg/search1.2.html;jsessionid=0198670396BF01C2137968DEEC63C8CE.web01-1?submitaction=language&language=en)                                                                                               |
RegisterType                      | German company registeration type. Possible values could include: Cooperative Register, Commercial Register Excerpt, Commercial Register, Partnership Register. For more information consult [Germany's Company Register](https://www.unternehmensregister.de/ureg/search1.2.html;jsessionid=0198670396BF01C2137968DEEC63C8CE.web01-1?submitaction=language&language=en)                                                                                                                  |
RegisterNumber                    | The German company registeration number                                                         |


### Data Requirements

- *Id* (or IssuerId) needs to be unique. In the scenario where an IssuerId is uploaded which already exists as part of the Issuer Register, this will result in a validation error.
- the *Id* value needs to match the IssuerId field the Position file; this is key in order to be able to query the correct issuer information for disclosure forms.
