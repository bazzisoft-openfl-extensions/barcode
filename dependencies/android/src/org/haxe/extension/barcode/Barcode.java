package org.haxe.extension.barcode;

import org.haxe.extension.extensionkit.MobileDevice;
import org.haxe.extension.extensionkit.HaxeCallback;
import org.haxe.extension.extensionkit.Trace;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;


public class Barcode extends org.haxe.extension.Extension 
{
    public static boolean ScanBarcode()
    {
        MobileDevice.DisableBackButton();
        IntentIntegrator integrator = new IntentIntegrator(mainActivity);
        return integrator.initiateScan();
    }    
    
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data)
    {
        IntentResult scanResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (scanResult != null) 
        {
            Trace.Info("Barcode scan complete.");
            Trace.Info(scanResult.getFormatName());
            Trace.Info(scanResult.getContents());
            
            HaxeCallback.DispatchEventToHaxe("barcode.event.BarcodeScannedEvent",
                                             new Object[] {
                                                 "barcode_barcode_scanned", 
                                                 scanResult.getFormatName().replace('_', '-'), 
                                                 scanResult.getContents()
                                             });
        }
        else
        {
            Trace.Info("Barcode scan cancelled or failed.");
            
            HaxeCallback.DispatchEventToHaxe("barcode.event.BarcodeScannedEvent",
                    new Object[] {
                        "barcode_barcode_scan_cancelled"
                    });
        }
        
        return super.onActivityResult(requestCode, resultCode, data);
    }
         
    @Override
    public void onResume()
    {
        MobileDevice.EnableBackButton();
    }    
}