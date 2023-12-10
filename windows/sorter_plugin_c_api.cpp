#include "include/sorter/sorter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "sorter_plugin.h"

void SorterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  sorter::SorterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
