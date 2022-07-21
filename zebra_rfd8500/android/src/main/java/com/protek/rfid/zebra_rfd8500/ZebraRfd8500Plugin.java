package com.protek.rfid.zebra_rfd8500;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import com.zebra.rfid.api3.*;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;

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
public class ZebraRfd8500Plugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

  /**
   * Plugin registration.
   */
  private static final String READER_LIST_CHANNEL_NAME = "com.protek/zebrarfd8500plugin/READER_LIST_CHANNEL_NAME"; // send available read list -> flutter
  private static final String READER_CONNECTION_STATUS_CHANNEL = "com.protek/zebrarfd8500plugin/READER_CONNECTION_STATUS_CHANNEL"; // send read connection activity -> flutter
  private static final String READER_RFID_DATA_CHANNEL = "com.protek/zebrarfd8500plugin/READER_RFID_DATA_CHANNEL"; // send rfid data -> flutter

  private static final String READER_RFID_LOCATING_DATA_CHANNEL = "com.protek/zebrarfd8500plugin/READER_RFID_LOCATING_DATA_CHANNEL"; // send rfid locating data -> flutter



  private EventChannel readerListChannel;
  private EventChannel readerConnectionStatusChannel;
  private EventChannel readerRfidDataChannel;

  private EventChannel readerRfidLocatingDataChannel;

  private StreamHandlerImpl readerListChannelHandler = null;
  private StreamHandlerImpl readerConnectionStatusHandler = null;
  private StreamHandlerImpl readerRfidDataChannelHandler = null;

  private StreamHandlerImpl readerRfidLocatingDataChannelHandler = null;

  private MethodChannel channel;
  private EventChannel eventChannel;
  private static Readers readers;
  private Context context;
  private Lifecycle lifecycle;
  private RFIDHandler rfidHandler;
  private RFIDHandlerHelper rfidHandlerHelper;
  private PluginLifecycleObserver pluginLifecycleObserver;
  private EventChannel.EventSink sink = null;

  private String TAG = "ZebraRfd8500Plugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine");
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zebra_rfd8500/plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();

    // set the sink of Channel + set up channel to set from native -> flutter
    readerListChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), READER_LIST_CHANNEL_NAME);
    readerConnectionStatusChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), READER_CONNECTION_STATUS_CHANNEL);
    readerRfidDataChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), READER_RFID_DATA_CHANNEL);
    readerRfidLocatingDataChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), READER_RFID_LOCATING_DATA_CHANNEL);


    readerListChannelHandler = new StreamHandlerImpl(READER_LIST_CHANNEL_NAME);
    readerConnectionStatusHandler = new StreamHandlerImpl(READER_CONNECTION_STATUS_CHANNEL);
    readerRfidDataChannelHandler = new StreamHandlerImpl(READER_RFID_DATA_CHANNEL);
    readerRfidLocatingDataChannelHandler = new StreamHandlerImpl(READER_RFID_LOCATING_DATA_CHANNEL);

    readerListChannel.setStreamHandler(readerListChannelHandler);
    readerConnectionStatusChannel.setStreamHandler(readerConnectionStatusHandler);
    readerRfidDataChannel.setStreamHandler(readerRfidDataChannelHandler);
    readerRfidLocatingDataChannel.setStreamHandler(readerRfidLocatingDataChannelHandler);
    // old one
    rfidHandlerHelper = new RFIDHandlerHelper(context, this);
  }

  public void notifyReaderConnectionStatus(boolean isConnect, String readerName){
    if(readerConnectionStatusHandler.sink != null){
      ArrayList<String> list = new ArrayList<>();
      list.add(isConnect?"1":"0");
      list.add(readerName);
      readerConnectionStatusHandler.sink.success(list);
    }
  }

  public void notifyReaderListChange(boolean isAppear, String readerName){
    if(readerListChannelHandler.sink != null){
      ArrayList<String> list = new ArrayList<>();
      list.add(isAppear?"1":"0");
      list.add(readerName);
      readerListChannelHandler.sink.success(list);
    }
  }

  public void notifyRfidData(ArrayList<String> arrayList){
    if(readerRfidDataChannelHandler.sink != null){
      readerRfidDataChannelHandler.sink.success(arrayList);
    }
  }

  public void notifyRfidLocatingData(ArrayList<String> arrayList){
    if(readerRfidLocatingDataChannelHandler.sink != null){
      readerRfidLocatingDataChannelHandler.sink.success(arrayList);
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d(TAG, "OnMethodCall");
    Log.d(TAG, call.method);
    methodHandler(call, result);
  }

  private void methodHandler(@NotNull MethodCall call, @NotNull Result result) {
    switch (call.method){
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "performTagLocating":

        String rfid = call.argument("rfid");
        Log.d(TAG, "performTagLocating rfid Param: " + rfid);
        String world = rfidHandlerHelper.performTagLocating(rfid);
        result.success("Hello " + world);
        break;
      case "stopTagLocating":
        String stopworld = rfidHandlerHelper.stopTagLocating();
        result.success("stop Hello " + stopworld);
        break;
      case "getAvailableRFIDReaderList":
        try{
          Log.d(TAG, "getAvailableRFIDReaderList");
          ArrayList<String> readerList = rfidHandlerHelper.getAvailableRFIDReaderList();
          Log.d(TAG, "getListSuccess");
          result.success(readerList);
          break;
        }catch(Exception e){
          Log.d(TAG, "ERROR");
          Log.d(TAG, e.getMessage());
          result.error("1001", "Reader list not available.", null);
          break;
        }
      case "connectRFIDReader":
        String hostName = call.arguments.toString();
        rfidHandlerHelper.connectToScanner(hostName);
        result.success("Successful called connectToScanner,listene to get the readerConnectionStatusHandler sink for result");
        break;
      case "setAntennaPower":
        Integer power = Integer.parseInt(call.arguments.toString());
        Log.d(TAG, power.toString());
//        try {
//          rfidHandler.setAntennaPower(power);
//          result.success("");
//        } catch (InvalidUsageException e) {
//          e.printStackTrace();
//          result.error("","","");
//        } catch (OperationFailureException e) {
//          e.printStackTrace();
//          result.error("","","");
//        }
        break;
      case "getConnectedScannerInfo":
        Log.d(TAG, "getConnectedScannerInfoMixson");
        rfidHandler.getConnectedScannerInfo(result);
//        try {
////          rfidHandler.getConnectedScannerInfo(result);
//        } catch (InvalidUsageException e) {
//          e.printStackTrace();
//        } catch (OperationFailureException e) {
//          e.printStackTrace();
//        }
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
    lifecycle.removeObserver(pluginLifecycleObserver);
    lifecycle = null;
    pluginLifecycleObserver = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull @NotNull ActivityPluginBinding binding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    pluginLifecycleObserver = new PluginLifecycleObserver();
    lifecycle.addObserver(pluginLifecycleObserver);
  }

  @Override
  public void onDetachedFromActivity() {
    lifecycle.removeObserver(pluginLifecycleObserver);
    lifecycle = null;
    pluginLifecycleObserver = null;
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
