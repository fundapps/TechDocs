using FundAppsScripts.DTOs;
using RestSharp;
using RestSharp.Authenticators;
using System;
using System.Net;

namespace FundAppsScripts.Scripts
{
    public partial class AdapptrScripts
    {
        readonly AdapptrConfig _adapptrConfig;

        public AdapptrScripts(AdapptrConfig adapptrConfig)
        {
            _adapptrConfig = adapptrConfig;
        }

        // if you need to use Bloomberg as a data provider the implementation given below is not applicable
        // please refer to the documentation for more info: https://github.com/fundapps/TechDocs#data-provider-credentials-post-restapiv1configurationdataprovidersprovideridcredentials

        public void PostDataPrividerCredentials()
        {
            var baseUrl = _adapptrConfig.BaseUrl;
            var username = _adapptrConfig.Username;
            var password = _adapptrConfig.Password;

            var refinitivId = 1;
            // set your username
            var refinitivUsername = _adapptrConfig.RefinitivConfig.Username;
            // set your password
            var refinitivPassword = _adapptrConfig.RefinitivConfig.Password;

            //Example using RestSharp (https://github.com/restsharp/RestSharp)

            //Create a client which will connect to the HTTPS endpoint with the API credentials you have been provided
            var client = new RestClient(baseUrl)
            {
                Authenticator = new HttpBasicAuthenticator(username, password)
            };

            // make the HTTP POST request with the market data provider id as route parameter
            var request = new RestRequest($"/v2/dataproviders/{refinitivId}/credentials", Method.POST);

            // add json body to the request
            request.AddJsonBody(new
            {
                Username = refinitivUsername,
                Password = refinitivPassword
            });

            var response = client.Execute(request);

            // if response comes back with a 200 status, then credentials were received successfully
            if ((response.StatusCode != HttpStatusCode.OK))
            {
                throw new Exception("Failed to send file. Received a HTTP " + (int)response.StatusCode + " " + response.StatusCode + " instead of HTTP 200 OK");
            }

            // success
        }
    }
}
