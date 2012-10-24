module Phidgets
  module FFI
    require "phidgets/ffi/library"

    module Constants
      include Library

      Status = enum(:attached, 1, :not_attached, 0)

      Errors = enum(
        :ok, 0,
        :not_found, 1,
        :no_memory, 2,
        :unexpected, 3,
        :invalid_argument, 4,
        :not_attached, 5,
        :interrupted, 6,
        :invalid, 7,
        :network, 8,
        :unknown_value, 9,
        :bad_password, 10,
        :unsupported, 11,
        :duplicate, 12,
        :timeout, 13,
        :out_of_bounds, 14,
        :event, 15,
        :network_not_connected, 16,
        :wrong_device, 17,
        :bad_version, 18
      )
    end
  end
end
