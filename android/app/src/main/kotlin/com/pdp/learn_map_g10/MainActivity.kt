package com.pdp.learn_map_g10

import android.app.Application
import com.yandex.mapkit.MapKitFactory;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant



class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("b9cbdc8e-cd97-4ed5-8047-63a4755da877")
        super.configureFlutterEngine(flutterEngine)
    }
}
