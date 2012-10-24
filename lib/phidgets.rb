module Phidgets
  require "phidgets/ffi/common"
  require "phidgets/version"

  extend FFI::Common

  def self.library_version
    new_string_pointer { |pointer| check_result(CPhidget_getLibraryVersion(pointer)) }
  end
end
