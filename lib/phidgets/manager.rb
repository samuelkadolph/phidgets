module Phidgets
  require "phidgets/attachment"
  require "phidgets/ffi/common"
  require "phidgets/ffi/constants"
  require "phidgets/ffi/events"
  require "phidgets/ffi/manager"

  class Manager
    include Attachment
    include FFI::Common
    include FFI::Constants
    include FFI::Events
    include FFI::Manager

    attr_reader :handle

    class << self
      alias create new

      def finializer(handle)
        proc { CPhidgetManager_close(handle); CPhidgetManager_delete(handle) }
      end

      def open(options = {})
        manager = create
        manager.open(options)
        return manager unless block_given?
        begin
          yield manager
        ensure
          manager.close
        end
      end
    end

    def initialize
      @handle = create_handle
      initialize_events
      ObjectSpace.define_finalizer(self, self.class.finializer(handle))
    end

    def open(options = {})
      if options == :remote
        open(remote: { server: nil })
      elsif options.key?(:remote)
        open_remote(options[:remote])
      else
        check_result(CPhidgetManager_open(handle))
      end
    end

    # event :attached,     :CPhidgetManager_set_OnAttach_Handler
    # event :connected,    :CPhidgetManager_set_OnServerConnect_Handler
    # event :detached,     :CPhidgetManager_set_OnDetach_Handler
    # event :disconnected, :CPhidgetManager_set_OnServerDisconnect_Handler
    # event :error,        :CPhidgetManager_set_OnError_Handler

    # manager = Manager.open
    # manager.attached.register(:foo) { puts "here" } # => #<Proc>
    # manager.attached.unregister(:foo) # => #<Proc>
    # manager.attached.set { puts "here" } # => #<Proc>
    # manager.attached.clear # => [{}, [#<Proc>]]

    def connected(object = nil, &block)
    end

    def close
      CPhidgetManager_close(handle)
      nil
    end

    def devices
      # array, count = by_references(:pointer, :int) { |array, int| check_result(CPhidgetManager_getAttachedDevices(handle, array, int)) }
      # array
    end

    def server_address
      by_references(:string, :int) { |string, int| check_result(CPhidgetManager_getServerAddress(handle, string, int)) }
    end

    def server_id
      new_string_pointer { |pointer| check_result(CPhidgetManager_getServerID(handle, pointer)) }
    end

    def server_status
      Status[new_int_pointer { |pointer| check_result(CPhidgetManager_getServerStatus(handle, pointer)) }]
    end

    protected
      def create_handle
        new_pointer_pointer { |pointer| check_result(CPhidgetManager_create(pointer)) }
      end

    private
      def open_remote(remote)
        host = remote[:host] || remote[:ip]
        password = remote[:password]
        port = remote[:port] || 5001
        server = remote[:server]

        result = if host
          CPhidgetManager_openRemoteIP(handle, host, port, password)
        else
          CPhidgetManager_openRemote(handle, server, password)
        end

        check_result(result)
      end
  end
end
