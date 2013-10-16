package com.zerooneinsights.barcode;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import android.util.Log;
import android.content.Intent;

import com.zerooneinsights.android.AndroidNativePlatform;


public class BarcodeMainActivity extends org.haxe.nme.GameActivity 
{
    public void onActivityResult(int requestCode, int resultCode, Intent intent) 
    {
        IntentResult scanResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, intent);
        if (scanResult != null) 
        {
            Log.i("trace", "Barcode scan complete");
            Log.i("trace", scanResult.getFormatName());
            Log.i("trace", scanResult.getContents());
            
            AndroidNativePlatform.CallNativeCallbackHandler("barcode.event.BarcodeScannedEvent", new String[] { "barcode_scanned", scanResult.getFormatName(), scanResult.getContents() });
        }
        else
        {
            Log.e("trace", "Barcode scan failed");      
        }
    }    
}
