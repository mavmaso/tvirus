defmodule TvirusWeb.UserSocketTest do
  use TvirusWeb.ChannelCase, async: true
  alias TvirusWeb.UserSocket

  test "connect to the socket" do
    assert {:ok, socket} = connect(UserSocket, %{})
    assert socket.assigns.test == true
  end
end
