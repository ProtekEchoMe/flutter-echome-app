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
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ZebraRfd8500Plugin */
public class ZebraRfd8500Plugin implements FlutterPlugin, ActivityAware, MethodCallHandler, EventChannel.StreamHandler {

  private MethodChannel channel;
  private EventChannel eventChannel;
  private static Readers readers;
  private Context context;
  private Lifecycle lifecycle;
  private RFIDHandler rfidHandler;
  private PluginLifecycleObserver pluginLifecycleObserver;
  private EventChannel.EventSink sink = null;

  private String TAG = "ZebraRfd8500Plugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine");
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zebra_rfd8500/plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "zebra_rfd8500/event_channel");
    eventChannel.setStreamHandler(this);

    readers = new Readers(context, ENUM_TRANSPORT.ALL);
    rfidHandler = new RFIDHandler(readers, context);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d(TAG, "OnMethodCall");
    Log.d(TAG, call.method);
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
        String hostName = call.arguments.toString();
        rfidHandler.connectRFIDReader(hostName, result);
        break;
      case "setAntennaPower":
        Integer power = Integer.parseInt(call.arguments.toString());
        Log.d(TAG, power.toString());
        try {
          rfidHandler.setAntennaPower(power);
          result.success("");
        } catch (InvalidUsageException e) {
          e.printStackTrace();
          result.error("","","");
        } catch (OperationFailureException e) {
          e.printStackTrace();
          result.error("","","");
        }
        break;
      case "getConnectedScannerInfo":
        Log.d(TAG, "getConnectedScannerInfo");
        try {
          rfidHandler.getConnectedScannerInfo(result);
        } catch (InvalidUsageException e) {
          e.printStackTrace();
        } catch (OperationFailureException e) {
          e.printStackTrace();
        }
        break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.d(TAG, "onDetachedFromEngine");
    channel.setMethodCallHandler(null);
    eventChannel.setStreamHandler(null);
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

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    Log.d(TAG, "onListen");
    sink = events;
    rfidHandler.setEventSink(sink);
  }

  @Override
  public void onCancel(Object arguments) {
    rfidHandler.setEventSink(null);
    sink = null;
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
      if(sink != null){
        sink.success("onResume");
      }
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
