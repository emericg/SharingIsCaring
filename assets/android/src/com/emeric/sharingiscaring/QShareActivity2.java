
package com.emeric.sharingiscaring;

import com.emeric.utils.*;

import org.qtproject.qt5.android.QtNative;
import org.qtproject.qt5.android.bindings.QtActivity;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.lang.String;

import android.os.*;
import android.app.*;
import android.content.*;
import android.net.Uri;
import android.util.Log;
import android.content.Intent;
import android.content.ContentResolver;
import android.webkit.MimeTypeMap;

public class QShareActivity2 extends QtActivity
{
    private byte[] mExportData = null;

    private static final int EXPORT_REQUEST_CODE = 1;
    private static final int IMPORT_REQUEST_CODE = 2;

    private native void indImportData(byte[] jsonData, boolean success);
    private native void indExportData(boolean success);

    public void reqExportData(byte[] jsonData) {
        mExportData = jsonData;

        Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("application/json");
        intent.putExtra(Intent.EXTRA_TITLE, "mydata.json");

        startActivityForResult(intent, EXPORT_REQUEST_CODE);
    }

    public void reqImportData() {
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("application/*");
        intent.putExtra(Intent.EXTRA_TITLE, "mydata.json");

        String[] mimeTypes = new String[]{ "application/json" };
        intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes);
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(Intent.createChooser(intent, "Import"), IMPORT_REQUEST_CODE);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch(requestCode) {
        case EXPORT_REQUEST_CODE:
            {
                boolean success = false;

                if (resultCode == RESULT_OK && data != null) {
                    final Uri uri = data.getData();
                    try {
                        OutputStream outputStream = getContentResolver().openOutputStream(uri);
                        if (outputStream != null) {
                            outputStream.write(mExportData);
                            outputStream.close();

                            mExportData = null;
                            success = true;
                        }
                    }
                    catch(Throwable t) {
                        t.printStackTrace();
                    }
                }

                indExportData(success);
            }
            break;
        case IMPORT_REQUEST_CODE:
            {
                ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
                boolean success = false;

                if (resultCode == RESULT_OK && data != null) {
                    final Uri uri = data.getData();
                    try {
                        InputStream inputStream = getContentResolver().openInputStream(uri);
                        if (inputStream != null) {
                            byte[] buffer = new byte[4096];

                            int len = 0;
                            while((len = inputStream.read(buffer)) != -1) {
                                byteBuffer.write(buffer, 0, len);
                            }
                            inputStream.close();

                            success = true;
                        }
                    }
                    catch (Throwable t) {
                        t.printStackTrace();
                    }
                }

                indImportData(byteBuffer.toByteArray(), success);
            }
            break;
        }

        super.onActivityResult(requestCode, resultCode, data);
    }
}
