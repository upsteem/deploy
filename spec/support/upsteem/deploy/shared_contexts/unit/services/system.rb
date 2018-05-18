shared_context "setup for system service" do
  let(:system) { instance_double("Upsteem::Deploy::Services::System") }

  def expect_system_call_and_return(command, result, times = 1)
    expect_to_receive_exactly_ordered_and_return(
      times, system, :call, result, command
    )
  end

  def expect_system_call_and_raise(command, exception, times = 1)
    expect_to_receive_exactly_ordered_and_raise(
      times, system, :call, exception, command
    )
  end
end
