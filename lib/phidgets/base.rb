module Phidgets
  require "phidgets/ffi/common"
  require "phidgets/ffi/constants"
  require "phidgets/ffi/events"

  class Base
    extend FFI::Common
    include FFI::Common
    include FFI::Constants
    include FFI::Events

    attr_reader :handle

    event :attached, :CPhidget_set_OnAttach_Handler
    event :connected, :CPhidget_set_OnServerConnect_Handler
    event :detached, :CPhidget_set_OnDetach_Handler
    event :disconnected, :CPhidget_set_OnServerDisconnect_Handler
    event :error, :CPhidget_set_OnError_Handler do |code, string|
      yield Errors[code], string
    end

    class << self
      alias create new

      def finializer(handle)
        proc { CPhidget_close(handle); CPhidget_delete(handle) }
      end

      def for_handle(handle)
        phidget = allocate
        phidget.instance_variable_set(:@handle, handle)
        phidget
      end

      def open(options = {})
        phidget = create
        phidget.open(options)
        return phidget unless block_given?
        begin
          yield phidget
        ensure
          phidget.close
        end
      end
    end

    def initialize
      @handle = create_handle
      initialize_events
      ObjectSpace.define_finalizer(self, self.class.finializer(handle))
    end

    def attached?
      status == :attached
    end

    def open(options = {})
      if options == :remote
        open(remote: { server: nil })
      elsif options.key?(:remote)
        open_remote(options[:remote])
      elsif options.key?(:label)
        check_result(CPhidget_openLabel(handle, options[:label]))
      elsif options.key?(:serial)
        check_result(CPhidget_open(handle, options[:serial]))
      else
        open(label: nil)
      end
    end

    def close
      check_result(CPhidget_close(handle))
      nil
    end

    def inspect
      if attached?
        inspect_when_attached
      else
        inspect_when_not_attached
      end
    end

    def label
      new_string_pointer { |pointer| check_result(CPhidget_getDeviceLabel(handle, pointer)) }
    end

    def label=(value)
      check_result(CPhidget_setDeviceLabel(handle, value))
    end

    def status
      Status[new_int_pointer { |pointer| check_result(CPhidget_getDeviceStatus(handle, pointer)) }]
    end

    def wait_for_attachment(timeout = 0)
      check_result(CPhidget_waitForAttachment(handle, timeout))
    end

    def version
      new_int_pointer { |pointer| check_result(CPhidget_getDeviceVersion(handle, pointer)) }
    end

    protected
      def create_handle
        new_pointer_pointer { |pointer| create_phidget(pointer) }
      end

      def create_phidget(pointer)
        raise NotImplementedError
      end

      def inspect_when_attached
        "#<#{self.class} status: #{status}>"
      end
      alias inspect_when_not_attached inspect_when_attached

    private
      def open_remote(remote)
        host = remote[:host] || remote[:ip]
        label = remote[:label]
        password = remote[:password]
        port = remote[:port] || 5001
        serial = remote[:serial] || -1
        server = remote[:server]

        result = if label
          if host
            CPhidget_openLabelRemoteIP(handle, label, host, port, password)
          else
            CPhidget_openLabelRemote(handle, label, server, password)
          end
        else
          if host
            CPhidget_openRemoteIP(handle, serial, host, port, password)
          else
            CPhidget_openRemote(handle, serial, server, password)
          end
        end

        check_result(result)
      end
  end
end
