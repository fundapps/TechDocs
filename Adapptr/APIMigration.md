# Adapptr API Migration

As part of our commitment to improve the Adapptr product, we are migrating the API to serverless deployments. By doing this, we are able to better manage resources and migrate clients to an enhanced infrastructure which offers faster and even more efficient file runs.

In order to support this for our Adapptr clients, an amendment to the used API endpoints is required. Clients would need to replace the endpoint URLs previously confirmed by FundApps with new ones, similar to the example you can find below. We suggest clients amend their endpoints ASAP in preparation for the changeover in order to allow for testing, as we will be retiring the legacy architecture and as a result, clients would be mandated at that point to migrate for successful and continued Adapptr usage.

## ABC Ltd. Example

For example, a client named **ABC Ltd**. is able to access their Rapptr service at `https://abc.fundapps.co`.  
Their current **base Adapptr URL** of `https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod`.

As per the [official docs](../README.md), **ABC's** endpoints currently resemble the below:

`BaseUrl = https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod` + `/rest/api/v1` + `/configuration/dataproviders/{providerId}/credentials`  
`BaseUrl = https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod` + `/rest/api/v1` + `/nomenclatures`  
`BaseUrl = https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod` + `/rest/api/v1` + `/task/positions`  
`BaseUrl = https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod` + `/rest/api/v1` + `/task/positions/without-enrichment`  
`BaseUrl = https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod` + `/rest/api/v1` + `/task/{taskId}/status`  
etc.

**ABC**'s Rapptr service URL remains the same after migration.  
Their their new **base Adapptr URL** however is `https://abc-svc.fundapps.co`.  
The new endpoints are the same as above, except for replacing `/rest/api/v1/` with `/api/adapptr/v1/`, as shown below:

`BaseUrl = https://abc-svc.fundapps.co` + `/api/adapptr/v1` + `/configuration/dataproviders/{providerId}/credentials`  
`BaseUrl = https://abc-svc.fundapps.co` + `/api/adapptr/v1` + `/nomenclatures`  
`BaseUrl = https://abc-svc.fundapps.co` + `/api/adapptr/v1` + `/task/positions`  
`BaseUrl = https://abc-svc.fundapps.co` + `/api/adapptr/v1` + `/task/positions/without-enrichment`  
`BaseUrl = https://abc-svc.fundapps.co` + `/api/adapptr/v1` + `/task/{taskId}/status`  
etc.

ℹ A [Sample Postman collection](Sample-PostmanCollections/New_Adapptr.postman_collection) is available to use in your migration efforts. Please ignore the `Adapptr Integrations` folder if you are not signed up to use this functionality.
