# Adapptr API Migration

In order to support our latest API changes in Adapptr, an amendment to the used API endpoints is required. Clients must replace the endpoint URLs previously confirmed by FundApps with new ones, similar to the example you can find below. We suggest clients amend their endpoints ASAP in preparation for the changeover in order to allow for testing, as we will be retiring the legacy architecture and as a result, clients would be mandated at that point to migrate for successful and continued Adapptr usage.

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

DIFF view of endpoint changes, an example for the positions upload:  
```diff
- https://abc2d2ef3g.execute-api.eu-west-1.amazonaws.com/prod/rest/api/v1/task/positions
+ https://abc-svc.fundapps.co/api/adapptr/v1/task/positions
```

ℹ A [Sample Postman collection](Sample-PostmanCollections/New_Adapptr.postman_collection) is available to use in your migration efforts.

◀ [Return to Main page](../README.md)