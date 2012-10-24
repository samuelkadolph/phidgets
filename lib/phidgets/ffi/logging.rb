module Phidgets
  module FFI
    require "phidgets/ffi/library"

    module Logging
      include Library

      enum :CPhidgetLog_level, [:critial, 1, :error, :warning, :debug, :info, :verbose]

      attach_function :CPhidget_disableLogging, [], :int
      attach_function :CPhidget_enableLogging, [:CPhidgetLog_level, :string], :int
      attach_function :CPhidget_log, [:CPhidgetLog_level, :string, :string, :varargs], :int

      private :CPhidget_disableLogging
      private :CPhidget_enableLogging
      private :CPhidget_log

      private
        def varargs(array)
          array.map do |item|
            case item
            when Float
              [:double, item]
            when Fixnum
              [:long_long, item]
            when String
              [:string, item]
            else
              raise ArgumentError, "cannot convert #{item.class} to varargs"
            end
          end.flatten
        end
    end
  end
end
