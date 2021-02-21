defmodule Tvirus.Player.Survivor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivors" do
    field :age, :integer
    field :gender, :string
    field :name, :string
    field :latitude, :float
    field :longitude, :float
    field :infected, :boolean, default: false

    timestamps()
  end

  @required ~w(name age gender latitude longitude)a
  @optional ~w(infected)a
  @doc false
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
