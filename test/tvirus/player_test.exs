defmodule Tvirus.PlayerTest do
  use Tvirus.DataCase

  alias Tvirus.Player
  import Tvirus.Factory

  describe "survivors" do
    alias Tvirus.Player.Survivor

    test "list_survivors/0 returns all survivors" do
      survivor = insert(:survivor)

      assert [subject] = Player.list_survivors()
      assert subject.name == survivor.name
      assert subject.id == survivor.id
    end

    test "get_survivor!/1 returns the survivor with given id" do
      survivor = insert(:survivor)

      assert subject = Player.get_survivor!(survivor.id)
      assert subject.name == survivor.name
      assert subject.id == survivor.id
    end

    test "create_survivor/1 with valid data creates a survivor" do
      params = params_for(:survivor)

      assert {:ok, %Survivor{} = subject} = Player.create_survivor(params)
      assert subject.age == params.age
      assert subject.gender == params.gender
      assert subject.latitude == params.latitude
      assert subject.longitude == params.longitude
      assert subject.name == params.name
      assert subject.infected == params.infected
    end

    test "create_survivor/1 with invalid data returns error changeset" do
      params = %{
        name: "oi",
        age: 0,
        gender: "male"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Player.create_survivor(params)
      assert {"should be at least %{count} character(s)", _} = changeset.errors[:name]
      assert {"must be greater than %{number}", _} = changeset.errors[:age]
      assert {"is invalid", _} = changeset.errors[:gender]
      assert changeset.errors[:latitude]
      assert changeset.errors[:longitude]
    end

    test "update_survivor/2 with valid data updates the survivor" do
      survivor = insert(:survivor)
      params = %{age: 60, infected: true}

      assert {:ok, %Survivor{} = subject} = Player.update_survivor(survivor, params)
      assert subject.id == survivor.id
      assert subject.age == params.age
      assert subject.infected == params.infected
    end

    test "update_survivor/2 with invalid data returns error changeset" do
      survivor = insert(:survivor)
      params = %{name: nil}

      assert {:error, %Ecto.Changeset{}} = Player.update_survivor(survivor, params)
      assert survivor == Player.get_survivor!(survivor.id)
    end

    test "delete_survivor/1 deletes the survivor" do
      survivor = insert(:survivor)

      assert {:ok, %Survivor{}} = Player.delete_survivor(survivor)
      assert_raise Ecto.NoResultsError, fn -> Player.get_survivor!(survivor.id) end
    end
  end
end
