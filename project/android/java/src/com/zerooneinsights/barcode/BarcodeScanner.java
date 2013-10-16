package com.zerooneinsights.barcode;

import org.haxe.nme.GameActivity;

import com.zerooneinsights.android.Utils;

import com.zerooneinsights.android.runnable.DimDeviceNavigationButtonsRunnable;
import com.zerooneinsights.android.runnable.KeepScreenOnRunnable;
import com.zerooneinsights.android.runnable.LaunchUriRunnable;
import com.zerooneinsights.android.runnable.ShowPhoneStatusBarRunnable;

import android.app.Activity;
import android.view.View;

import com.google.zxing.integration.android.IntentIntegrator;


/**
 * Provides static methods for the JNI to invoke the various native platform
 * functionality.
 */

public class BarcodeScanner
{
    public static boolean ScanBarcode()
    {
        //Utils.LogInfo("BarcodeScanner.ScanBarcode()");
        IntentIntegrator integrator = new IntentIntegrator(GameActivity.getInstance());
        return integrator.initiateScan();
    }
}
