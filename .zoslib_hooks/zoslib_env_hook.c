#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#pragma convert("IBM-1047")
char __zopen_identifier[] = "$Id: Vendor:zOS_Open_Tools BuildRev:04c9b90 2025-07-30 23:29:10  $";
#pragma convert(pop)

#define PROJECT_ROOT_STR "PROJECT_ROOT"

__attribute__((visibility("default"))) int zoslib_env_hook(char*) __attribute__((used));

__attribute__((visibility("default"))) int zoslib_env_hook(char* root_dir) {
char* envar_value;
char* value_str;
char* pos;
long size;

// Avoid setting environment variables during build time because they do not hold correct values
// and should only be used from the installed location.
// To avoid setting environment variables during build time, we need to guard it
// by checking if ZOPEN_IN_ZOPEN_BUILD is set to the current build process setting.
// But this also meant that any dependent tools that set envars via zoslib env hooks would avoid setting those environment variables, effectively breaking them.
if ((envar_value = getenv("ZOPEN_IN_ZOPEN_BUILD")) &&
    strcmp(envar_value, "DEVUSER.66055.19121") == 0) {
  return 0;
}

return 0;
}
