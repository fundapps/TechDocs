# Rapptr Import Files

## Transaction Data

We accept transaction data in CSV format. You can find a sample file here.

### File column specifications

Column Name     | Data Type (Format) | Required/Optional | Length | Notes
----------------|--------------------|-------------------|--------|----------------------------
PORTFOLIOID     | String             | Required          | 510    |
ASSETID         | String             | Required          | 510    |
TRANSACTIONID   | String             | Required          | 200    |
EXECUTIONDATE   | Date (yyyy-mm-dd)  | Required          |        | E.g. 2016-01-27
TRANSACTIONTYPE | String             | Required          |        | See below for valid options       

### Recognised Transaction Types

Transaction
---------------
Buy             
Sell            
CorporateAction

### Data requirements

- The TransactionId field needs to be unique. In the scenario where a TransactionId is uploaded which already exists in Rapptr, this will result in a validation error:
- AssetId and PortfolioId need to correspond to the same fields in Position data; this is key in order to be able to query the correct transactions for disclosure forms.