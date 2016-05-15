package com.example.avramescucristian.plated;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Window;
import android.widget.TabHost;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        TextView txtV = (TextView) findViewById(R.id.tvTitle);
        Typeface face=Typeface.createFromAsset(getAssets(),"fonts/nanum_regular.ttf");
        txtV.setTypeface(face);

        Handler handler = new Handler();
        handler.postDelayed(new Runnable(){
            @Override
            public void run(){
                Intent login_intent = new Intent(MainActivity.this, Login.class);
                startActivity( login_intent );
            }
        }, 3000);
   }
}
