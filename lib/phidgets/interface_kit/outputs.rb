module Phidgets
  class InterfaceKit
    class Output
      include FFI::Common
      include FFI::InterfaceKit

      def initialize(ifk, index)
        @ifk, @index = ifk, index
      end

      def changed
        @changed = lambda do |state|
          yield state
        end
      end

      def state
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getOutputState(@ifk.handle, @index, pointer)) }
      end

      def state=(value)
        check_result(CPhidgetInterfaceKit_setOutputState(@ifk.handle, @index, value))
        value
      end

      def inspect
        "#<#{self.class} state: #{state}>"
      end
    end

    class Outputs
      include Enumerable
      include FFI::Common
      include FFI::InterfaceKit

      def initialize(ifk)
        @ifk, @outputs = ifk, {}
      end

      def [](index)
        @outputs[index] ||= Output.new(@ifk, index)
      end

      def changed(object = nil)
        @changed = lambda do |handle, object, index, state|
          begin
            yield index, state
            b = self[index].instance_variable_get(:@changed)
            b.call(state) if b
            nil
          rescue Exception => e
            puts "error e=#{e}"
            nil
          end
        end
        check_result(CPhidgetInterfaceKit_set_OnOutputChange_Handler(@ifk.handle, @changed, nil))
      end

      def count
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getOutputCount(@ifk.handle, pointer)) }
      end

      def each
        return Enumerator.new(self, :each) unless block_given?

        index = 0
        while index < count
          yield index
          index += 1
        end
        self
      end

      def inspect
        "#<#{self.class} count: #{count.inspect}>"
      end
    end
  end
end
