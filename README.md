# FundApps API Spec & Examples

We provide a REST-ful HTTPS API for automated interfaces between your systems and our service. Our API uses predictable, resource-oriented URI's to make methods available and HTTP response codes to indicate errors. These built-in HTTP features, like HTTP authentication and HTTP verbs are part of the standards underpinning the modern web and are able to be understood by off-the-shelf HTTP clients.

Our API methods return machine readable responses in XML format, including error conditions.

## Base URI

If your Rapptr installation is available at <https://%company%.fundapps.co/>, your API URI is available at <https://%company%-api.fundapps.co/>. Same rule applies for your staging API, available at <https://%company%-staging-api.fundapps.co/>.  
All requests made to our API must be over HTTPS.

## Authentication

You authenticate to the Rapptr API via [Basic Authentication](https://tools.ietf.org/html/rfc2617) over HTTPS. A Rapptr administrator from your organisation must create a user with the role "API" for this purpose. You must authenticate for all requests.
**Note:** Please ensure you create a separate user for the API as if you use an existing user's account, as soon as they change their password the API upload will fail.

## Methods

A number of methods are available, depending on the kind of data being uploaded. Typically customers send us a position file once or more a day; other uploads are optional and depend on business requirements.

All of our API methods expect your upload file to be sent as the body of the request; our example implementations show how to achieve this with commonly used HTTP libraries.

### `POST /v1/expost/check`

Upload Daily Positions. This method expects to receive data in XML format ([example XML position files](Sample-XML/)); large files may be zipped. The response includes a link which when polled allows monitoring of the progress of processing the file.

#### Sample

    (Request Headers)
    POST https://%company%-api.fundapps.co/v1/expost/check HTTP/1.1 Content-Type: "application/xml"

    (Response)
    <links>
      <result>/v1/ExPost/Result/fe633307-f196-4609-abfe-a1fc0111e875</result>
    </links>

#### Position File XSD

We make an XSD schema available for the position upload XML format; this may be retrieved from the `GET /v1/expost/xsd` API endpoint on your Rapptr instance . If you don't have access to an instance yet and would like access to an XSD file, please [contact support](https://fundapps.zendesk.com/hc/en-us/articles/200951119-Contacting-Support).

### `GET /v1/expost/result/<guid>`

Check the progress of the rule processing on a position upload. As noted above, when uploading a position file the specific URI for checking progress is provided; the unique ID of the job is included in the URI.

This endpoint returns a `202 Accepted` HTTP status whilst the check is in progress and a `200 OK` status when the check is complete. The progress of validation and rule execution is reported separately in the response.

| ValidationState | RuleState  | Explanation                                  |
| --------------- | ---------- | -------------------------------------------- |
| Unknown         | Unknown    | Job just received; not processed yet         |
| Pending         | Pending    | Job queued                                   |
| InProgress      | Pending    | Validation in progress                       |
| Passed          | InProgress | Rule execution in progress                   |
| Failed          | NotRun     | Validation failed; rule processing cancelled |
| Passed          | Failed     | Rule execution failed                        |
| Passed          | Passed     | Rule execution successful                    |

When the rule execution is completed successfully, an additional 'Summary' element is provided in the response. This aims to provide the same information as the email notification sent by Rapptr when a positions file finishes processing.

The Summary element is comprised of:

- The total number of alerts by type - i.e. Breach, Unknown, etc.
- The number of new alerts by type (since the day before).

You cannot check the progress of a portfolio file upload. Instead, when you upload a portfolio file, it will return a status immediately of any of the following:

| ValidationState    | Explanation                  |
| ------------------ | ---------------------------- |
| Uploaded           | Succesfully uploaded         |
| Validation failure | File did not pass validation |
| No input document  | No file attached to API call |
| Unexpected Error   | Error in file upload         |

#### Sample

    (Request)
    GET https://%company%-api.fundapps.co/v1/ExPost/Result/fe633307-f196-4609-abfe-a1fc0111e875 HTTP/1.1
    Content-Type: application/xml

    (Response Headers, Rules running)
    HTTP/1.1 202 Accepted
    Content-Type: application/xml

    (Response Content, Rules running)
    <?xml version="1.0" encoding="utf-8"?>
    <ResultsSnapshot ValidationState="Passed" RuleState="InProgress" />

    (Response Headers, Validation failed)
    HTTP/1.1 200 OK
    Content-Type: application/xml

    (Response Content, Validation failed)
    <?xml version="1.0" encoding="utf-8"?>
    <ResultSnapshot ValidationState="Failed" RuleState="NotRun" />

    (Response Content, File processed successfully)
    <?xml version="1.0" encoding="utf-8"?>
    <ResultsSnapshot ValidationState="Passed" RuleState="Passed" Status="Okay" PipelineStage="Finished" Duration="00:01:28.7030000">
        <Summary DataDate="2015-07-20">
            <Breach Total="1" New="1" />
            <Disclosure Total="18" New="18" />
            <Unknown Total="2" New="2" />
            <Warning Total="4" New="4" />
            <OK Total="399" New="399" />
        </Summary>
    </ResultsSnapshot>

### `POST /v1/portfolios/import` (Optional)

Upload Portfolio data, if your portfolio structure changes frequently you may wish to refresh this at an appropriate frequency. There is the option to use `/v1/portfolios/import?ignoreUnknownProperties=true` to ignore unknown properties, needed when uploading portfolio file exported from Rapptr. When no `ignoreUnknownProperties` parameter is appended, the default value of `ignoreUnknownProperties=false` will be used - the suffix is optional and not required to set the value to `false`. Expects CSV - [example file](Sample-ImportFiles/Portfolios.csv).

### `POST /v1/transactions/import` (Optional)

Upload Transaction data. Expects CSV - [example file](Sample-ImportFiles/Transactions.csv).

### `GET /results/missing-data?dataDate={date}` (Optional)

Get the missing data for a specific data date.

#### Sample Response

```
{
   "SnapshotDate":"2020-08-03",
   "PropertyMissing":[
      {
         "PropertyName":"IssuerName",
         "PropertyDetails":[
            {
               "AssetId":"ABC_1",
               "IssuerId":"Issuer4",
               "IssuerName":"Issuer 4 Name",
               "InstrumentId":"Instrument4",
               "InstrumentName":"Instrument 4 Name",
               "AffectedPortfolios":[
                  "PortfolioA",
                  "PortfolioB"
               ],
               "AffectedRules":[
                  "Rule 1"
               ]
            }
         ]
      }
   ]
}
```

### `GET /v1/userProvision` (Optional)

Gets the user entitlement and access information.

#### Sample Response

```
[
   {
      "Id":"1cf50653-7b9e-494e-8b4e-01ff6bc2a0e7",
      "DisplayName":"User1",
      "Role":"SuperUser",
      "CompanyName":"Company1",
      "Email":"example2@email.com",
      "CreatedDate":"2021-09-14T12:53:10.61",
      "LastLogin":null,
      "IsDeactivated":false,
      "PasswordFailuresSinceLastSuccess":0
   },
   {
      "Id":"3b2c6a62-d1dd-492f-b216-ffb73a291455",
      "DisplayName":"User2",
      "Role":"SuperUser",
      "CompanyName":"Company1",
      "Email":"example2@email.com",
      "CreatedDate":"2021-09-14T12:53:10.61",
      "LastLogin":"2021-09-21T08:43:45.257",
      "IsDeactivated":false,
      "PasswordFailuresSinceLastSuccess":0
   }
]
```

## Request Content-Types

When sending data to the API we expect certain content types to be set on your request e.g.

    POST https://%company%-api.fundapps.co/v1/expost/check HTTP/1.1 Content-Type: "application/xml"

These Content-Type values are as follows:

| Input Type | Content-Type                                                      |
| ---------- | ----------------------------------------------------------------- |
| CSV        | text/csv                                                          |
| XLS        | application/vnd.ms-excel                                          |
| XLSX       | application/vnd.openxmlformats-officedocument.spreadsheetml.sheet |
| XML        | application/xml                                                   |
| ZIP        | application/zip                                                   |

## Content Names

When uploading data to the API, it is stored and later displayed in Rapptr using a default file name. To specify a different file name, populate the "X-ContentName" header, e.g.

    POST https://%company%-api.fundapps.co/v1/expost/check HTTP/1.1 Content-Type: "application/xml" X-ContentName: "positions-monday.xml"

## Data Types

| Type                     | Definition                                                                                                                                                 | Example       |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| Boolean                  | Must be the word true or false (case sensitive)                                                                                                            | true          |
| Date                     | Must be in "YYYY-MM-DD" format ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601))                                                                        | 2015-12-31    |
| Decimal(Precision,Scale) | Must use "." as decimal separator. Group (thousand) separators are not allowed, exponential formatting not allowed. Up to 21 decimal places are supported. | 123444.227566 |
| Integer                  | Whole number (positive or negative). Group (thousand) separators are not allowed, exponential formatting not allowed                                       | 19944         |
| String                   | A sequence of characters. When using CSV format must not include commas (","). All strings are case-INSENSITIVE in Rapptr (except currencies)              | Nokia         |
| List                     | Comma separated string                                                                                                                                     | XNYC,XLON     |

