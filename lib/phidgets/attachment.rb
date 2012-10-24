module Phidgets
  module Attachment
    def attached?
      server_status == :attached
    end

    def not_attached?
      server_status == :not_attached
    end
  end
end
