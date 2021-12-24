using FundAppsScripts.DTOs;
using RestSharp;
using RestSharp.Authenticators;
using System;
using System.Net;
using System.Threading;

namespace FundAppsScripts.Scripts
{
    public partial class AdapptrScripts
    {
        public void GetTaskStatus(string taskId = null)
        {
            var baseUrl = _adapptrConfig.BaseUrl;
            var username = _adapptrConfig.Username;
            var password = _adapptrConfig.Password;
            // your FundApps environment name
            var clientEnvironmentSubDomain = "";
            // task id (GUID) from the uploading positions file via the POST request response
            taskId = taskId ?? "";

            //Example using RestSharp (https://github.com/restsharp/RestSharp)

            //Create a client which will connect to the HTTPS endpoint with the API credentials you have been provided
            var client = new RestClient(baseUrl)
            {
                Authenticator = new HttpBasicAuthenticator(username, password)
            };

            // make the HTTP GET request with the taskId as route parameter
            var request = new RestRequest($"/rest/api/v1/task/{taskId}/status", Method.GET);

            // add header with the rapptr environment
            request.AddHeader("X-Client-Environment", clientEnvironmentSubDomain);

            var checkStatusTimeout = DateTime.UtcNow.AddMinutes(5);

            while (DateTime.UtcNow <= checkStatusTimeout)
            {
                var response = client.Execute<TaskProfileResponse>(request);

                // if response comes back with a 200 status, then the status is retrieved successfully
                if ((response.StatusCode != HttpStatusCode.OK))
                {
                    throw new Exception("Failed to send file. Received a HTTP " + (int)response.StatusCode + " " + response.StatusCode + " instead of HTTP 200 OK");
                }

                //accepted or enriched statuses
                if (response.Data.Status.Id == 1 || response.Data.Status.Id == 2)
                {
                    // sleep for 30 seconds and try again
                    Thread.Sleep(new TimeSpan(0, 0, 30));

                    continue;
                }

                // task failed
                if (response.Data.Status.Id == 500)
                {
                    //execute logic on fail. Errors could be obtained from: response.Data.Errors which is a List<string>
                    break;
                }

                //transmitted status
                if (response.Data.Status.Id == 3)
                {
                    // logic when the status is transmitted to rapptr successfully. Maybe create another request for checking the status in rapptr using the tracking endpoint.
                    break;
                }

                throw new Exception("Unsuppored status");
            }

            // success
        }
    }
}
