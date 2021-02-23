defmodule Tvirus.Resource.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :points, :integer

    timestamps()
  end

  @required ~w(name points)a
  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint(:name)
  end
end
