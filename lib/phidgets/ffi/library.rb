require "ffi"

module Phidgets
  module FFI
    module Library
      PATHS = []
      PATHS << "libphidget21.so" << "/usr/lib/libphidget21.so" << "/usr/lib32/libphidget21.so" << "/usr/lib64/libphidget21.so"
      PATHS << "Phidget21" << "/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21" # Mac OS X
      PATHS << "/usr/lib/libphidget21.so.0" # PhidgetSBC2
      PATHS.freeze

      def self.included(base)
        base.extend(::FFI::Library)
        base.ffi_lib(PATHS)
      end
    end
  end
end
