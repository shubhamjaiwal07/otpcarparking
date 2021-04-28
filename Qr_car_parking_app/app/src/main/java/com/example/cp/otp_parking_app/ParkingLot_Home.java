package com.example.cp.otp_parking_app;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.chaos.view.PinView;
import com.example.cp.otp_parking_app.Connection.ConnectionM;
import com.example.cp.otp_parking_app.Connection.Progressdialog;
import com.example.cp.otp_parking_app.Data.CustomerDetails;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

public class ParkingLot_Home extends AppCompatActivity {

    public static String re;
    Dialog dg;
    int resp;
    int otpResp;
    PinView pinView;
    Button btnOtp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_parking_lot__home);

        pinView = findViewById(R.id.pinView);
        btnOtp = findViewById(R.id.btnOtp);

        btnOtp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                final String otp = pinView.getText().toString();

                if (otp.equals(""))
                    Toast.makeText(getApplicationContext(),"Please enter OTP",Toast.LENGTH_LONG).show();
                else if(!ConnectionM.checkNetworkAvailable(ParkingLot_Home.this))
                    Toast.makeText(ParkingLot_Home.this, "Sorry no network access.", Toast.LENGTH_LONG).show();
                else {
                    final ConnectionM conn = new ConnectionM();
                    Progressdialog dialog = new Progressdialog();
                    dg = dialog.createDialog(ParkingLot_Home.this);
                    dg.show();
                    Thread th1 = new Thread() {
                        @Override
                        public void run() {
                            try {
                                otpResp = Integer.valueOf(conn.checkParkingOtp(otp));
                            } catch (Exception e) {
                                Toast.makeText(ParkingLot_Home.this, e.toString(), Toast.LENGTH_LONG).show();
                            }
                            hd1.sendEmptyMessage(0);
                        }
                    };
                    th1.start();
                }


//                final ConnectionM conn = new ConnectionM();
//                if (ConnectionM.checkNetworkAvailable(ParkingLot_Home.this)) {
//                    Progressdialog dialog = new Progressdialog();
//                    dg = dialog.createDialog(ParkingLot_Home.this);
//                    dg.show();
//                    Thread th1 = new Thread() {
//                        @Override
//                        public void run() {
//                            try {
//                                if (conn.checkBooking(re)) {
//                                    resp = 0;
//                                } else {
//                                    resp = 1;
//                                }
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                            }
//                            hd.sendEmptyMessage(0);
//                        }
//                    };
//                    th1.start();
//                } else {
//                    Toast.makeText(this, "Sorry no network access.", Toast.LENGTH_LONG).show();
//                }

            }
        });
    }

    public Handler hd1 = new Handler() {
        public void handleMessage(Message msg) {
            dg.cancel();
            switch (otpResp) {
                case 2:
                    getBookingInfo(CustomerDetails.getBookingId());
                    //Toast.makeText(getApplicationContext(),CustomerDetails.getBookingId(),Toast.LENGTH_LONG).show();
                    break;
                case 1:
                    Toast.makeText(getApplicationContext(), "Something went wrong", Toast.LENGTH_LONG).show();
                    break;
            }
        }
    };

    private void getBookingInfo(final String booking_id)
    {
        final ConnectionM conn = new ConnectionM();
        if (ConnectionM.checkNetworkAvailable(this)) {
            Progressdialog dialog = new Progressdialog();
            dg = dialog.createDialog(this);
            dg.show();
            Thread th1 = new Thread() {
                @Override
                public void run() {
                    try {
                        if (conn.checkBooking(booking_id)) {
                            resp = 0;
                        } else {
                            resp = 1;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    hd.sendEmptyMessage(0);
                }
            };
            th1.start();
        } else {
            Toast.makeText(this, "Sorry no network access.", Toast.LENGTH_LONG).show();
        }
    }

//    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
//
//        IntentResult scanResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, intent);
//        if (scanResult != null && resultCode == RESULT_OK) {
//            re = scanResult.getContents();
//
//            final ConnectionM conn = new ConnectionM();
//            if (ConnectionM.checkNetworkAvailable(this)) {
//                Progressdialog dialog = new Progressdialog();
//                dg = dialog.createDialog(this);
//                dg.show();
//                Thread th1 = new Thread() {
//                    @Override
//                    public void run() {
//                        try {
//                            if (conn.checkBooking(re)) {
//                                resp = 0;
//                            } else {
//                                resp = 1;
//                            }
//                        } catch (Exception e) {
//                            e.printStackTrace();
//                        }
//                        hd.sendEmptyMessage(0);
//                    }
//                };
//                th1.start();
//            } else {
//                Toast.makeText(this, "Sorry no network access.", Toast.LENGTH_LONG).show();
//            }
//            Log.d("code", re);
//
//        }
//        // else continue with any other code you need in the method
//        else if (resultCode == RESULT_CANCELED) {
//            String a = "kfredfhyeru";
//        }
//    }

    public Handler hd = new Handler() {
        public void handleMessage(Message msg) {
            dg.cancel();
            switch (resp) {
                case 0:
                    if (CustomerDetails.getSt() == 0) {
                        Toast.makeText(ParkingLot_Home.this,"Slot Allocated",Toast.LENGTH_LONG).show();
                        Intent intent = new Intent(ParkingLot_Home.this, PLViewDetails.class);
                        startActivity(intent);
                    } else if (CustomerDetails.getSt() == 1) {
                        Toast.makeText(ParkingLot_Home.this, "Amount is deducted from account", Toast.LENGTH_SHORT).show();
                    }
                    break;

                case 1:
                    Toast.makeText(getApplicationContext(), "Invalid Parking Details", Toast.LENGTH_LONG).show();
                    break;
            }
        }
    };


    @Override
    public void onBackPressed() {
        logout();
    }

    public void logout() {
        new android.support.v7.app.AlertDialog.Builder(ParkingLot_Home.this)
                .setIcon(R.drawable.alert)
                .setTitle("ParkingWale")
                .setMessage("Are you sure you want logout?")
                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Intent intent = new Intent(ParkingLot_Home.this,ParkingLotLogin.class);

                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                        finish();
                    }

                })
                .setNegativeButton("No", null)
                .show();
    }

}
