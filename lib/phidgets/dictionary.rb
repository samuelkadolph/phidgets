module Phidgets
  require "phidgets/ffi/constants"
  require "phidgets/ffi/common"
  require "phidgets/ffi/dictionary"

  class Dictionary
    class Persistence
      include FFI::Common
      include FFI::Dictionary

      def initialize(dictionary)
        @dictionary = dictionary
      end

      def [](key)
        @dictionary[key]
      end
      alias get []

      def []=(key, value)
        check_result(CPhidgetDictionary_addKey(@dictionary.handle, key, value, 1))
        value
      end
      alias put []=

      def delete(key)
        check_result(CPhidgetDictionary_removeKey(handle, key.is_a?(Regexp) ? key.source : key))
      end
      alias remove delete

      def inspect
        "#<#{self.class}>"
      end
    end

    include FFI::Constants
    include FFI::Common
    include FFI::Dictionary

    attr_reader :handle

    class << self
      alias create new

      def finializer(handle)
        proc { CPhidgetDictionary_delete(handle) }
      end

      def open(server = nil, password = nil)
        dictionary = create
        dictionary.open(server, password)
        return dictionary unless block_given?
        begin
          yield dictionary
        ensure
          dictionary.close
        end
      end
    end

    def initialize
      @handle = create_handle
      ObjectSpace.define_finalizer(self, self.class.finializer(handle))
    end

    def [](key, buffer = 8192)
      new_string(buffer) { |pointer| check_result(CPhidgetDictionary_getKey(handle, key, pointer, buffer)) }
    end
    alias get []

    def []=(key, value)
      check_result(CPhidgetDictionary_addKey(handle, key, value, 0))
      value
    end
    alias put []=

    def open(server = nil, password = nil)
      CPhidgetDictionary_openRemote(handle, server, password)
    end

    def connected(object = nil, &block)
    end

    def close
      CPhidgetDictionary_close(handle)
      nil
    end

    def delete(key)
      check_result(CPhidgetDictionary_removeKey(handle, key.is_a?(Regexp) ? key.source : key))
    end
    alias remove delete

    def error(object = nil)
      @error = lambda do |handle, pointer, error, error_string|
        yield error, error_string
      end
      check_result(CPhidgetDictionary_set_OnError_Handler(handle, @error, nil))
    end

    def persistent
      @persistent ||= Persistence.new(self)
    end

    def server_address
      by_references(:string, :int) { |string, int| check_result(CPhidgetDictionary_getServerAddress(handle, string, int)) }
    end

    def server_id
      new_string_pointer { |pointer| check_result(CPhidgetDictionary_getServerID(handle, pointer)) }
    end

    def server_status
      Status[new_int_pointer { |pointer| check_result(CPhidgetDictionary_getServerStatus(handle, pointer)) }]
    end

    protected
      def create_handle
        new_pointer_pointer { |pointer| check_result(CPhidgetDictionary_create(pointer)) }
      end
  end
end
