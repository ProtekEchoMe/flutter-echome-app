package com.protek.rfid.zebra_rfd8500;

import io.flutter.Log;
import io.flutter.plugin.common.EventChannel;

public class StreamHandlerImpl implements EventChannel.StreamHandler {


    public EventChannel.EventSink sink;
    public String TAG;

    StreamHandlerImpl(String TAG){
        this.TAG = TAG;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d(TAG, "StreamHanlderImpl onListen Called, setting sink");
        sink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d(TAG, "StreamHanlderImpl onCancel Called, sink now set back to null");
        sink = null;
    }
}
