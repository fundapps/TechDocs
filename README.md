# FundApps API Spec & Examples

We provide a REST-ful HTTPS API for automated interfaces between your systems and our service. Our API uses predictable, resource-oriented URI's to make methods available and HTTP response codes to indicate errors. These built-in HTTP features, like HTTP authentication and HTTP verbs are part of the standards underpinning the modern web and are able to be understood by off-the-shelf HTTP clients.

Our API methods return machine readable responses in XML format, including error conditions.

## Base URI
If your Rapptr installation is available at https://company.fundapps.co/ the URI from which your API is available is https://company-api.fundapps.co/. API requests to our API must be made over HTTPS.

## Authentication
You authenticate to the Rapptr API via HTTP Basic Authentication, using an API credential created by a Rapptr administrator within your organisation. You must authenticate for all requests.

## Methods

A number of methods are available, depending on the kind of data being uploaded. Typically customers send us a position file once or more a day; other uploads are optional and depend on business requirements.

All of our API methods expect your upload file to be sent as the body of the request; our example implementations show how to achieve this with commonly used HTTP libraries.

* `POST /v1/expost` - Upload Daily Positions. Expects data in XML format ([example XML position file](Sample-XML/)); large files may be zipped. Our response to this request includes a link to another method which allows tracking of job progress.

* `POST /v1/indexdata` - (Optional) Upload Index data, if you wish to decouple this from your daily position upload. Expects CSV (Recommended), XLS or XLSX format.

*  `POST /v1/portfolios` - (Optional) Upload Portfolio data, if your portfolio structure changes frequently you may wish to refresh this at an appropriate frequency. Expects CSV (Recommended, [example CSV portfolio file](Sample-ImportFiles/Portfolios.csv)), XLS or XLSX format.

When sending data to these endpoints we expect certain content types to be set e.g.

    POST https://fictitious-staging-api.fundapps.co/v1/expost/check HTTP/1.1 Content-Type: "application/xml"

These Content-Type values are as follows:

Input Type  | Content-Type
------------|-----------
CSV         | text/csv
XLS         | application/vnd.ms-excel
XLSX        | application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
XML         | application/xml
ZIP         | application/zip

## Examples
We provide a number of example implementations against our API using commonly available programming languages and libraries in this repository.
