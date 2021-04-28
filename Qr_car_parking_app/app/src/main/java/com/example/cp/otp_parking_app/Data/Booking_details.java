package com.example.cp.otp_parking_app.Data;

public class Booking_details {

    public static String bookingId;

    public static String imgPath;
    public static String otp;

    public static String getImgPath() {
        return imgPath;
    }

    public static void setImgPath(String imgPath) {
        Booking_details.imgPath = imgPath;
    }

    public static String getBookingId()
    {
        return bookingId;
    }

    public static void setBookingId(String bookingId1)
    {
        bookingId=bookingId1;
    }

    public static String getOtp() {
        return otp;
    }

    public static void setOtp(String otp) {
        Booking_details.otp = otp;
    }
}
