module Phidgets
  module FFI
    require "phidgets/ffi/library"

    module Manager
      include Library

      typedef :pointer, :CPhidgetManagerHandle

      callback :CPhidgetManager_OnAttach_Handler, [:CPhidgetManagerHandle, :pointer], :int
      callback :CPhidgetManager_OnDetach_Handler, [:CPhidgetManagerHandle, :pointer], :int
      callback :CPhidgetManager_OnError_Handler, [:CPhidgetManagerHandle, :pointer, :int, :string], :int
      callback :CPhidgetManager_OnServerConnect_Handler, [:CPhidgetManagerHandle, :pointer], :int
      callback :CPhidgetManager_OnServerDisconnect_Handler, [:CPhidgetManagerHandle, :pointer], :int

      attach_function :CPhidgetManager_close, [:CPhidgetManagerHandle], :int
      attach_function :CPhidgetManager_create, [:pointer], :int
      attach_function :CPhidgetManager_delete, [:CPhidgetManagerHandle], :int
      attach_function :CPhidgetManager_freeAttachedDevicesArray, [:pointer], :int
      attach_function :CPhidgetManager_getAttachedDevices, [:CPhidgetManagerHandle, :pointer, :pointer], :int
      attach_function :CPhidgetManager_getServerAddress, [:CPhidgetManagerHandle, :pointer, :pointer], :int
      attach_function :CPhidgetManager_getServerID, [:CPhidgetManagerHandle, :pointer], :int
      attach_function :CPhidgetManager_getServerStatus, [:CPhidgetManagerHandle, :pointer], :int
      attach_function :CPhidgetManager_open, [:CPhidgetManagerHandle], :int
      attach_function :CPhidgetManager_openRemote, [:CPhidgetManagerHandle, :string, :string], :int
      attach_function :CPhidgetManager_openRemoteIP, [:CPhidgetManagerHandle, :string, :int, :string], :int
      attach_function :CPhidgetManager_set_OnAttach_Handler, [:CPhidgetManagerHandle, :CPhidgetManager_OnAttach_Handler, :pointer], :int
      attach_function :CPhidgetManager_set_OnDetach_Handler, [:CPhidgetManagerHandle, :CPhidgetManager_OnDetach_Handler, :pointer], :int
      attach_function :CPhidgetManager_set_OnError_Handler, [:CPhidgetManagerHandle, :CPhidgetManager_OnError_Handler, :pointer], :int
      attach_function :CPhidgetManager_set_OnServerConnect_Handler, [:CPhidgetManagerHandle, :CPhidgetManager_OnServerConnect_Handler, :pointer], :int
      attach_function :CPhidgetManager_set_OnServerDisconnect_Handler, [:CPhidgetManagerHandle, :CPhidgetManager_OnServerDisconnect_Handler, :pointer], :int

      private :CPhidgetManager_close
      private :CPhidgetManager_create
      private :CPhidgetManager_delete
      private :CPhidgetManager_freeAttachedDevicesArray
      private :CPhidgetManager_getAttachedDevices
      private :CPhidgetManager_getServerAddress
      private :CPhidgetManager_getServerID
      private :CPhidgetManager_getServerStatus
      private :CPhidgetManager_open
      private :CPhidgetManager_openRemote
      private :CPhidgetManager_openRemoteIP
      private :CPhidgetManager_set_OnAttach_Handler
      private :CPhidgetManager_set_OnDetach_Handler
      private :CPhidgetManager_set_OnError_Handler
      private :CPhidgetManager_set_OnServerConnect_Handler
      private :CPhidgetManager_set_OnServerDisconnect_Handler
    end
  end
end
