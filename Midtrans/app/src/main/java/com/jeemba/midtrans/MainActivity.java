package com.jeemba.midtrans;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback;
import com.midtrans.sdk.corekit.core.themes.CustomColorTheme;
import com.midtrans.sdk.corekit.models.snap.TransactionResult;
import com.midtrans.sdk.uikit.SdkUIFlowBuilder;

import static com.midtrans.sdk.corekit.BuildConfig.BASE_URL;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    void initMidtrans(){
        SdkUIFlowBuilder.init()
                .setClientKey("SB-Mid-client-_8ALJntlkHbHBZJG") // client_key is mandatory
                .setContext(this) // context is mandatory
                .setTransactionFinishedCallback(new TransactionFinishedCallback() {
                    @Override
                    public void onTransactionFinished(TransactionResult result) {
                        // Handle finished transaction here.
                    }
                }) // set transaction finish callback (sdk callback)
                .setMerchantBaseUrl(BASE_URL) //set merchant url (required)
                .enableLog(true) // enable sdk log (optional)
                .setColorTheme(new CustomColorTheme("#FFE51255", "#B61548", "#FFE51255")) // set theme. it will replace theme on snap theme on MAP ( optional)
                .buildSDK();
    }
}
