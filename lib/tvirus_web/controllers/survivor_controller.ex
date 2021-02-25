defmodule TvirusWeb.SurvivorController do
  use TvirusWeb, :controller

  alias Tvirus.Player
  alias Tvirus.Player.Survivor
  alias Tvirus.Utils

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
        Player.update_survivor(survivor, %{latitude: params.latitude, longitude: params.longitude})
      do
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
    |> render("report.json", %{report: Player.reports})
  end

  def trade_items(conn, %{"survivor_id_one" => s1_id, "survivor_id_two" => s2_id} = params) do
    with {:ok, %Survivor{} = survivor_one} <- Player.get_survivor(s1_id),
      {:ok, %Survivor{} = survivor_two} <- Player.get_survivor(s2_id) do

      [survivor_one |> Tvirus.Repo.preload([:inventory]), survivor_two, params]

      conn
      |> put_status(:ok)
      |> json(%{data: "WIP"})
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
end
