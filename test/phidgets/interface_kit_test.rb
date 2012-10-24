require "test_helper"
require "phidgets/interface_kit"

describe Phidgets::InterfaceKit do
  before do
    Phidgets::InterfaceKit.any_instance.stubs(:CPhidgetInterfaceKit_create).returns(0)
    @ifk = Phidgets::InterfaceKit.new
  end

  it "should do something" do

  end
end
