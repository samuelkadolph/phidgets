require "enumerator"

module Phidgets
  class InterfaceKit
    class Sensor
      include FFI::Common
      include FFI::InterfaceKit

      def initialize(ifk, index)
        @ifk, @index = ifk, index
      end

      def change_trigger
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getSensorChangeTrigger(@ifk.handle, @index, pointer)) }
      end

      def change_trigger=(value)
        check_result(CPhidgetInterfaceKit_setSensorChangeTrigger(@ifk.handle, @index, value))
        value
      end

      def changed
        @changed = lambda do |value|
          yield value
        end
      end

      def data_rate
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getDataRate(@ifk.handle, @index, pointer)) }
      end

      def data_rate=(value)
        check_result(CPhidgetInterfaceKit_setDataRate(@ifk.handle, @index, value))
        value
      end

      def data_rate_max
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getDataRateMax(@ifk.handle, @index, pointer)) }
      end

      def data_rate_min
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getDataRateMin(@ifk.handle, @index, pointer)) }
      end

      def raw_value
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getSensorRawValue(@ifk.handle, @index, pointer)) }
      end
      alias raw raw_value

      def value
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getSensorValue(@ifk.handle, @index, pointer)) }
      end

      def inspect
        "#<#{self.class} change_trigger: #{change_trigger}, data_rate: #{data_rate}, data_rate_max: #{data_rate_max}, data_rate_min: #{data_rate_min}, raw: #{raw}, value: #{value}>"
      end
    end

    class Sensors
      include Enumerable
      include FFI::Common
      include FFI::InterfaceKit

      def initialize(ifk)
        @ifk, @sensors = ifk, {}
      end

      def [](index)
        @sensors[index] ||= Sensor.new(@ifk, index)
      end

      def changed(object = nil)
        @changed = lambda do |handle, pointer, index, state|
          begin
            yield index, state
            b = self[index].instance_variable_get(:@changed)
            b.call(state) if b
            nil
          rescue => e
            $stderr.puts("sensors.changed error: #{e} - #{e.message}")
            $stderr.puts(e.backtrace)
            nil
          end
        end
        check_result(CPhidgetInterfaceKit_set_OnSensorChange_Handler(@ifk.handle, @changed, nil))
      end

      def count
        new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getSensorCount(@ifk.handle, pointer)) }
      end

      def each
        return Enumerator.new(self, :each) unless block_given?

        index = 0
        while index < count
          yield self[index]
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
