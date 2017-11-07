// Example using request (https://github.com/request/request)

const request = require('request');
const fs = require('fs');

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
      'X-ContentName': [POSITIONS FILE NAME],
      // use this line to define the file type. e.g. 'text/xml', 'application/zip'
      'Content-Type': [POSITIONS FILE TYPE],
    },
    // connect to the HTTPS endpoint with the API credentials you have been provided
    uri: 'https://[ALIAS]-api.fundapps.co/v1/expost/check',
    method: 'POST',
    body: data,
    auth: {
      user: [USERNAME],
      pass: [PASSWORD],
      sendImmediately: false,
    },
  };
}

function sendFile(data) {
  request(requestOptions(data), logResult);
}

fs.readFile([POSITIONS FILE], (error, data) => {
  if (error == null) {
    sendFile(data);
  } else {
    console.log(error);
  }
});
