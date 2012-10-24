module Phidgets
  require "phidgets/ffi/common"
  require "phidgets/ffi/logging"

  module Logging
    extend FFI::Common
    extend FFI::Logging
    include FFI::Common
    include FFI::Logging

    module_function
      def critial(id, message, *args)
        log(:critial, id, message, *args)
      end

      def debug(id, message, *args)
        log(:debug, id, message, *args)
      end

      def disable
        check_result(CPhidget_disableLogging())
      end

      def enable(level = :warning, file = nil)
        check_result(CPhidget_enableLogging(level, file))
      end

      def error(id, message, *args)
        log(:error, id, message, *args)
      end

      def info(id, message, *args)
        log(:info, id, message, *args)
      end

      def log(level, id, message, *args)
        check_result(CPhidget_log(level, id, message, *varargs(args)))
      end

      def verbose(id, message, *args)
        log(:verbose, id, message, *args)
      end

      def warning(id, message, *args)
        log(:warning, id, message, *args)
      end
  end
end
