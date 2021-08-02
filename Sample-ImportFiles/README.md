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

### Recognised Transaction Types (All case sensitive)

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

## Imported Disclosure Data
We accept information about imported disclosures in CSV format. You can find a [sample file here](https://github.com/fundapps/api-examples/blob/master/Sample-ImportFiles/Imported%20Disclosures.csv). Unlike the the other import files, these should be sent to support@fundapps.co as we upload directly into the databases.  

### File Column Detail

Column Name                 | Description                                                                                                                             | Data type                                                            | Required  
----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|-----------
RuleID                | ID of the rule for which this disclosure was made                                                                                       | [String](https://github.com/fundapps/api-examples#data-types)        | X 
AggregationName        | The aggregation structure where the rule triggered on                                                                                   | [String](https://github.com/fundapps/api-examples#data-types)        | X  
PortfolioOrEntityID         | ID of portfolio/entity where the rule triggered                                                                                         | [String](https://github.com/fundapps/api-examples#data-types)        | X  
ISIN                        | ISIN of the instrument which triggered the rule                                                                                         | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
IssuerID                    | ID of the issuer                                                                                                                        | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
IssuerName                  | Name of the issuer                                                                                                                      | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
Value | Ownership Percentage At Filing: Inputting 6.25 here is equivalent to 6.25%                                                                                               | [Decimal(28,8)](https://github.com/fundapps/api-examples#data-types) | X  
Date              | Date of disclosure. This must reference the actual trade date when the disclosure value was calculated. Choosing a weekend is not valid | [Date](https://github.com/fundapps/api-examples#data-types)          | X  

### Data Requirements

- IssuerId needs to be needs to be consistent throughout time so that the system can link the imported disclosure to another disclosure in the future.

## Create Data Overrides

### File Column Detail

Column Name                 | Description                                                                                                                             | Data type                                                            | Required  
----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|-----------
IsEnabled                |True for enabling the override                                                              | [Boolean](https://github.com/fundapps/api-examples#data-types)        | X 
Type        | Default is for populating fields that are blank or missing in the input file. \\ Override is for changing the value of fields when the input property matches a certain condition. \ Remove is for removing extra fields that are present in the input file.                                                                  | [String](https://github.com/fundapps/api-examples#data-types)        | X  
ConditionProperty         | ID of portfolio/entity where the rule triggered                                                                                         | [String](https://github.com/fundapps/api-examples#data-types)        | X  
ConditionValue                        | ISIN of the instrument which triggered the rule                                                                                         | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
TargetProperty                    | ID of the issuer                                                                                                                        | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
TargetSourceType                  | Name of the issuer                                                                                                                      | [String(255)](https://github.com/fundapps/api-examples#data-types)   | X  
TargetSource | Ownership Percentage At Filing: Inputting 6.25 here is equivalent to 6.25%                                                                                               | [Decimal(28,8)](https://github.com/fundapps/api-examples#data-types) | X  
TargetCondition              | Date of disclosure. This must reference the actual trade date when the disclosure value was calculated. Choosing a weekend is not valid | [Date](https://github.com/fundapps/api-examples#data-types)          | X  
ActiveFrom              | Date of disclosure. This must reference the actual trade date when the disclosure value was calculated. Choosing a weekend is not valid | [Date](https://github.com/fundapps/api-examples#data-types)          | X  
ActiveTo              | Date of disclosure. This must reference the actual trade date when the disclosure value was calculated. Choosing a weekend is not valid | [Date](https://github.com/fundapps/api-examples#data-types)          | X  
Note  | Date of disclosure. This must reference the actual trade date when the disclosure value was calculated. Choosing a weekend is not valid | [Date](https://github.com/fundapps/api-examples#data-types)          | X 