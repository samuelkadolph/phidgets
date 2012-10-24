require "enumerator"

module Phidgets
  class InterfaceKit
    class Input
      def initialize(ifk, index)
      end
    end

    class Inputs
      include Enumerable
      include FFI::Common
      include FFI::InterfaceKit

      def initialize(ifk)
        @ifk = ifk
      end

      def [](index)
        # @inputs[index]
      end

      def changed(object = nil)
        @changed = lambda do |handle, pointer, index, state|
          yield index, state
        end
        check_result(CPhidgetInterfaceKit_set_OnInputChange_Handler(@ifk.handle, @changed, nil))
      end

      def count
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getInputCount(@ifk.handle, pointer)) }
      end

      def each
        return Enumerator.new(self, :each) unless block_given?
        (0..count).each { |index| yield self[index] }
        self
      end

      def inspect
        "#<#{self.class} count: #{count.inspect}>"
      end
    end
  end
end
