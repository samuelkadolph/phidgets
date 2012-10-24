module Phidgets
  module FFI
    require "phidgets/ffi/library"

    module Dictionary
      include Library

      typedef :pointer, :CPhidgetDictionaryHandle
      typedef :pointer, :CPhidgetDictionaryListenerHandle

      KeyChangeReasons = enum(:CPhidgetDictionary_keyChangeReason, [:changed, 1, :added, :removing, :current])

      callback :CPhidgetDictionary_OnError_Function, [:CPhidgetDictionaryHandle, :pointer, :int, :string], :int
      callback :CPhidgetDictionary_OnKeyChange_Function, [:CPhidgetDictionaryHandle, :pointer, :string, :string, :CPhidgetDictionary_keyChangeReason], :int
      callback :CPhidgetDictionary_OnServerConnect_Function, [:CPhidgetDictionaryHandle, :pointer], :int
      callback :CPhidgetDictionary_OnServerDisconnect_Function, [:CPhidgetDictionaryHandle, :pointer], :int

      attach_function :CPhidgetDictionary_addKey, [:CPhidgetDictionaryHandle, :string, :string, :int], :int
      attach_function :CPhidgetDictionary_close, [:CPhidgetDictionaryHandle], :int
      attach_function :CPhidgetDictionary_create, [:pointer], :int
      attach_function :CPhidgetDictionary_delete, [:CPhidgetDictionaryHandle], :int
      attach_function :CPhidgetDictionary_getKey, [:CPhidgetDictionaryHandle, :string, :pointer, :int], :int
      attach_function :CPhidgetDictionary_getServerAddress, [:CPhidgetDictionaryHandle, :pointer, :pointer], :int
      attach_function :CPhidgetDictionary_getServerID, [:CPhidgetDictionaryHandle, :pointer], :int
      attach_function :CPhidgetDictionary_getServerStatus, [:CPhidgetDictionaryHandle, :pointer], :int
      attach_function :CPhidgetDictionary_openRemote, [:CPhidgetDictionaryHandle, :string, :string], :int
      attach_function :CPhidgetDictionary_openRemoteIP, [:CPhidgetDictionaryHandle, :string, :int, :string], :int
      attach_function :CPhidgetDictionary_removeKey, [:CPhidgetDictionaryHandle, :string], :int
      attach_function :CPhidgetDictionary_remove_OnKeyChange_Handler, [:CPhidgetDictionaryListenerHandle], :int
      attach_function :CPhidgetDictionary_set_OnError_Handler, [:CPhidgetDictionaryHandle, :CPhidgetDictionary_OnError_Function, :pointer], :int
      attach_function :CPhidgetDictionary_set_OnKeyChange_Handler, [:CPhidgetDictionaryHandle, :pointer, :string, :CPhidgetDictionary_OnKeyChange_Function, :pointer], :int
      attach_function :CPhidgetDictionary_set_OnServerConnect_Handler, [:CPhidgetDictionaryHandle, :CPhidgetDictionary_OnServerConnect_Function, :pointer], :int
      attach_function :CPhidgetDictionary_set_OnServerDisconnect_Handler, [:CPhidgetDictionaryHandle, :CPhidgetDictionary_OnServerDisconnect_Function, :pointer], :int
    end
  end
end
