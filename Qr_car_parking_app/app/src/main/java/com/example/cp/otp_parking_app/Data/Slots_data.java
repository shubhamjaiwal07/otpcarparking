package com.example.cp.otp_parking_app.Data;

import java.util.ArrayList;

public class Slots_data {

    public static ArrayList<String> slotId;
    public static ArrayList<String> slotNo;
    public static ArrayList<String> slotUrl;

    public static ArrayList<String> getSlotUrl() {
        return slotUrl;
    }

    public static void setSlotUrl(ArrayList<String> slotUrl) {
        Slots_data.slotUrl = slotUrl;
    }

    public static ArrayList<String> getSlotId()
    {
        return slotId;
    }
    public static void setSlotId(ArrayList<String> slotId1)
    {
        slotId=slotId1;
    }

    public static ArrayList<String> getSlotNo()
    {
        return slotNo;
    }
    public static void setSlotNo(ArrayList<String> slotNo1)
    {
        slotNo=slotNo1;
    }

}
