defmodule Tvirus.Resource.Inventory do
  use Ecto.Schema
  # import Ecto.Changeset

  @primary_key false
  schema "inventory" do
    belongs_to(:survivor, Tvirus.Player.Survivor)
    belongs_to(:item, Tvirus.Resource.Item)
  end
end
