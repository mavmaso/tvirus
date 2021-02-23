defmodule Tvirus.Player do
  @moduledoc """
  The Player context.
  """

  import Ecto.Query, warn: false
  alias Tvirus.Repo

  alias Tvirus.Player.Survivor

  defp check_transaction(transaction) do
    case transaction do
      {:ok, {_, _} = repo} -> repo
      _ -> {:error, :transaction_error}
    end
  end

  @doc """
  Returns the list of survivors.

  ## Examples

      iex> list_survivors()
      [%Survivor{}, ...]

  """
  def list_survivors do
    Repo.all(Survivor)
  end

  @doc """
  Gets a single survivor.

  Returns `{:error, not_found}` if the Survivor does not exist.
  Or returns `{:ok, %Survivor{}}`.
  """
  def get_survivor(id) do
    case Repo.get(Survivor, id) do
      %Survivor{} = survivor -> {:ok, survivor}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Gets a single survivor.

  Raises `Ecto.NoResultsError` if the Survivor does not exist.

  ## Examples

      iex> get_survivor!(123)
      %Survivor{}

      iex> get_survivor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survivor!(id), do: Repo.get!(Survivor, id)

  @doc """
  Creates a survivor.

  ## Examples

      iex> create_survivor(%{field: value})
      {:ok, %Survivor{}}

      iex> create_survivor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survivor(attrs) do
    Repo.transaction(fn ->
      %Survivor{}
      |> Survivor.changeset(attrs)
      |> Repo.insert()
    end, timeout: :infinity)
    |> check_transaction()
  end

  @doc """
  Updates a survivor.

  ## Examples

      iex> update_survivor(survivor, %{field: new_value})
      {:ok, %Survivor{}}

      iex> update_survivor(survivor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survivor(%Survivor{} = survivor, attrs) do
    Repo.transaction(fn ->
      survivor
      |> Survivor.changeset(attrs)
      |> Repo.update()
    end, timeout: :infinity)
    |> check_transaction()
  end

  @doc """
  Deletes a survivor.

  ## Examples

      iex> delete_survivor(survivor)
      {:ok, %Survivor{}}

      iex> delete_survivor(survivor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survivor(%Survivor{} = survivor) do
    Repo.transaction(fn ->
      Repo.delete(survivor)
    end, timeout: :infinity)
    |> check_transaction()
  end
end
