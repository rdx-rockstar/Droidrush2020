package com.example.ShareApp;

import android.Manifest;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;
import android.app.Activity;
import android.os.Bundle;
import android.os.Environment;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;

import org.apache.ftpserver.FtpServer;
import org.apache.ftpserver.FtpServerFactory;
import org.apache.ftpserver.ftplet.Authority;
import org.apache.ftpserver.ftplet.FtpException;
import org.apache.ftpserver.ftplet.FtpReply;
import org.apache.ftpserver.ftplet.FtpRequest;
import org.apache.ftpserver.ftplet.FtpSession;
import org.apache.ftpserver.ftplet.Ftplet;
import org.apache.ftpserver.ftplet.FtpletContext;
import org.apache.ftpserver.ftplet.FtpletResult;
import org.apache.ftpserver.ftplet.UserManager;
import org.apache.ftpserver.listener.ListenerFactory;
import org.apache.ftpserver.usermanager.PropertiesUserManagerFactory;
import org.apache.ftpserver.usermanager.SaltedPasswordEncryptor;
import org.apache.ftpserver.usermanager.impl.BaseUser;
import org.apache.ftpserver.usermanager.impl.WritePermission;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * NearbyConnectionsPlugin
 */
public class FtpChannal extends FlutterActivity {
    private static MethodChannel channel;
    //variables
    static String pass="";
    static String usr="";
    final int MY_PERMISSIONS_REQUEST = 2203;
    final int REQUEST_DIRECTORY = 2108;
    static FtpServerFactory serverFactory = new FtpServerFactory();
    static ListenerFactory factory = new ListenerFactory();
    static PropertiesUserManagerFactory userManagerFactory = new PropertiesUserManagerFactory();
    static FtpServer finalServer;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "ftp")
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "test":
                                    result.success("working");
                                    break;
                                case "create":
                                    result.success(create());
                                    break;
                                case "start":
                                    usr = ""+call.argument("u");
                                    pass = ""+call.argument("p");
                                    result.success(start(usr,pass,""+call.argument("l")));
                                    break;
                                case "stop":
                                    result.success(stop());
                                    break;
                                case "wad":
                                    result.success(winAddr());
                                    break;
                                case"mad":
                                    result.success(macAddr());
                                    break;
                                default:
                                    result.notImplemented();
                            }
                        }
                );
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //CHECK WIFI AND HOTSPOT ENABLED
    private boolean wifiHotspotEnabled(Context context) throws InvocationTargetException, IllegalAccessException {
        WifiManager manager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        Method method = null;
        try {
            method = manager.getClass().getDeclaredMethod("isWifiApEnabled");
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        method.setAccessible(true); //in the case of visibility change in future APIs
        return (Boolean) method.invoke(manager);
    }

    private boolean checkWifiOnAndConnected(Context context) {
        WifiManager wifiMgr = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);

        assert wifiMgr != null;
        if (wifiMgr.isWifiEnabled()) { // Wi-Fi adapter is ON

            WifiInfo wifiInfo = wifiMgr.getConnectionInfo();

            return wifiInfo.getNetworkId() != -1;
        }
        else {
            return false; // Wi-Fi adapter is OFF
        }
    }
    //GET WIFI ADDRESS
    private String wifiIpAddress(Context context) {
        try {
            if (wifiHotspotEnabled(context)) {
                return "192.168.43.1";
            }
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return Utils.getIPAddress(true);
    }
    //CREATE SERVER
    private  int create(){
        try {
            finalServer = serverFactory.createServer();
            return 1;
        }
        catch (Exception e) {
            return 0;
        }
    }
    //ADDRESS
    private String winAddr(){
        return (String.format("ftp://%s:2133", wifiIpAddress(this)));
    }
    private String macAddr(){
        return (String.format("ftp://%s:%s@%s:2133",usr,pass,wifiIpAddress(this)));
    }
    //START SERVER
    private String start(String u,String p,String l){
        try {
            if (checkWifiOnAndConnected(this) || wifiHotspotEnabled(this)) {
                return (""+serverControl(u,p,l));
            }
            return "-1";
        }
        catch (Exception e) {

            return e.toString();
        }
    }
    int serverControl(String u,String p,String l) {
        int ans;
        if (finalServer.isStopped()) {
            String subLoc="";
            if(l.length()>20 && (l.substring(0,20)).equals("/storage/emulator/0/")){
                subLoc = l.toString().substring(20);
            }
            try {
                setupStart(usr, pass, subLoc);
            } catch (FileNotFoundException fnfe) {
                /*if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                    AlertDialog.Builder builder = new AlertDialog.Builder(this);
                    builder.setMessage(R.string.dialog_message_error).setTitle(R.string.dialog_title);
                    builder.setPositiveButton("OK", (dialog, id) -> {
                        dialog.dismiss();
                        justStarted = false;
                        ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST);
                    });
                    builder.show();
                } else {
                    ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST);
                }*/
            }

            try {

                finalServer.start();
                ans=1;

            } catch (FtpException e) {
                e.printStackTrace();
                ans=-2;
            }
        } else if (finalServer.isSuspended()) {
            try{
            finalServer.resume();
            ans=2;} catch (Exception e) {
                e.printStackTrace();
                ans=-2;
            }

        } else {
            try{
            finalServer.suspend();
            ans=0;
            } catch (Exception e) {
                e.printStackTrace();
                ans=-2;
            }

        }
        return ans;
    }
    private void setupStart(String username, String password, String subLoc) throws FileNotFoundException {
        factory.setPort(2133);
        serverFactory.addListener("default", factory.createListener());
      //  File files = new File(this.getFilesDir(), "users.properties");

        File files = new File(Environment.getExternalStorageDirectory().getPath() + "/users.properties");
        if (!files.exists()) {
            try {
                files.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        userManagerFactory.setFile(files);
        userManagerFactory.setPasswordEncryptor(new SaltedPasswordEncryptor());
        UserManager um = userManagerFactory.createUserManager();
        BaseUser user = new BaseUser();
        user.setName(username);
        user.setPassword(password);
        String home = Environment.getExternalStorageDirectory().getPath()+"/" + subLoc;
        user.setHomeDirectory(home);
        List<Authority> auths = new ArrayList<>();
        Authority auth = new WritePermission();
        auths.add(auth);
        user.setAuthorities(auths);

        try {
            um.save(user);
        } catch (FtpException e1) {
            e1.printStackTrace();
        }

        serverFactory.setUserManager(um);
        Map<String, Ftplet> m = new HashMap<>();
        m.put("miaFtplet", new Ftplet()
        {
            @Override
            public void init(FtpletContext ftpletContext) throws FtpException {

            }

            @Override
            public void destroy() {

            }

            @Override
            public FtpletResult beforeCommand(FtpSession session, FtpRequest request) throws FtpException, IOException
            {
                return FtpletResult.DEFAULT;
            }

            @Override
            public FtpletResult afterCommand(FtpSession session, FtpRequest request, FtpReply reply) throws FtpException, IOException
            {
                return FtpletResult.DEFAULT;
            }

            @Override
            public FtpletResult onConnect(FtpSession session) throws FtpException, IOException
            {
                return FtpletResult.DEFAULT;
            }

            @Override
            public FtpletResult onDisconnect(FtpSession session) throws FtpException, IOException
            {
                return FtpletResult.DEFAULT;
            }
        });
        serverFactory.setFtplets(m);
    }
    //Stop
    private int stop(){
        try {
            finalServer.stop();
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }
}
