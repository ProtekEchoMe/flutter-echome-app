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
public class ChannelFlutter implements FlutterPlugin{

  /**
   * Plugin registration.
   */

  private String TAG = "ChannelFlutter";
  private FlutterPluginBinding flutterPluginBinding;

  ChannelFlutter(FlutterPluginBinding flutterPluginBinding){
      this.flutterPluginBinding = flutterPluginBinding;
      init(this.flutterPluginBinding);
  }

//    ChannelFlutter(){
////        init(this.flutterPluginBinding);
//    }

  private static final String CHANNEL_PREFIX = "com.protek/zebrarfd8500plugin/";
    private static final HashMap<String, String> channelNameMap = new HashMap<String, String>(){{
        put("ReaderListChannel", CHANNEL_PREFIX + "READER_LIST_CHANNEL_NAME");
        put("ConnectionStatusChannel", CHANNEL_PREFIX + "READER_CONNECTION_STATUS_CHANNEL");
        put("RfidDataChannel", CHANNEL_PREFIX + "READER_RFID_DATA_CHANNEL");
        put("RfidLocatingDataChannel", CHANNEL_PREFIX + "READER_RFID_LOCATING_DATA_CHANNEL");
    }};

    private static HashMap<String, EventChannel> channelMap = new HashMap<String, EventChannel>();
    private static HashMap<String, StreamHandlerImpl> channelHandlerMap = new HashMap<String, StreamHandlerImpl>();

    private void init(@NonNull FlutterPluginBinding flutterPluginBinding){
        Log.d(TAG, "init channelNameMap: start" );
        Log.d(TAG, channelHandlerMap.toString());
        channelNameMap.forEach(
                (key, value)
                        -> {
                    System.out.println(key + " = " + value);
                    StreamHandlerImpl streamHandler = new StreamHandlerImpl(value);
                    EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), value);
                    eventChannel.setStreamHandler(streamHandler);
                    channelMap.put(key, eventChannel);
                    channelHandlerMap.put(key, streamHandler);
                });
        Log.d(TAG, "init channelNameMap: end" );
    }

    public void sendMsg(Object o, String channelKey){
        Log.d(TAG, "sendMsg: " + channelKey);
        StreamHandlerImpl channelHandler = channelHandlerMap.get(channelKey);
        Log.d(TAG, "channelHandlerMap: " + channelHandlerMap.get(channelKey));
        if (channelHandler.sink != null) {
            channelHandler.sink.success(o);
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine");
        init(flutterPluginBinding);
        Log.d(TAG, "init end");
//        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zebra_rfd8500/plugin");
//        channel.setMethodCallHandler(this);
//        context = flutterPluginBinding.getApplicationContext();
//
//        // old one
//        rfidHandlerHelper = new RFIDHandlerHelper(context, this);
        Log.d(TAG, "onAttachedToEngine end");
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
//        channel.setMethodCallHandler(null);
//        eventChannel.setStreamHandler(null);
    }

}
