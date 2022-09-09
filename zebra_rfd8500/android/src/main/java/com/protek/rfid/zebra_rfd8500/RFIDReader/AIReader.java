package com.protek.rfid.zebra_rfd8500.RFIDReader;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.exception.ConfigurationException;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

import com.protek.rfid.zebra_rfd8500.tools.StringUtils;
import com.protek.rfid.zebra_rfd8500.ZebraRfd8500Plugin;

public class AIReader extends rfidReader{
    String TAG = "aiReader";
    private boolean loopFlag = false;
    private boolean playSound = false;
    private Handler handler;
    private HashMap<String, String> map;
    private ArrayList<HashMap<String, String>> tagList = new ArrayList<HashMap<String, String>>();

    private RFIDWithUHFUART mReader;
    private ZebraRfd8500Plugin plugin;

    public AIReader(RFIDWithUHFUART reader, ZebraRfd8500Plugin plugin) throws ConfigurationException {
        super();
        this.mReader = reader;
        this.plugin = plugin;
        init();
    }

    void init(){
        handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                String result = msg.obj + "";
                String[] strs = result.split("@");
                addEPCToList(strs[0], strs[1]);
                //mContext.playSound(1);
                playSound = true;
            }
        };
    }



    @Override
    public boolean connect() {
        try {
            mReader = RFIDWithUHFUART.getInstance();
        } catch (Exception ex) {

            toastMessage(ex.getMessage());
            return false;
        }

        if (mReader != null) {
            new InitTask().execute();
        }

        return true;
    }

    @Override
    public boolean disconnect() {
        if (mReader != null) {
            mReader.free();
        }
        return true;
    }

    @Override
    public boolean startInventory() {
        Log.d(TAG, "AIReader startInventory called");
        if (mReader.startInventoryTag()) {
            Log.d(TAG, "AIReader startInventory success");
            loopFlag = true;
            new TagThread().start();
            new PlaySoundThread().start();
        } else {
            Log.d(TAG, "AIReader startInventory fail");
            mReader.stopInventory();
            toastMessage("stopInverntory");
//            UIHelper.ToastMessage(mContext, R.string.uhf_msg_inventory_open_fail);
//					mContext.playSound(2);
        }
        return true;
    }

    @Override
    public boolean stopInventroy() {
        if (loopFlag) {
            loopFlag = false;
//            setViewEnabled(true);
            if (mReader.stopInventory()) {
//                BtInventory.setText(mContext.getString(R.string.btInventory));
                toastMessage("Stop successfully");
            } else {
                toastMessage("Stop failure");
//                UIHelper.ToastMessage(mContext, R.string.uhf_msg_inventory_stop_fail);
            }
        }
        return false;
    }

    @Override
    public String readSingleTag() {
        return "";
    }

    public ArrayList<HashMap<String, String>> getTagList() {
        return tagList;
    }

    @Override
    public boolean setPower(int power) {

        if (mReader.setPower(power)){
            return true;
        }
        return false;
    }

    @Override
    public int getPower() {
        return mReader.getPower();
    }

    @Override
    public boolean performTagLocating() {
        return false;
    }

    @Override
    public boolean stopTagLocating() {
        return false;
    }

    public void toastMessage(String msg) {
        Log.d(TAG, msg);;
    }

    public class InitTask extends AsyncTask<String, Integer, Boolean> {
//        ProgressDialog mypDialog;

        @Override
        protected Boolean doInBackground(String... params) {
            // TODO Auto-generated method stub
            return mReader.init();
        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);

//            mypDialog.cancel();

            if (!result) {
                toastMessage("init fail");
            }
        }
    }

    private class TagThread extends Thread {
        public void run() {
            String strTid;
            String strResult;
            UHFTAGInfo res = null;
//            Set<String> arrayList = new Has<String>();
            HashSet<String> arraySet = new HashSet<>();
            while (loopFlag) {
                res = mReader.readTagFromBuffer();
                if (res != null) {
                    strTid = res.getTid();
                    if (strTid.length() != 0 && !strTid.equals("0000000" + "000000000") && !strTid.equals("000000000000000000000000")) {
                        strResult = "TID:" + strTid + "\n";
                    } else {
                        strResult = "";
                    }
                    Log.i(TAG, "EPC:" + res.getEPC() + "|" + strResult);
                    Message msg = handler.obtainMessage();
                    msg.obj = strResult + "EPC:" + res.getEPC() + "@" + res.getRssi();
                    handler.sendMessage(msg);


//                    arraySet.add(res.getEPC());
//                    plugin.notifyRfidData(arrayList);

                    UHFTAGInfo finalRes = res;
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            ArrayList<String> mainList = new ArrayList<String>(){{
                                add(finalRes.getEPC());
                            }};
//                            mainList.addAll(arraySet);
                            plugin.notifyRfidData(mainList);
                        }
                    });

                } else {
                    try {
                        Thread.sleep(1);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    class PlaySoundThread extends Thread {

        public void run() {
            while (loopFlag) {
                if (playSound) {
//                    mContext.playSound(1);
                    playSound = false;
                }

                try {
                    Thread.sleep(50);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void addEPCToList(String epc, String rssi) {
        if (!TextUtils.isEmpty(epc)) {
            int index = checkIsExist(epc);

            map = new HashMap<String, String>();

            map.put("tagUii", epc);
            map.put("tagCount", String.valueOf(1));
            map.put("tagRssi", rssi);

            // mContext.getAppContext().uhfQueue.offer(epc + "\t 1");

            if (index == -1) {
                tagList.add(map);
//                LvTags.setAdapter(adapter);
//                tv_count.setText("" + adapter.getCount());
            } else {
                int tagcount = Integer.parseInt(tagList.get(index).get("tagCount"), 10) + 1;

                map.put("tagCount", String.valueOf(tagcount));
                tagList.set(index, map);
            }

//            tv_total.setText(String.valueOf(++total));
//            adapter.notifyDataSetChanged();
        }
    }

    public int checkIsExist(String strEPC) {
        int existFlag = -1;
        if (StringUtils.isEmpty(strEPC)) {
            return existFlag;
        }
        String tempStr = "";
        for (int i = 0; i < tagList.size(); i++) {
            HashMap<String, String> temp = new HashMap<String, String>();
            temp = tagList.get(i);
            tempStr = temp.get("tagUii");
            if (strEPC.equals(tempStr)) {
                existFlag = i;
                break;
            }
        }
        return existFlag;
    }
}