## Max File Size

When uploading via the API, we have a maximum allowed file size of approximately 200MB. If your file exceeds this size we suggest zipping it.

## Examples

We provide a number of example implementations against our API using commonly available programming languages and libraries in this repository.

# FundApps Room In A Name (RIAN) API

The Room In A Name API allows our clients to programtically consume the exact number of instruments they can trade before reaching a reportable threshold, in both an upward and downward direction.

The RIAN API is interactively documented using Swagger. Clients can access the documentation at {clientname}-api.fundapps.co/swagger with an API user.

## Position Limits Clients

The RIAN API is Position Limits (PL) enabled, please make sure to select "PL" from the dropdown at top-right of the page to see Position Limits specific extensions to the API.

# FundApps Adapptr Spec & Examples

We provide a RESTful HTTPS API for automated interfaces between your systems and our Adapptr service. Our API uses predictable, resource-oriented URIs to make methods available and HTTP response codes to indicate errors. These built-in HTTP features, like HTTP authentication and HTTP verbs are part of the standards underpinning the modern web and are able to be understood by off-the-shelf HTTP clients.

Our API methods return machine readable responses in JSON format, including error conditions.

Please note our collection of Adapptr samples:

- [Sample Code and Scripts](Adapptr/Sample-Code&Scripts)
- [Sample Import Files](Adapptr/Sample-ImportFiles)
- [Sample Postman Collections](Adapptr/Sample-PostmanCollections)

