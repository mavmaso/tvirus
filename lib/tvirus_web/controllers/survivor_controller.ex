defmodule TvirusWeb.SurvivorController do
  use TvirusWeb, :controller

  alias Tvirus.{Player, Resource, Utils}
  alias Tvirus.Player.Survivor

  action_fallback TvirusWeb.FallbackController

  def sign_up(conn, %{"survivor" => survivor_params}) do
    with params <- clean_params(survivor_params),
         {:ok, %Survivor{} = survivor} <- Player.create_survivor(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{survivor: survivor})
    end
  end

  def location(conn, %{"id" => id} = old_params) do
    with params <- clean_params(Map.delete(old_params, "id")),
         {:ok, %Survivor{} = survivor} <- Player.get_survivor(id),
         {:ok, %Survivor{} = neo_survivor} <-
           Player.update_survivor(survivor, %{
             latitude: params.latitude,
             longitude: params.longitude
           }) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{survivor: neo_survivor})
    end
  end

  def flag(conn, %{"id" => id, "flager_id" => flager_id}) do
    with {:ok, %Survivor{} = survivor} <- Player.get_survivor(id),
         {:ok, %Survivor{}} <- Player.get_survivor(flager_id),
         {:ok, neo_survivor} <- Player.flag_survivor(survivor, flager_id) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{survivor: neo_survivor})
    end
  end

  def reports(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("report.json", %{report: Player.reports()})
  end

  def trade_items(conn, %{"survivor_id_one" => s1_id, "survivor_id_two" => s2_id} = params) do
    with {:ok, %Survivor{} = survivor_one} <- Player.get_non_infected(s1_id),
         {:ok, %Survivor{} = survivor_two} <- Player.get_non_infected(s2_id),
         {:ok, args} <- clean_trade(params),
         {:ok, :fair} <- Player.check_inventory(survivor_one, survivor_two, args) do
      Enum.each(args.trade_one, fn {k, v} ->
        {key, value} = Utils.build_trade_key_value(k, v)
        Resource.transfer_items(value, key, survivor_one.id, survivor_two.id)
      end)

      Enum.each(args.trade_two, fn {k, v} ->
        {key, value} = Utils.build_trade_key_value(k, v)
        Resource.transfer_items(value, key, survivor_two.id, survivor_one.id)
      end)

      survivors = [Player.get_survivor!(survivor_one.id), Player.get_survivor!(survivor_two.id)]

      conn
      |> put_status(:ok)
      |> render("index.json", %{survivors: survivors})
    end
  end

  defp clean_params(params) do
    args = Utils.atomify_map(params)
    latitude = args[:last_location][:latitude]
    longitude = args[:last_location][:longitude]

    args
    |> Map.delete(args[:last_location])
    |> Map.put(:latitude, str_to_float(latitude))
    |> Map.put(:longitude, str_to_float(longitude))
  end

  defp str_to_float(str) when str == "", do: nil

  defp str_to_float(str) when is_binary(str), do: String.to_float(str)

  defp str_to_float(_str), do: nil

  defp clean_trade(%{"trade_one" => trade_one, "trade_two" => trade_two}) do
    left_side = Utils.atomify_map(trade_one)
    right_side = Utils.atomify_map(trade_two)

    # TODO
    {:ok, %{trade_one: left_side, trade_two: right_side}}
  end

  defp clean_trade(_), do: {:error, :inventory}
end
