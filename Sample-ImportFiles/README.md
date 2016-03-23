# Rapptr File Formats

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

Type            | Description                                          |
----------------|------------------------------------------------------|
Buy             | A standard purchase / buy transaction                |
Sell            | A standard sale /sell transaction                    |
CorporateAction |                                                      |
Expiry          |                                                      |
Exercise        |                                                      |
Adjustment      | Internal transfer of Assets                          |
Maturity        |                                                      |
TakeOn          | Asset resulting from a new account being opened      |
Withdrawal      | Asset withdrawn due to an account being closed       |


### Data requirements

- *TransactionId* needs to be unique. In the scenario where a TransactionId is uploaded which already exists in Rapptr, this will result in a validation error:
- *AssetId* and *PortfolioId* values need to match the fields with the same name in Position data; this is key in order to be able to query the correct transactions for disclosure forms.
