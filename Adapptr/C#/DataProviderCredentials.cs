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

        public void PostDataPrividerCredentials()
        {
            var baseUrl = _adapptrConfig.BaseUrl;
            var username = _adapptrConfig.Username;
            var password = _adapptrConfig.Password;
            // your FundApps environment name
            var clientEnvironmentSubDomain = "";

            //data providers ids can be obtained from a GET /rest/api/v1/dataproviders
            var refinitivId = _adapptrConfig.RefinitivConfig.Id;
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
            var request = new RestRequest($"/rest/api/v1/dataproviders/{refinitivId}/credentials", Method.POST);

            // add json body to the request
            request.AddJsonBody(new
            {
                Username = refinitivUsername,
                Password = refinitivPassword
            });

            // add header with the rapptr environment
            request.AddHeader("X-Client-Environment", clientEnvironmentSubDomain);

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
