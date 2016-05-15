package com.example.avramescucristian.plated;

import android.app.ProgressDialog;
import android.net.http.AndroidHttpClient;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.app.ListFragment;
import android.support.v7.app.ActionBar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;


import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;

import javax.xml.transform.Result;


public class ShowProducts extends ListFragment {

    private OnFragmentInteractionListener mListener;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    private Fragment mFragment;
    private ProgressDialog pDialog;
    // Siteler ListView
    ListView sitelerLV = null;

    // siteler JSONArray
    JSONArray siteler = null;

    // Hashmap for ListView
    ArrayList<HashMap<String, String>> siteList;

    ArrayList<HashMap<Integer, String>> inboxList;
    private static final String Categories_URL = "http://mobile.itec.ligaac.ro/categories";

    private static final String TAG_ID = "id";
    private static final String TAG_DESCRIPTION = "description";
    private static final String TAG_IMG = "image_src_id";



    String apple_versions[] = new String[]{
            "SERVICII",
            "RACORITOARE",
            "MILKSHAKE",
            "CIOCOLATA CALDA",
            "VIN",
            "TIGARI",
            "LIMONADE",
            "COCKTAILS",
            "APA",
            "CAFEA",
            "CEAIURI",
            "ALCOOL",
            "BERE",
            "PREPARATE",
            "FRESH",
            "LONG DRINKS"

    };


    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(int mnuId, int Id);
    }
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getActivity().getBaseContext(), R.layout.check_list, apple_versions);


        setListAdapter(adapter);

        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onStart() {
        super.onStart();


        getListView().setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
    }

}