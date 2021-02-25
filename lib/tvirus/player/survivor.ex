defmodule Tvirus.Player.Survivor do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tvirus.Resource

  schema "survivors" do
    field :age, :integer
    field :gender, :string
    field :name, :string
    field :latitude, :float
    field :longitude, :float
    field :infected, :boolean, default: false

    many_to_many :inventory, Tvirus.Resource.Item,
      join_through: "inventory",
      on_replace: :delete,
      on_delete: :delete_all

    timestamps()
  end

  @required ~w(name age gender latitude longitude)a
  @optional ~w(infected)a
  @doc false
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> prepare_inventory(attrs)
    |> validate_length(:name, min: 3)
    |> validate_number(:age, greater_than: 0)
    |> validate_inclusion(:gender, ["M", "F"])
    |> unique_constraint(:name)
  end

  defp prepare_inventory(changeset, %{inventory: inventory}) do
    list =
      Enum.map(inventory, fn item_name -> Resource.get_item_by_name(item_name) end)
      |> Enum.filter(& !is_nil(&1))

    put_assoc(changeset, :inventory, list)
  end

  defp prepare_inventory(changeset, _), do: changeset
end
