module Phidgets
  def self.errors
    @@errors
  end

  class Error < StandardError
    attr_reader :code, :description

    def initialize(code, description)
      @code, @description = code, description
      super(description)
    end
  end
  @@errors = Hash.new(Error)

  class BadPasswordError < Error
  end
  @@errors[:bad_password] = BadPasswordError

  class BadVersionError < Error
  end
  @@errors[:bad_version] = BadVersionError

  class DuplicateRequestError < Error
  end
  @@errors[:duplicate] = DuplicateRequestError

  class EventError < Error
  end
  @@errors[:event] = EventError

  class InterruptedError < Error
  end
  @@errors[:interrupted] = InterruptedError

  class InvalidArgumentError < Error
  end
  @@errors[:invalid_argument] = InvalidArgumentError

  class InvalidErrorCodeError < Error
  end
  @@errors[:invalid] = InvalidErrorCodeError

  class NetworkError < Error
  end
  @@errors[:network] = NetworkError

  class NetworkNotConnectedError < Error
  end
  @@errors[:network_not_connected] = NetworkNotConnectedError

  class NoMemoryError < Error
  end
  @@errors[:no_memory] = NoMemoryError

  class NotAttachedError < Error
  end
  @@errors[:not_attached] = NotAttachedError

  class NotFoundError < Error
  end
  @@errors[:not_found] = NotFoundError

  class OutOfBoundsError < Error
  end
  @@errors[:out_of_bounds] = OutOfBoundsError

  class TimeoutError < Error
  end
  @@errors[:timeout] = TimeoutError

  class UnexpectedError < Error
  end
  @@errors[:unexpected] = UnexpectedError

  class UnknownValueError < Error
  end
  @@errors[:unknown_value] = UnknownValueError

  class UnsupportedError < Error
  end
  @@errors[:unsupported] = UnsupportedError

  class WrongDeviceError < Error
  end
  @@errors[:wrong_device] = WrongDeviceError
end
