
Pod::Spec.new do |s|

  s.name         = "PLCrashReporter"
  s.version      = "1.3.3"
  s.summary      = "Reliable, open-source crash reporting for iOS and Mac OS X."
  s.description  = "Plausible CrashReporter provides an in-process crash reporting \nframework for use on both iOS and Mac OS X, and powers many of \nthe crash reporting services available for iOS, including \nHockeyApp, Flurry, Crittercism and FoglightAPM."
  s.homepage     = "https://github.com/backtrace-labs/plcrashreporter"

  s.license      = "MIT"
  s.author             = { "Plausible Labs Cooperative, Inc." => "contact@plausible.coop",
                           "Marcin Karmelita" => "marcin@apptailors.co" }

  #  When using multiple platforms
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/krml19/plcrashreporter.git", :commit => "8d2de57d11a9e68154938c9a0d17d0470decbc5a" }

  s.source_files  = "Source/*.{h,hpp,c,cpp,m,mm,s}", "Source/{Crash Report,Private API}/**/*.{h,hpp,c,cpp,m,mm,s}", "Dependencies/protobuf-2.0.3/src/*.{h,c}"
  s.exclude_files = "**/*Tests.*", "**/*_test_.*", "**/*TestCase.*", "**/*test.*", "**/*main.m"

  s.public_header_files = "Source/PLCrashReport*.h",
  "Source/PLCrashNamespace*.h",
  "Source/PLCrashMacros.h",
  "Source/PLCrashFeatureConfig.h",
  "Source/CrashReporter.h"
  # s.private_header_files = "Dependencies/**/*.h", "Source/Private API/**/*.h", "Source/*.pb-c.h", "Source/mach*.h"
  s.header_mappings_dir = "."
  s.preserve_paths = "Dependencies/**"


  s.resources = "Resources/*.proto"
  s.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "PLCR_PRIVATE"
  }
  s.libraries = "c++"
  s.requires_arc = false

  s.prefix_header_contents = "#import \"PLCrashNamespace.h\""

  # s.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => '"${PROJECT_DIR}/.."/**' }
  s.prepare_command =
  <<-CMD
    cd "Resources" && "../Dependencies/protobuf-2.0.3/bin/protoc-c" --c_out="../Source" "crash_report.proto" && cd ..
    find . \\( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \\) -exec sed -i '' -e 's/#include <google\\/protobuf-c\\/protobuf-c.h>/#include "..\\/Dependencies\\/protobuf-2.0.3\\/include\\/google\\/protobuf-c\\/protobuf-c.h"/g' {} \\;
    find . \\( -iname '*.h' -o -iname '*.hpp' -o -iname '*.c' -o -iname '*.cc' -o -iname '*.cpp' -o -iname '*.m' -o -iname '*.mm' \\) -exec sed -i '' -e 's/#import "CrashReporter\\/CrashReporter.h"/#import "CrashReporter.h"/g' {} \\;
  CMD
end
