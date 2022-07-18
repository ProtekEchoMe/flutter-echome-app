package com.protek.rfid.zebra_rfd8500;

import com.zebra.rfid.api3.InvalidUsageException;
import com.zebra.rfid.api3.OperationFailureException;
import com.zebra.rfid.api3.RFIDReader;
import com.zebra.rfid.api3.TagData;

public class RFIDHandleTagData implements RFIDHandlerHelper.ResponseHandlerInterface {
    RFIDHandlerHelper rfidHandlerHelper;

    RFIDHandleTagData(RFIDHandlerHelper helper){
        this.rfidHandlerHelper = helper;
    }


    @Override
    public void handleTagData(TagData[] tagData) {
        final StringBuilder sb = new StringBuilder();
        for (int index = 0; index < tagData.length; index++) {
            sb.append(tagData[index].getTagID() + "\n");
        }
    }

    @Override
    public void handleTriggerPress(boolean pressed) {
        if (pressed) {
           // pressed -> performInv
            performInventory();
        } else {
            // pressed -> stopInv
            stopInventory();
        }
    }

    synchronized void performInventory() {
        // check reader connection
        if (!rfidHandlerHelper.isReaderConnected())
            return;
        try {
            rfidHandlerHelper.reader.Actions.Inventory.perform();
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        }
    }

    synchronized void stopInventory() {
        // check reader connection
        if (!rfidHandlerHelper.isReaderConnected())
            return;
        try {
            rfidHandlerHelper.reader.Actions.Inventory.stop();
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        }
    }

    synchronized void performTagLocating(String locateTag) {
        // check reader connection
        if (!rfidHandlerHelper.isReaderConnected())
            return;
        try {
            rfidHandlerHelper.reader.Actions.TagLocationing.Perform(locateTag, null, null);
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        }
    }

    synchronized void stopTagLocating(String locateTag) {
        // check reader connection
        if (!rfidHandlerHelper.isReaderConnected())
            return;
        try {
            rfidHandlerHelper.reader.Actions.TagLocationing.Stop();
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        }
    }

    synchronized void stopTagLocating() {
        // check reader connection
        if (!rfidHandlerHelper.isReaderConnected())
            return;
        try {
            rfidHandlerHelper.reader.Actions.Inventory.stop();
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        }
    }
}
