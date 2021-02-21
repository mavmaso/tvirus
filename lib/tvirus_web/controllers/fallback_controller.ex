defmodule TvirusWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TvirusWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TvirusWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TvirusWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, msg}) when is_atom(msg) do
    conn
    |> put_status(:bad_request)
    |> put_view(TvirusWeb.ErrorView)
    |> render("custom_error.json", %{msg: msg})
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(:bad_request)
    |> put_view(TvirusWeb.ErrorView)
    |> render(:"400")
  end
end
