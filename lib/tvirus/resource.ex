defmodule Tvirus.Resource do
  @moduledoc """
  The Resource context.
  """

  import Ecto.Query, warn: false
  alias Tvirus.Repo

  alias Tvirus.Resource.{Item, Inventory}

  @doc """
  Count the total of one kind of item.
  """
  @spec total_items_by_kind(String.t()) :: integer()
  def total_items_by_kind(kind) do
    Inventory
    |> join(:inner, [i], item in assoc(i, :item))
    |> where([_i, item], item.name == ^kind)
    |> Repo.all()
    |> length()
  end

  @doc """
  Transfers the ownership of an item from one survivor for another. If it is possible.
  """
  @spec transfer_items(integer(), String.t(), integer(), integer()) :: :ok
  def transfer_items(number, item_name, survivor_id, new_survivor_id) when number > 0 do
    {:ok, {:ok, _}} =
      get_inventory_item!(item_name, survivor_id)
      |> update_inventory_item(%{survivor_id: new_survivor_id})

    acc = number - 1
    transfer_items(acc, item_name, survivor_id, new_survivor_id)
  end

  def transfer_items(0, _, _, _), do: :ok

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  @spec list_items :: [Item.t()]
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.
  """
  @spec get_item!(String.t()) :: Item.t() | nil
  def get_item_by_name(name), do: Item |> where([i], i.name == ^name) |> Repo.one()

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_item!(integer()) :: Item.t()
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_item(map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_item(Item.t(), map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_item(Item.t()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Get a single item in someone's inventory.
  Returns `%Inventory{}` or `[]`
  """
  def get_inventory_item!(item_name, survivor_id) do
    Inventory
    |> join(:inner, [i], item in assoc(i, :item))
    |> where([_i, item], item.name == ^item_name)
    |> where([i, _item], i.survivor_id == ^survivor_id)
    |> Repo.all()
    |> List.first()
  end

  @doc """
  Updates a item in someone's inventory.
  Returns `{:ok, %Inventory{}}` or if not `{:error, %Ecto.Changeset{}}`
  """
  @spec update_inventory_item(Inventory.t(), map()) ::
          {:ok, Inventory.t()} | {:ok, {:ok, nil}} | {:error, Ecto.Changeset.t()}
  def update_inventory_item(%Inventory{} = inventory, attrs) do
    Repo.transaction(fn ->
      inventory
      |> Inventory.changeset(attrs)
      |> Repo.update()
    end)
  end

  def update_inventory_item(_inventory, _attrs), do: {:ok, {:ok, nil}}
end
