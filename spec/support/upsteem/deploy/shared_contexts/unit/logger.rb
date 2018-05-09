shared_context "setup for logger" do
  let(:logger) { instance_double("Logger") }

  def expect_logger_action(name, message, times = 1)
    expect_to_receive_exactly_ordered(times, logger, name, message)
  end

  def expect_logger_info(message, times = 1)
    expect_logger_action(:info, message, times)
  end
end
