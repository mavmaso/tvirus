defmodule TvirusWeb.RoomChannel do
  use TvirusWeb, :channel

  intercept(["update"])

  def join("room:" <> room_id, _params, socket) do
    # send(self(), :after_join)

    {:ok, assign(socket, :room_id, room_id)}
  end

  # def handle_in("update", params, socket) do
  #   broadcast!(socket, params, %{})
  # end

  def handle_out("update", payload, socket) do
    push(socket, "update", %{data: payload})

    {:noreply, socket}
  end
end
