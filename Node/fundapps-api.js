// Example using request (https://github.com/request/request)

const request = require('request');
const fs = require('fs');

const fileName = 'Transactions.csv'
const username = '';
const password = '';
const url = 'https://demo-diamonds-api.fundapps.co/v1/transactions/import';
const fileNameHeader = 'Transactions.csv';
const contentTypeHeader = 'text/csv';
const authHeader = 'Basic '+ btoa(`${username}:${password}`);

// if response comes back with a 2xx status, then file was received successfully
function logResult(error, response, body) {
  console.log(error);
  console.log(response.statusCode);
  console.log(response.headers['content-type']);
  console.log(body);
}

function requestOptions(data) {
  return {
    headers: {
      // use this line to specify a name for the uploaded file
      'X-ContentName': fileNameHeader,
      // use this line to define the file type. e.g. 'text/xml', 'application/zip'
      'Content-Type': contentTypeHeader,
      'Authorization': authHeader
    },
    // connect to the HTTPS endpoint with the API credentials you have been provided
    uri: url,
    method: 'POST',
    body: data,
  };
}

function sendFile(data) {
  request(requestOptions(data), logResult);
}

fs.readFile(fileName, (error, data) => {
  if (error == null) {
    sendFile(data);
  } else {
    console.log(error);
  }
});
