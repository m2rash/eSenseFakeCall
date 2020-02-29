package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import dk.cachet.esense_flutter.EsenseFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    EsenseFlutterPlugin.registerWith(registry.registrarFor("dk.cachet.esense_flutter.EsenseFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