ℹ See [here](Adapptr/APIMigration.md) for a page detailing the Adapptr API migration.

## Base URI

The base url will be shared in the Adapptr implementation manual.

## Authentication

You authenticate to the Adapptr API via [Basic Authentication](https://tools.ietf.org/html/rfc2617) over HTTPS. A Rapptr administrator from your organisation must create a user with the role "API" for this purpose. You must authenticate for all requests.
**Note:** Please ensure you create a separate user for the API as if you use an existing user's account, as soon as they change their password the API upload will fail.

## Methods

For all methods, the header `X-Client-Environment` is required. This must be populated with the name of your FundApps environment.

For all methods, authentication is made against your FundApps environment. You are required to include the Username and Password of an API user in the FundApps environment you have set in the `X-Client-Environment` header.

## Available Nomenclatures `GET /rest/api/v1/nomenclatures` (migrated: `GET /api/adapptr/v1/nomenclatures`)

List of available data providers, identifier types, position services and more. Those can be requested from this endpoint. You must then use the appropriate ids for parameters in other requests.

| Id  | Data Provider |
| --- | ------------- |
| 1   | Refinitiv     |
| 2   | Bloomberg     |

| Id  | Identifier Type |
| --- | --------------- |
| 1   | Isin            |
| 2   | Sedol           |

| Id  | Positions Service                         |
| --- | ----------------------------------------- |
| 2   | Shareholding Disclosure                   |
| 4   | Position Limits                           |
| 6   | Shareholding Disclosure & Position Limits |

| Id  | File Data Formats |
| --- | --------------- |
| 1   | FundApps         |
| 2   | Consensys       |

## Data Provider Credentials `POST /rest/api/v1/configuration/dataproviders/:providerId/credentials` (migrated `POST /api/adapptr/v1/configuration/dataproviders/:providerId/credentials`)

If you are using Refinitiv data you must submit your username and password to this endpoint. Before being able to post a file to Adapptr, your data provider credentials must be set. Your file upload will otherwise fail because FundApps will be unable to connect and authenticate against the data provider.

`This endpoint does not support Bloomberg data provider. The support team will have to use your Bloomberg generated certificate to enable Adapptr integration. Please contact support@fundapps.co or you Client Success Manager for more details.`

e.g
`{ "Username": "[Username]", "Password": "[Password]" }`

## Upload positions `POST /rest/api/v1/task/positions` (migrated: `POST /api/adapptr/v1/task/positions`)

Upload daily positions. This method expects a csv format ([example Adapptr position files](Adapptr/)). The response includes a `taskId` and a `trackingEndpoint` that can then be polled via the GET method to monitor the progress of the task through the Adapptr service.  

The `positions` parameter must be the file that you need to upload.  

The `snapshotDate` parameter must be included as a parameter in the format `yyyy-mm-dd`. This is the snapshot date of the positions being uploaded in the csv file.

The `services` _[optional]_ parameter can be included if you need different from the default `Shareholding Disclosure` service. It expects Id of a service(s), that could be obtained from the [Available Nomenclatures](#available-nomenclatures-get-restapiv1nomenclatures) endpoint.

The `primaryIdentifier` _[optional]_ parameter can be included if you need to specify which identifier from your positions file you wish to use to query against the data provider. For example if a position has both ISIN and SEDOL this parameter indicates which of the two identifiers should be used when requesting data from your market data provider. If not populated, the default is ISIN. The value could be obtained from the [Available Nomenclatures](#available-nomenclatures-get-restapiv1nomenclatures) endpoint.

The `secondaryIdentifier` _[optional]_ parameter can be included if you need to specify which identifier to fall back to if your primaryIdentifier is not populated. For example if your primaryIdentifier is set to 1 for ISIN and you have a position which doesn't have an ISIN but has a SEDOL, setting the secondaryIdentifier to 2 (SEDOL) would tell Adapptr to use SEDOL to query data from your market data provider if ISIN is not populated. By default this is empty. The value could be obtained from the [Available Nomenclatures](#available-nomenclatures-get-restapiv1nomenclatures) endpoint.

The `excludeErroredAssets` _[optional]_ is a boolean parameter that can be set if you need to send the positions to Rapptr despite errors due to incomplete data from your market data provider. Default value: `false`

The `dataProvider` _[optional]_ is an integer parameter that can be set if you need to select a specific data provider. Default value is `1` (Refinitiv). A list of all supported providers can be obtained from the [Available Nomenclatures](#available-nomenclatures-get-restapiv1nomenclatures) endpoint.

The `copyDownParentInstrumentData` _[optional]_ is a boolean parameter that can be set if you find the Bloomberg component data not complete enough. Setting the value to `true` will copy all data from the parent instrument to the instrument of the component. The resulting component instrument will be Equity. Default value: `false`

The `populateExecutionVenueWithMarket` _[optional]_ is a boolean parameter that can be set if you need to use your data provider's Market field to populate ExecutionVenue of your assets. Default value: `false`

## Upload positions without enrichment `POST /rest/api/v1/task/positions/without-enrichment` (migrated: `POST /api/adapptr/v1/task/positions/without-enrichment`)

This method converts the Consensys or Adapptr csv file format into the FundApps required format for the Position Limits service only. The response includes a taskId and a trackingEndpoint that can then be polled via the GET method to monitor the progress of the task through the Adapptr service.  

The `positions` parameter must be the file that you need to upload.  

The `snapshotDate` parameter must be included as a parameter in the format `yyyy-mm-dd`. This is the snapshot date of the positions being uploaded in the CSV file.

The `format` _[optional]_ _[default value = 2]_ parameter can be included if you prefer using different file data format. A list of all supported file data formats can be obtained from the [Available Nomenclatures](#available-nomenclatures-get-restapiv1nomenclatures) endpoint.

This method works only with the FundApps Position Limits service. Please see [here](Adapptr/Position%20Limits) for an example.

#### Sample Response

```
{
    "id": "35ce6225-1534-4e7e-8199-611a8647f8ee",
    "type": {
        "id": 1,
        "name": "Positions"
    },
    "status": {
        "id": 1,
        "name": "Accepted",
        "description": "Position file accepted. Please check the tracking endpoint to check for any errors in the file upload and to track the progress of the file enrichment and transmission to Rapptr."
    },
    "dateCreated": "2021-06-17T09:20:58.9553866Z",
    "dateUpdated": null,
    "trackingEndpoint": "/prod/api/adapptr/v1/task/35ce6225-1534-4e7e-8199-611a8647f8ee/status"
}
```

## Task status `GET /rest/api/v1/task/:taskID/status` (migrated: `GET /api/adapptr/v1/task/:taskID/status`)

GET the task status. This method returns a status of the requested TaskId and if the task has failed, the errors that have contributed to the failure.

There are 4 status ids

| id  | status                    | Explanation                                                                                                                                                                       |
| --- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Accepted                  | Job just received; not processed yet.                                                                                                                                             |
| 2   | Enriched                  | Data is being requested from data provider, then enriched with the csv file and the xml file generated but not yet sent to Rapptr.                                                |
| 3   | Transmitted               | xml file sent to fundapps.                                                                                                                                                        |
| 4   | Enriched With Exclusions    | Data is being requested from data provider, then enriched with the csv file and the xml file generated but not yet sent to Rapptr, some positions skipped due to incomplete data. |
| 5   | Transmitted With Exclusions | xml file sent to fundapps, some positions skipped due to incomplete data.                                                                                                         |
| 6   | Waiting Extractions        | A request is sent to the data provider, but there is no response yet.                                                                                                             |
| 500 | Failed                    | Job has failed. Please read errors to identify cause of job failure.                                                                                                              |

Once transmitted, the request will give the Rapptr `trackingEndpoint` url which can be polled to check the status of the XML positions file upload to FundApps.

#### Sample Response

```
{
    "id": "9b134cda-81db-44c0-9c52-cfeb897e663a",
    "type": {
        "id": 1,
        "name": "Positions"
    },
    "status": {
        "id": 5,
        "name": "Transmitted With Exclusions",
        "description": "Successfully transmited to Rapptr. Some positions were skipped, most likly due to incomplete data from your market data provider. Please check the warnings field for a list of all skipped positions as well as the cause reason."
    },
    "dateCreated": "2021-07-22T17:09:01.186+03:00",
    "dateUpdated": "2021-07-22T17:13:19.024+03:00",
    "trackingEndpoint": "https://demo-melon-api.fundapps.co/v1/expost/result/38ba5713-c253-42d1-896a-bd6e00ea5ec3",
    "statusReport": {
        "errors": null,
        "warnings": [
            "Identifier: <Identifier> | Component is required for this instrument. Refinitiv returned null or empty value for UnderlyingISIN and UnderlyingRIC. Consider providing ComponentISIN value in the positions file.",
            "Identifier: <Identifier> | Empty result while getting enrichment data for item. Please check if the identifier is valid.",
            "For component | Parent Identifier: <Identifier> | Identifier: <Identifier> | Unsupported AssetClass: <AssetClass>"
        ]
    }
}
```
