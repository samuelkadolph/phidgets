module Phidgets
  require "phidgets/base"
  require "phidgets/ffi/interface_kit"

  class InterfaceKit < Base
    require "phidgets/interface_kit/inputs"
    require "phidgets/interface_kit/outputs"
    require "phidgets/interface_kit/sensors"

    include FFI::InterfaceKit

    attr_reader :inputs, :outputs, :sensors

    def initialize(*)
      super
      @inputs = Inputs.new(self)
      @outputs = Outputs.new(self)
      @sensors = Sensors.new(self)
    end

    def ratiometric
      new_int_pointer { |pointer| check_result(CPhidgetInterfaceKit_getRatiometric(handle, pointer)) }
    end

    def ratiometric=(value)
      check_result(CPhidgetInterfaceKit_setRatiometric(handle, value))
      value
    end

    protected
      def create_phidget(pointer)
        check_result(CPhidgetInterfaceKit_create(pointer))
      end

      def inspect_when_attached
        "#<#{self.class} inputs: #{inputs.inspect}, outputs: #{outputs.inspect}, sensors: #{sensors.inspect}, ratiometric: #{ratiometric.inspect}, status: #{status}>"
      end
  end
end
