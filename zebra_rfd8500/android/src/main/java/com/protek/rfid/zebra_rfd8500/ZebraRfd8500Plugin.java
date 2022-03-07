package com.protek.rfid.zebra_rfd8500;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import com.zebra.rfid.api3.*;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ZebraRfd8500Plugin */
public class ZebraRfd8500Plugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

  private MethodChannel channel;
  private static Readers readers;
  private Context context;
  private Lifecycle lifecycle;
  private RFIDHandler rfidHandler;
  private PluginLifecycleObserver pluginLifecycleObserver;

  private String TAG = "ZebraRfd8500Plugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zebra_rfd8500");
    channel.setMethodCallHandler(this);
    readers = new Readers();
    rfidHandler = new RFIDHandler(readers);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "getAvailableRFIDReaderList":
        try{
          ArrayList<String> readerList = rfidHandler.getAvailableRFIDReaderList();
          result.success(readerList);
          break;
        }catch(Exception e){
          result.error("UNAVAILABLE", "Reader list not available.", null);
          break;
        }
      case "connectRFIDReader":
        String hostName = call.argument("hostName");

      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull @NotNull ActivityPluginBinding binding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    pluginLifecycleObserver = new PluginLifecycleObserver();
    lifecycle.addObserver(pluginLifecycleObserver);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull @NotNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  public class PluginLifecycleObserver implements DefaultLifecycleObserver {
    private static final String TAG = "PluginLifecycleObserver";

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
      Log.d(TAG,"onCreate()");

    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
      Log.d(TAG,"onStart()");

    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
      Log.d(TAG,"onResume()");

    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
      Log.d(TAG,"onPause()");

    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
      Log.d(TAG,"onStop()");

    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
      Log.d(TAG,"onDestroy() ");

    }

  }


}
