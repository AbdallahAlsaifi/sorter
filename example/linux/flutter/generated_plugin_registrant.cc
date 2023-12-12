//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <sorter/sorter_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) sorter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SorterPlugin");
  sorter_plugin_register_with_registrar(sorter_registrar);
}
