defmodule TvirusWeb.RoomChannelTest do
  use TvirusWeb.ChannelCase, async: true

  alias TvirusWeb.RoomChannel
  alias TvirusWeb.UserSocket

  setup do
    {:ok, _reply, socket} =
      TvirusWeb.UserSocket
      |> socket()
      |> subscribe_and_join(TvirusWeb.RoomChannel, "room:1", %{})

    %{socket: socket}
  end


  test "subscribe to room:1" do
    {:ok, socket} = connect(UserSocket, %{})

    {:ok, _, socket} = subscribe_and_join(socket, "room:#{1}", %{})

    assert socket.assigns.room_id == "1"
  end

  test "broadcasts update event to room:1 topic", %{socket: socket} do
    assert socket.joined == true
    assert socket.topic == "room:1"

    TvirusWeb.Endpoint.broadcast("room:1", "update", %{"test" => "content"})

    assert_broadcast("update", %{"test" => "content"})
  end
end
