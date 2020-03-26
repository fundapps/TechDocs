package co.fundapps.examples;

import org.apache.hc.client5.http.fluent.Executor;
import org.apache.hc.client5.http.fluent.Request;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpResponse;
import org.apache.hc.core5.http.HttpStatus;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Simple example uses Apache Http Client Fluent API to handle basic authentication and post a pre-existing XML
 * document to the FundApps API
 */
public class UploadPositionFile {

    // replace with your company name
    public static final String CLIENT = "";
    // replace with your username
    public static final String USERNAME = "";
    // replace with your password
    public static final String PASSWORD = "";

    public static void main(String[] args) throws URISyntaxException, IOException {
        String endpoint = String.format("https://%s-api.fundapps.co/v1/expost/check", CLIENT);
        HttpHost fundAppsHost = HttpHost.create(String.format("https://%s-api.fundapps.co", CLIENT));

        Request postPositions = Request.post(endpoint).bodyFile(new File("positions.xml"), ContentType.TEXT_XML);
        Executor executor = Executor.newInstance().auth(fundAppsHost, USERNAME, PASSWORD.toCharArray());

        // make http request
        HttpResponse response = executor.execute(postPositions).returnResponse();

        // check response is as expected
        if(response.getCode() == HttpStatus.SC_ACCEPTED ||response.getCode() == HttpStatus.SC_OK){
            System.out.println("File submitted");
        } else {
            System.out.printf("Error submitting file. HTTP Status Code was: %d", response.getCode());
        }

    }

}
