# FundApps API Spec & Examples

We provide a REST-ful HTTPS API for automated interfaces between your systems and our service. Our API uses predictable, resource-oriented URI's to make methods available and HTTP response codes to indicate errors. These built-in HTTP features, like HTTP authentication and HTTP verbs are part of the standards underpinning the modern web and are able to be understood by off-the-shelf HTTP clients.

Our API methods return machine readable responses in XML format, including error conditions.

## Base URI

If your installation is available at <https://%company%.fundapps.co/>, your API URI is available at <https://%company%-api.fundapps.co/>. Same rule applies for your staging API, available at <https://%company%-staging-api.fundapps.co/>.  
All requests made to our API must be over HTTPS.

## Authentication

You authenticate to the API via [Basic Authentication](https://tools.ietf.org/html/rfc2617) over HTTPS. An administrator from your organisation must create a user with the role "API" for this purpose. You must authenticate for all requests.
**Note:** Please ensure you create a separate user for the API as if you use an existing user's account, as soon as they change their password the API upload will fail.

## Methods

A number of methods are available, depending on the kind of data being uploaded. Typically customers send us a position file once or more a day; other uploads are optional and depend on business requirements.

All of our API methods expect your upload file to be sent as the body of the request; our example implementations show how to achieve this with commonly used HTTP libraries.

## Compatibility

Wherever possible, REST resources and their representations will be maintained in a backwards compatible manner.

If it is necessary to change a representation in a way that is not backwards compatible, a new resource will be created using the new representation, and the old resource will be maintained in accordance with the deprecation policy.

The behaviour of an API may change without warning if the existing behaviour is incorrect or constitutes a security vulnerability. 

In particular, consumers should pay attention to the following: 
* If a property has a primitive type and the API documentation does not explicitly limit its possible values, clients MUST NOT assume the values are constrained to a particular set of possible responses.
* If a property of an object is not explicitly declared as mandatory in the API, clients MUST NOT assume it will be present.
* New properties MAY be added to a representation at any time, but a new property MUST NOT alter the meaning of an existing property.

## Deprecation 

Our REST APIs will be given reasonable notice of deprecations. Any deprecated API MUST be available in its original form for at least 3 months, UNLESS there are critical security vulnerabilities.

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

We make an XSD schema available for the position upload XML format; this may be retrieved from the `GET /v1/expost/xsd` API endpoint on your instance . If you don't have access to an instance yet and would like access to an XSD file, please [contact support](https://fundapps.zendesk.com/hc/en-us/articles/200951119-Contacting-Support).

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

When the rule execution is completed successfully, an additional 'Summary' element is provided in the response. This aims to provide the same information as the email notification sent when a positions file finishes processing.

The Summary element is comprised of:

- The total number of alerts by type - i.e. Breach, Unknown, etc.
- The number of new alerts by type (since the day before).

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

Upload Portfolio data, if your portfolio structure changes frequently you may wish to refresh this at an appropriate frequency. There is the option to use `/v1/portfolios/import?ignoreUnknownProperties=true` to ignore unknown properties, needed when uploading portfolio file exported from the system. When no `ignoreUnknownProperties` parameter is appended, the default value of `ignoreUnknownProperties=false` will be used - the suffix is optional and not required to set the value to `false`. Expects CSV - [example file](Sample-ImportFiles/Portfolios.csv).

You cannot check the progress of a portfolio file upload. Instead, when you upload a portfolio file, it will return a status immediately of any of the following:

| ValidationState    | Explanation                  |
| ------------------ | ---------------------------- |
| Uploaded           | Succesfully uploaded         |
| Validation failure | File did not pass validation |
| No input document  | No file attached to API call |
| Unexpected Error   | Error in file upload         |
| With warnings      | File contains warnings, if there are no errors or validation failures then the file will be imported       |

### Sample Responses
**Upload successful**

    Response status: 200 OK
    Content-Type: application/xml

 **Validation failure**
 
    Response status: 200 OK
    Content-Type: application/xml
    
    (Response Content)
    <Response>
        <Error>Bad request. Input document did not pass validation. Please contact support@fundapps.co for assistance.</Error>
    </Response>

**No input document**

    Response status: 400 Bad Request
    Content-Type: application/xml
    
    (Response Content) 
    <Response>
        <Error>Bad request. No input document was found. Please contact support@fundapps.co for assistance.</Error>
    </Response>
    
**Unexpected Error**    

    Response status: 400 Bad Request
    Content-Type: application/xml
    
    (Response Content) 
    <Response>
        <Error>Unexpected error while processing import.</Error>
    </Response>
    
**With 13F Warnings**

    Response status: 200 OK
    Content-Type: application/xml
    
    (Response Content)
    <Response>
        <Warning>To ensure correct filings for 13F, your InvestmentManager13F details should be consistent in your portfolio file or within the portfolio settings.</Warning>
    </Response>
    
**With validation failure and 13F warnings**

    Response status: 200 OK
    Content-Type: application/xml

    (Response Content)
    <Response>
        <Error>Bad request. Input document did not pass validation. Please contact support@fundapps.co for assistance.</Error>
        <Warning>To ensure correct filings for 13F, your InvestmentManager13F details should be consistent in your portfolio file or within the portfolio settings.</Warning>
    </Response>


### `POST /v1/transactions/import` (Optional)

Upload Transaction data. Expects CSV - [example file](Sample-ImportFiles/Transactions.csv).

### `GET /results/missing-data?dataDate={date}` (Optional)

Get the missing data for a specific data date.

#### Sample Response

```json
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

```json
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

When uploading data to the API, it is stored and later displayed in the UI using a default file name. To specify a different file name, populate the "X-ContentName" header, e.g.

    POST https://%company%-api.fundapps.co/v1/expost/check HTTP/1.1 Content-Type: "application/xml" X-ContentName: "positions-monday.xml"

## Data Types

| Type                     | Definition                                                                                                                                                 | Example       |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| Boolean                  | Must be the word true or false (case sensitive)                                                                                                            | true          |
| Date                     | Must be in "YYYY-MM-DD" format ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601))                                                                        | 2015-12-31    |
| Decimal(Precision,Scale) | Must use "." as decimal separator. Group (thousand) separators are not allowed, exponential formatting not allowed. Up to 21 decimal places are supported. | 123444.227566 |
| Integer                  | Whole number (positive or negative). Group (thousand) separators are not allowed, exponential formatting not allowed                                       | 19944         |
| String                   | A sequence of characters. When using CSV format must not include commas (","). All strings are case-INSENSITIVE (except currencies)                        | Nokia         |
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

# FundApps Adapptr API

We provide a RESTful HTTPS API for automated interfaces between your systems and our Adapptr service. Our API uses predictable, resource-oriented URIs to make methods available and HTTP response codes to indicate errors. These built-in HTTP features, like HTTP authentication and HTTP verbs are part of the standards underpinning the modern web and are able to be understood by off-the-shelf HTTP clients.

Our API methods return machine readable responses in JSON format, including error conditions.

Please note our collection of Adapptr samples:

- [Sample Code and Scripts](Adapptr/Sample-Code&Scripts)
- [Sample Import Files](Adapptr/Sample-ImportFiles)
- [Sample Postman Collections](Adapptr/Sample-PostmanCollections)

Adapptr API documentation:

- [Adapptr API@v2 (latest)](Adapptr/versions/v2.md)
