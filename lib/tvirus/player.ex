defmodule Tvirus.Player do
  @moduledoc """
  The Player context.
  """

  import Ecto.Query, warn: false
  alias Tvirus.{Repo, DETS, Resource}

  alias Tvirus.Player.Survivor
  alias Tvirus.Resource.Inventory
  alias Tvirus.{Utils, Resource}

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
  Returns a map with the 4 types of reports: Infected, Non Infected, Items per survivors, Lost points.
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
    |> Enum.reduce(0, fn item, acc -> item + acc end)
  end

  @doc """
  Returns an easy map for see and manipulate the inventory.
  """
  def build_inventory(survivor) do
    neo_survivor = Repo.preload(survivor, [:inventory])

    %{
      fiji_water: count_items(neo_survivor.inventory, "Fiji Water"),
      campbell_soup: count_items(neo_survivor.inventory, "Campbell Soup"),
      first_aid_pouch: count_items(neo_survivor.inventory, "First Aid Pouch"),
      ak47: count_items(neo_survivor.inventory, "AK47")
    }
  end

  defp count_items(inventory, item_name) do
    Enum.reduce(inventory, 0, fn item, acc -> if item.name == item_name, do: acc + 1, else: acc end)
  end

  @doc """
  Check inventory before trades, if it's a fair trade or not and if both have what they said they have.
  """
  def check_inventory(survivor_one, survivor_two, %{trade_one: t_one, trade_two: t_two}) do
    one = points_per_survivor(survivor_one, t_one)
    two = points_per_survivor(survivor_two, t_two)

    cond do
      one == false or two == false -> {:error, :unfair_or_fake_trade}
      one == two -> {:ok, :fair}
      true -> {:error, :unfair_or_fake_trade}
    end

    # case one == two do
    #   true -> {:ok, :fair}
    #   _ -> {:error, :unfair_or_fake_trade}
    # end
  end

  defp points_per_survivor(%Survivor{} = survivor, trade_map) do
    inventory_map = build_inventory(survivor)
    map = Utils.fix_trade_map(trade_map)  # due to controller test issue, a little hot fix
    real? =
      Enum.map(inventory_map, fn {k, v} -> map[k] <= v end)
      |> Enum.find(&(&1 == false))
      |> is_nil()

    case real? do
      true ->
        sum_points(trade_map)
      _ ->
        false
    end
  end

  defp sum_points(inventory_map) do
    Enum.reduce(inventory_map, 0, fn {k,v}, acc->
      {key, value} = Utils.build_trade_key_value(k, v)
      item = Resource.get_item_by_name(key)
      (item.points * value) + acc
    end)
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
  Gets a single survivor if not infected yet.

  Returns `{:error, not_found}` if the Survivor does not exist or returns `{:error, :infected}` if infected already.
  Or returns `{:ok, %Survivor{}}`.
  """
  def get_non_infected(id) do
    case Repo.get(Survivor, id) do
      %Survivor{infected: false} = survivor -> {:ok, survivor}
      %Survivor{infected: true} -> {:error, :infected}
      _ -> {:error, :not_found}
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
