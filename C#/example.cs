// Example using RestSharp (https://github.com/restsharp/RestSharp)

// Create a client which will connect to the HTTPS endpoint
// with the API credentials you have been provided
var client = new RestClient("https://[ALIAS]-api.fundapps.co")
{
  Authenticator = new HttpBasicAuthenticator([USERNAME],[PASSWORD])
};
// make the HTTP post request
var request = new RestRequest("v1/expost/check", Method.POST);
//use this line if you wish to send an XML file
request.AddParameter("text/xml", File.ReadAllText("positions.xml"), ParameterType.RequestBody);
//use this line instead of the above if you wish to send a ZIP file
//request.AddFile(null, File.ReadAllBytes("positions.zip"), "positions.zip", "application/zip");

var response = client.Execute(request);
// if response comes back with a 2xx status, then file was received successfully
if ((resp.StatusCode != HttpStatusCode.OK && resp.StatusCode != HttpStatusCode.Accepted))
{
   throw new Exception("Failed to send file. Received a HTTP " + (int)resp.StatusCode + " " + resp.StatusCode + " instead of HTTP 200 OK");
}
// successfully sent file to FundApps
