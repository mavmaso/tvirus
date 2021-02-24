defmodule Tvirus.Player do
  @moduledoc """
  The Player context.
  """

  import Ecto.Query, warn: false
  alias Tvirus.{Repo, DETS, Resource}

  alias Tvirus.Player.Survivor
  alias Tvirus.Resource.Inventory

  defp check_transaction(transaction) do
    case transaction do
      {:ok, {_, _} = repo} -> repo
      _ -> {:error, :transaction_error}
    end
  end

  @doc """
  Check how many flag the Survivor already have and flag him/her if the flager didn't do yet.
  And if the survivor already have 5 stacks then mark him/her as infected.
  """
  def flag_survivor(%Survivor{} = survivor, flager_id) do
    length = DETS.list_flager(survivor.id, flager_id) |> length

    cond do
      length >= 5 ->
        update_survivor(survivor, %{infected: true})
      length < 5 ->
        {:ok, survivor}
    end
  end

  @doc """
  WIP
  """
  def reports do
    total_survivor = list_survivors() |> length()
    total_fiji_water = Resource.total_items_by_kind("Fiji Water")
    total_campbell_soup = Resource.total_items_by_kind("Campbell Soup")
    total_first_aid_pouch = Resource.total_items_by_kind("First Aid Pouch")
    total_ak47 = Resource.total_items_by_kind("AK47")

    %{
      infected: "#{((count_infected()/total_survivor) |> Float.round(2)) * 100}%",
      non_infected: "#{((count_non_infected()/total_survivor) |> Float.round(2)) * 100}%",
      items_per_survivors: %{
        fiji_water: "#{total_fiji_water}/#{total_survivor}",
        campbell_soup: "#{total_campbell_soup}/#{total_survivor}",
        first_aid_pouch: "#{total_first_aid_pouch}/#{total_survivor}",
        ak47: "#{total_ak47}/#{total_survivor}"
      },
      lost_points: lost_points()
    }
  end

  defp count_infected do
    Survivor
    |> where([s], s.infected == true)
    |> Repo.all()
    |> length()
  end

  defp count_non_infected do
    Survivor
    |> where([s], s.infected == false)
    |> Repo.all()
    |> length()
  end

  defp lost_points do
    Inventory
    |> join(:inner, [inven], item in assoc(inven, :item))
    |> join(:inner, [inven], survivor in assoc(inven, :survivor))
    |> where([_inven, _item, survivor], survivor.infected == true)
    |> select([_inven, item, _survivor], item.points)
    |> Repo.all
    |> Enum.reduce(fn item, acc -> item + acc end)
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
