module Phidgets
  module FFI
    require "phidgets/ffi/library"

    module InterfaceKit
      include Library

      typedef :pointer, :CPhidgetInterfaceKitHandle

      callback :CPhidgetInterfaceKit_OnInputChange_Handler, [:CPhidgetInterfaceKitHandle, :pointer, :int, :int], :int
      callback :CPhidgetInterfaceKit_OnOutputChange_Handler, [:CPhidgetInterfaceKitHandle, :pointer, :int, :int], :int
      callback :CPhidgetInterfaceKit_OnSensorChange_Handler, [:CPhidgetInterfaceKitHandle, :pointer, :int, :int], :int

      attach_function :CPhidgetInterfaceKit_create, [:CPhidgetInterfaceKitHandle], :int
      attach_function :CPhidgetInterfaceKit_getDataRate, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getDataRateMax, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getDataRateMin, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getInputCount, [:CPhidgetInterfaceKitHandle, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getInputState, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getOutputCount, [:CPhidgetInterfaceKitHandle, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getOutputState, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getRatiometric, [:CPhidgetInterfaceKitHandle, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getSensorChangeTrigger, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getSensorCount, [:CPhidgetInterfaceKitHandle, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getSensorRawValue, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_getSensorValue, [:CPhidgetInterfaceKitHandle, :int, :pointer], :int
      attach_function :CPhidgetInterfaceKit_setDataRate, [:CPhidgetInterfaceKitHandle, :int, :int], :int
      attach_function :CPhidgetInterfaceKit_setOutputState, [:CPhidgetInterfaceKitHandle, :int, :int], :int
      attach_function :CPhidgetInterfaceKit_setRatiometric, [:CPhidgetInterfaceKitHandle, :int], :int
      attach_function :CPhidgetInterfaceKit_setSensorChangeTrigger, [:CPhidgetInterfaceKitHandle, :int, :int], :int
      attach_function :CPhidgetInterfaceKit_set_OnInputChange_Handler, [:CPhidgetInterfaceKitHandle, :CPhidgetInterfaceKit_OnInputChange_Handler, :pointer], :int
      attach_function :CPhidgetInterfaceKit_set_OnOutputChange_Handler, [:CPhidgetInterfaceKitHandle, :CPhidgetInterfaceKit_OnOutputChange_Handler, :pointer], :int
      attach_function :CPhidgetInterfaceKit_set_OnSensorChange_Handler, [:CPhidgetInterfaceKitHandle, :CPhidgetInterfaceKit_OnSensorChange_Handler, :pointer], :int
    end
  end
end
