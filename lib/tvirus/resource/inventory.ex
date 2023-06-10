defmodule Tvirus.Resource.Inventory do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory" do
    belongs_to(:survivor, Tvirus.Player.Survivor)
    belongs_to(:item, Tvirus.Resource.Item)
  end

  @required ~w(survivor_id)a
  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
