shared_context "setup for bundler service" do
  let(:bundler) { instance_double("Upsteem::Deploy::Services::Bundler") }

  def expect_bundle_exec_and_return(command, result, times = 1)
    expect_to_receive_exactly_ordered_and_return(
      times, bundler, :execute_command, result, command
    )
  end

  def expect_bundle_exec_and_raise(command, exception, times = 1)
    expect_to_receive_exactly_ordered_and_raise(
      times, bundler, :execute_command, exception, command
    )
  end
end
