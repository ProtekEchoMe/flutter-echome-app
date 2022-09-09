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
  private ChannelFlutter channelFlutter;

  private void init(@NonNull FlutterPluginBinding flutterPluginBinding){
    channelFlutter = new ChannelFlutter(flutterPluginBinding);
  }


  private MethodChannel channel;
  private EventChannel eventChannel;
  private static Readers readers;
  private Context context;
  private Lifecycle lifecycle;
  private RFIDHandler rfidHandler;
  private RFIDHandlerHelper rfidHandlerHelper;
  private RFIDReaderController rfidReaderController;

  private RFIDControllerInterface controllerInterface;
  private PluginLifecycleObserver pluginLifecycleObserver;
  private EventChannel.EventSink sink = null;

  private String TAG = "ZebraRfd8500Plugin";



  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine");
    init(flutterPluginBinding);
    Log.d(TAG, "init end");
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zebra_rfd8500/plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    rfidReaderController = new RFIDReaderController(context, this);
    rfidHandlerHelper = new RFIDHandlerHelper(context, this);
    controllerInterface = rfidReaderController;
    Log.d(TAG, "onAttachedToEngine end");
  }


  public void notifyReaderConnectionStatus(boolean isConnect, String readerName){
      ArrayList<String> list = new ArrayList<>();
      list.add(isConnect?"1":"0");
      list.add(readerName);
//      readerConnectionStatusHandler.sink.success(list);
      channelFlutter.sendMsg(list, "ConnectionStatusChannel");

  }

  public void notifyReaderListChange(boolean isAppear, String readerName){
      ArrayList<String> list = new ArrayList<>();
      list.add(isAppear?"1":"0");
      list.add(readerName);
      channelFlutter.sendMsg(list, "ReaderListChannel");
//      readerListChannelHandler.sink.success(list);

  }

  public void notifyRfidData(ArrayList<String> arrayList){
      channelFlutter.sendMsg(arrayList, "RfidDataChannel");
    }


  public void notifyRfidLocatingData(ArrayList<String> arrayList){
      channelFlutter.sendMsg(arrayList, "RfidLocatingDataChannel");
//      readerRfidLocatingDataChannelHandler.sink.success(arrayList);
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
      case "debug":
        Log.d(TAG, "debug method Call");
        ArrayList<String> arrayList = new ArrayList<String>();
        arrayList.add("5341544c303130303030303439363938");
        notifyRfidData(arrayList);
//        sendMsg(arrayList, "RfidDataChannel");
        break;
      case "aiReaderConnect":
        boolean connectResult = rfidReaderController.connectToScanner();
        if (connectResult){
          controllerInterface = rfidReaderController;
        }
        Log.d(TAG, "aiReaderConnect method Call");
        break;
      case "startInventory":
        Log.d(TAG, "startInventory method Call");
        controllerInterface.startInventory();
        break;
      case "stopInventory":
        Log.d(TAG, "stopInventory method Call");
        controllerInterface.stopInventory();
        break;
      case "aiReaderDisconnect":
        Log.d(TAG, "aiReaderDisconnect method Call");
        controllerInterface.disconnectToScanner();
        break;



      case "performTagLocating":

        String rfid = call.argument("rfid");
        Log.d(TAG, "performTagLocating rfid Param: " + rfid);
        String world = controllerInterface.performTagLocating(rfid);
        result.success("Hello " + world);
        break;
      case "stopTagLocating":
        String stopworld = controllerInterface.stopTagLocating();
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
        boolean zebraConnectResult = rfidHandlerHelper.connectToScanner(hostName);
        if (zebraConnectResult){
          controllerInterface = rfidHandlerHelper;
        }
        result.success("Successful called connectToScanner,listene to get the readerConnectionStatusHandler sink for result");
        break;
      case "setAntennaPower":
        Integer power = Integer.parseInt(call.arguments.toString());
        Log.d(TAG, "setAntennaPower is called and its params");
        Log.d(TAG, power.toString());
        try {
          controllerInterface.setAntennaPower(power);
          result.success("");
        } catch (Exception e) {
          e.printStackTrace();
          result.error("","","");
        }
        break;
      case "getAntennaPower":
        Log.d(TAG, "getAntennaPower Java Plugin is called");
        int antennaPowerList = controllerInterface.getAntennaPower();
        Log.d(TAG, "getAntennaPowerListSuccess");
        result.success(antennaPowerList);
        break;
      case "getConnectedScannerInfo":
        Log.d(TAG, "getConnectedScannerInfoMixson");
        HashMap<String, String> resultHashMap = controllerInterface.getConnectedScannerInfo();
        result.success(resultHashMap);

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
