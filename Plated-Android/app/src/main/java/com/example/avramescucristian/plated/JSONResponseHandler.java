package com.example.avramescucristian.plated;

import android.util.Log;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.text.ParseException;

/**
 * Created by Avramescu Cristian on 5/15/2016.
 */
public class JSONResponseHandler implements ResponseHandler<Object> {
    final static String TAG = "JSONResponseHandler";

    @Override
    public Object handleResponse(HttpResponse response)
            throws HttpResponseException, IOException {

        StatusLine statusLine = response.getStatusLine();
        HttpEntity entity = response.getEntity();

        if(statusLine.getStatusCode() >= 300){
            Log.i(TAG, "HTTP Status Code: " + statusLine.getStatusCode());
            throw new HttpResponseException(statusLine.getStatusCode(),
                    entity==null?statusLine.getReasonPhrase(): EntityUtils.toString(entity));
        }

        String data = entity==null?null:EntityUtils.toString(entity);

        try {
            return data==null?null:new JSONObject(data);
        } catch (JSONException e){
            try{
                return new JSONArray(data);
            }catch(Exception ex){
                Log.i(TAG, data);
                ex.printStackTrace();
            }
            e.printStackTrace();
        } catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}