# Rapptr File Formats

## Portfolio File

When uploading company structures and portfolios to Rapptr, we recommend that this is done at once using our CSV portfolio file template. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Portfolios.csv) and a sample file with multiple aggregation structures [here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/PortfoliosMultipleAggregationStructures.csv). For more guidance on how to structure your portfolio file, please refer to this [Help Centre article](https://fundapps.zendesk.com/hc/en-us/articles/210134023-Portfolio-File).

### File column detail

Column Name         | Description                                   | Data Type (Format) | Notes
--------------------|-----------------------------------------------|------------------- |----------------------------
PortfolioId         | Unique identifier for the portfolio / entity  | String             | Must be unique    
PortfolioName       | The name of the portfolio / entity            | String             |    
PortfolioCurrency   | Currency in which the portfolio is denominated| String             | [ISO 4217 code](http://www.xe.com/iso4217.php)
PortfolioType       | Values: Portfolio or Entity                   | String             | Portfolio - a container that holds assets (Accounts, Funds, Portfolios etc.); Entity - an aggregation of portfolios (Management Company, Controlling Entity, etc.)
PortfolioCompany    | If a Chinese wall, or similar, exists, you will be able to limit the visibility to specific areas of the business.                                                           | String             | More information is available [here](https://fundapps.zendesk.com/hc/en-us/articles/201749897-Creating-and-Editing-Companies-)            
DefaultParentID     | Identifier (PortfolioID) of the Entity that a portfolio or (sub)Entity aggregates to                                                                                                | String             | Must match a PortfolioID of an Entity in the file. This is used to define the aggregation structure. In this case, an aggregation structure named "Default" is used. For Entities which are at the top of the tree, the DefaultParentID will be it's own PortfolioID. For clients with multiple aggregation structures, additional columns named "XParentID" can be added, where X is the name of the tree (e.g. Voting, Legal, Management)      
RuleFolders        | Defines which rules run on the system. Whether that's disclosure rules, UCITS monitoring or similar                                                                                  | String             | For our standard Shareholding Disclosure client use: Disclosure, Validation, Validation Disclosure. This list is always being added to, please contact us if there's something else you'd like to check      
CompanyType        | Values that indicate classifications for a portfolio/entity that have effect on the application of certain rules.                                                                     | String             | Valid CompanyTypes: CA-AMRS, UKIM, US-QII, USPassiveInvestor, ITFM, NotZA. More information is available [here](https://fundapps.zendesk.com/hc/en-us/articles/204842149-CompanyType-values)        
FundDomicile      | Country where the fund is domiciled. Required for Spanish major shareholding rules to determine if the fund is domiciled in a tax haven. If not provided Rapptr will conservatively run both tax haven and non tax haven rules.                                                                                          | String           |  [ISO 3166-1 alpha-2 code](http://data.okfn.org/data/core/country-list)

### Data requirements

- *PortfolioId* needs to be unique. In the scenario where a PortfolioId is uploaded which already exists in Rapptr, the previous portfolio details associated with that PortfolioId will be overridden. 


## Transaction Data

We accept transaction data in CSV format. You can find a [sample file here](Transactions.csv).

### File column detail

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


### Data requirements

- *TransactionId* needs to be unique. In the scenario where a TransactionId is uploaded which already exists in Rapptr, this will result in a validation error.
- *AssetId* and *PortfolioId* values need to match the fields with the same name in Position data; this is key in order to be able to query the correct transactions for disclosure forms.


## Issuer Register Data

We accept issuer register data in CSV format. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Issuers%20Register%20Upload.csv).

### File column detail

Column Name                       | Data Type (Format) | Required/Optional | Length  
----------------------------------|--------------------|-------------------|--------
Id                                | String             | Required          | 255    
Name                              | String             | Required          | 255    
Address                           | String             | Required          | 255    
City                              | String             | Required          | 255    
Province                          | String             | Optional          | 255    
PostCode                          | String             | Optional          | 255    
Country                           | String             | Required          | 255  

### Additional Issuer Register Fields:

Column Name                       | Data Type (Format) | Required/Optional | Length 
----------------------------------|--------------------|-------------------|--------
ContactPerson                     | String             | Optional          | 255   
ContactPersonPosition             | String             | Optional          | 255     
EmailAddress                      | String             | Optional          | 255     
TelephoneNumber                   | String             | Optional          | 15      
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


### Data requirements

- *Id* (or IssuerId) needs to be unique. In the scenario where an IssuerId is uploaded which already exists as part of the Issuer Register, this will result in a validation error.
- the *Id* value needs to match the IssuerId field the Position file; this is key in order to be able to query the correct issuer information for disclosure forms.
