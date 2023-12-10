#ifndef FLUTTER_PLUGIN_SORTER_PLUGIN_H_
#define FLUTTER_PLUGIN_SORTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace sorter {

class SorterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SorterPlugin();

  virtual ~SorterPlugin();

  // Disallow copy and assign.
  SorterPlugin(const SorterPlugin&) = delete;
  SorterPlugin& operator=(const SorterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace sorter

#endif  // FLUTTER_PLUGIN_SORTER_PLUGIN_H_
