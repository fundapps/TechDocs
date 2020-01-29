// Example for using HttpClient (dotnet-core)

// Create a client which will connect to the HTTPS endpoint with the API credentials you have been provided
var client = new HttpClient();
var authValue = Convert.ToBase64String(Encoding.ASCII.GetBytes("[USERNAME]:[PASSWORD]"));
client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", authValue);

// make the HTTP post request body
// use these lines if you wish to send an XML file
var content = new ByteArrayContent(File.ReadAllBytes("positions.xml"));
content.Headers.Add("Content-Type", "text/xml");

// use these lines if you wish to send a zip file, and be sure to end the file name with .zip
// var content = new ByteArrayContent(File.ReadAllBytes("positions.zip"));
// content.Headers.Add("Content-Type", "application/zip");

//use this line to specify a name for the uploaded file
content.Headers.Add("X-ContentName", "positions-monday.xml");

var response = await client.PostAsync("https://[ALIAS]-api.fundapps.co/v1/expost/check", content);
// if response comes back with a 2xx status, then file was received successfully
if ((response.StatusCode != HttpStatusCode.OK && response.StatusCode != HttpStatusCode.Accepted))
{
    throw new Exception($"Failed to send file. Received a HTTP {(int) response.StatusCode} {response.StatusCode} instead of HTTP 200 OK");
}
// successfully sent file to FundApps