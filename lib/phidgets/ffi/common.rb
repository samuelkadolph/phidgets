module Phidgets
  require "phidgets/errors"

  module FFI
    require "phidgets/ffi/constants"
    require "phidgets/ffi/library"

    module Common
      include Library

      class CPhidget_Timestamp < ::FFI::Struct
        layout :seconds, :int, :microseconds, :int

        def seconds
          self[:seconds]
        end

        def seconds=(value)
          self[:seconds] = value
        end

        def microseconds
          self[:microseconds]
        end

        def microseconds=(value)
          self[:microseconds] = value
        end
      end

      typedef :pointer, :CPhidgetHandle
      typedef :pointer, :CPhidget_TimestampHandle

      callback :CPhidget_OnAttach_Handler, [:CPhidgetHandle, :pointer], :int
      callback :CPhidget_OnDetach_Handler, [:CPhidgetHandle, :pointer], :int
      callback :CPhidget_OnError_Handler, [:CPhidgetHandle, :pointer, :int, :string], :int
      callback :CPhidget_OnServerConnect_Handler, [:CPhidgetHandle, :pointer], :int
      callback :CPhidget_OnServerDisconnect_Handler, [:CPhidgetHandle, :pointer], :int

      attach_function :CPhidget_close, [:CPhidgetHandle], :int
      attach_function :CPhidget_delete, [:CPhidgetHandle], :int
      attach_function :CPhidget_getDeviceClass, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getDeviceID, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getDeviceLabel, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getDeviceName, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getDeviceStatus, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getDeviceType, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getDeviceVersion, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getErrorDescription, [:int, :pointer], :int
      attach_function :CPhidget_getLibraryVersion, [:pointer], :int
      attach_function :CPhidget_getSerialNumber, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getServerAddress, [:CPhidgetHandle, :pointer, :pointer], :int
      attach_function :CPhidget_getServerID, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_getServerStatus, [:CPhidgetHandle, :pointer], :int
      attach_function :CPhidget_open, [:CPhidgetHandle, :int], :int
      attach_function :CPhidget_openLabel, [:CPhidgetHandle, :string], :int
      attach_function :CPhidget_openLabelRemote, [:CPhidgetHandle, :string, :string, :string], :int
      attach_function :CPhidget_openLabelRemoteIP, [:CPhidgetHandle, :string, :string, :int, :string], :int
      attach_function :CPhidget_openRemote, [:CPhidgetHandle, :int, :string, :string], :int
      attach_function :CPhidget_openRemoteIP, [:CPhidgetHandle, :int, :string, :int, :string], :int
      attach_function :CPhidget_setDeviceLabel, [:CPhidgetHandle, :string], :int
      attach_function :CPhidget_set_OnAttach_Handler, [:CPhidgetHandle, :CPhidget_OnAttach_Handler, :pointer], :int
      attach_function :CPhidget_set_OnDetach_Handler, [:CPhidgetHandle, :CPhidget_OnDetach_Handler, :pointer], :int
      attach_function :CPhidget_set_OnError_Handler, [:CPhidgetHandle, :CPhidget_OnError_Handler, :pointer], :int
      attach_function :CPhidget_set_OnServerConnect_Handler, [:CPhidgetHandle, :CPhidget_OnServerConnect_Handler, :pointer], :int
      attach_function :CPhidget_set_OnServerDisconnect_Handler, [:CPhidgetHandle, :CPhidget_OnServerDisconnect_Handler, :pointer], :int
      attach_function :CPhidget_waitForAttachment, [:CPhidgetHandle, :int], :int, blocking: true

      methods(false).each do |method|
        module_function method
      end

      private
        def box_bool(bool)
          bool ? 1 : 0
        end

        def by_reference(type, size = nil, &block)
          by_references(*[type, size].compact, &block).first
        end

        def by_references(*types)
          pointers = []

          types = types.reduce([]) do |memo, type|
            case type
            when Fixnum
              memo.last << type
            when Symbol
              memo << [type]
            end
            memo
          end

          types.each do |(type, size)|
            pointers << (size ? ::FFI::MemoryPointer.new(type, size) : ::FFI::MemoryPointer.new(type))
          end

          yield *pointers

          pointers.zip(types).map do |pointer, (type, size)|
            case type
            when :int
              pointer.read_int
            when :pointer
              pointer.read_pointer
            when :string
              pointer = pointer.get_pointer(0)
              pointer.null? ? nil : pointer.read_string
            end
          end
        end

        def check_result(result)
          code = Constants::Errors[result]
          return true if code == :ok
          raise Phidgets.errors[code].new(result, error_description(result))
        end

        def error_description(status)
          new_string_pointer { |pointer| check_result(CPhidget_getErrorDescription(status, pointer)) }
        end

        def new_int_pointer(&block)
          by_reference(:int, &block)
        end

        def new_pointer_pointer(&block)
          by_reference(:pointer, &block)
        end

        def new_string(size = nil)
          string = (size ? ::FFI::MemoryPointer.new(:string, size) : ::FFI::MemoryPointer.new(:string))
          yield string
          string.read_string
        end

        def new_string_pointer(size = nil, &block)
          by_reference(:string, size, &block)
        end

        def unbox_bool(int)
          int == 1 ? true : false
        end
    end
  end
end
