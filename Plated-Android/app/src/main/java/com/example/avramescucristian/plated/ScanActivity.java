package com.example.avramescucristian.plated;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Avramescu Cristian on 5/14/2016.
 */

public class ScanActivity extends Activity {

    static final String ACTION_SCAN = "com.google.zxing.client.android.SCAN";


    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.scan_activity);

    }
    //product qr code mode
    public void scanQR(View v) {
        try {
            //start the scanning activity from the com.google.zxing.client.android.SCAN intent
            Intent intent = new Intent(ACTION_SCAN);
            intent.putExtra("SCAN_MODE", "QR_CODE_MODE");
            startActivityForResult( intent, 0 );
        } catch (ActivityNotFoundException anfe) {
            //on catch, show the download dialog
            showDialog(ScanActivity.this, "No Scanner Found", "Download a scanner code activity?", "Yes", "No").show();
        }
    }

    //alert dialog for downloadDialog
    private static AlertDialog showDialog(final Activity act, CharSequence title, CharSequence message, CharSequence buttonYes, CharSequence buttonNo) {
        AlertDialog.Builder downloadDialog = new AlertDialog.Builder(act);
        downloadDialog.setTitle(title);
        downloadDialog.setMessage(message);
        downloadDialog.setPositiveButton(buttonYes, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogInterface, int i) {
                Uri uri = Uri.parse("market://search?q=pname:" + "com.google.zxing.client.android");
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                try {
                    act.startActivity(intent);
                } catch (ActivityNotFoundException anfe) {

                }
            }
        });
        downloadDialog.setNegativeButton(buttonNo, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogInterface, int i) {
            }
        });
        return downloadDialog.show();
    }

    //on ActivityResult method
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == 0) {
            if (resultCode == RESULT_OK) {
                //get the extras that are returned from the intent
                String contents = intent.getStringExtra("SCAN_RESULT");
                String format = intent.getStringExtra("SCAN_RESULT_FORMAT");
                // http://192.168.0.163:8080/checkqr/ +contents
                new JsonTask().execute("http://www.990.ro/seriale2-10103-30877-Game-of-Thrones-Home-online.html");
                // Toast toast = Toast.makeText(this, "Content:" + contents + " Format:" + format, Toast.LENGTH_LONG);
                //toast.show();
            }
        }
    }

    //private GoogleApiClient client2;
    HttpURLConnection connection = null;
    BufferedReader reader = null;
    String line = "";

    public class JsonTask extends AsyncTask<String, String, String> implements com.example.avramescucristian.plated.JsonTask {

        @Override
        protected String doInBackground(String... params) {
            try {
                URL url = new URL(params[0]);
                connection = (HttpURLConnection) url.openConnection();
                connection.connect();

                InputStream stream = connection.getInputStream();

                reader = new BufferedReader(new InputStreamReader(stream));

                StringBuffer buffer = new StringBuffer();

                String stare = "";

                //while ((stare = reader.readLine()) != null) buffer.append(stare);


                return buffer.append(reader.readLine()).toString();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (reader != null) try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return null;
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            LinearLayout color= (LinearLayout) findViewById(R.id.scab);

            if( 1 == 1 ) {

                Intent menuActivity = new Intent ( ScanActivity.this , Menu1.class);
                startActivity( menuActivity );
                Toast.makeText(getBaseContext(), "You are good to enter", Toast.LENGTH_LONG).show();

            }
            else
            {
                Toast.makeText(getBaseContext(), "The device must be connected to the network." ,Toast.LENGTH_LONG).show();
            }
        }
    }
}

