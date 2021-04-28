package com.example.cp.otp_parking_app;

import android.app.Dialog;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.example.cp.otp_parking_app.Connection.ConnectionM;
import com.example.cp.otp_parking_app.Connection.Progressdialog;

public class AddBalance extends AppCompatActivity {

    Dialog dg;
    int resp;

    public static String bal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_balance);



        Button btn=(Button)findViewById(R.id.btnAddBalance);
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                getBalance();
            }
        });

    }

    public void getBalance()
    {
        EditText editAc=(EditText)findViewById(R.id.editACnumber);
        EditText editBal=(EditText)findViewById(R.id.editBal);
        final String ac = editAc.getText().toString();
         bal = editBal.getText().toString();
        if (ac.equals("") || bal.equals("")) {
            Toast.makeText(this, "all fields are mandatory", Toast.LENGTH_LONG).show();
        } else {
            final ConnectionM conn = new ConnectionM();
            if (ConnectionM.checkNetworkAvailable(this)) {
                Progressdialog dialog = new Progressdialog();
                dg = dialog.createDialog(this);
                dg.show();

                Thread th1 = new Thread() {
                    @Override
                    public void run() {
                        try {
                            if (conn.getBalance(ac, bal)) {
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
    }

    public Handler hd = new Handler() {
        public void handleMessage(Message msg) {
            dg.cancel();
            switch (resp) {
                case 0:



                    Toast.makeText(AddBalance.this, "Balance Added", Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(AddBalance.this, Main_.class);
                    startActivity(intent);
                    break;

                case 1:

                     Toast.makeText(getApplicationContext(), "Invalid Account number", Toast.LENGTH_LONG).show();

                    break;
            }
        }
    };

}
