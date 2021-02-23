defmodule Tvirus.ResourceTest do
  use Tvirus.DataCase

  alias Tvirus.Resource
  import Tvirus.Factory

  describe "items" do
    alias Tvirus.Resource.Item

    test "list_items/0 returns all items" do
      item = insert(:item)

      assert [subject] = Resource.list_items()
      assert subject.id == item.id
    end

    test "get_item!/1 returns the item with given id" do
      item = insert(:item)

      assert subject = Resource.get_item!(item.id)
      assert subject.id == item.id
      assert subject.name == item.name
      assert subject.points == item.points
    end

    test "create_item/1 with valid data creates a item" do
      params = params_for(:item)

      assert {:ok, %Item{} = subject} = Resource.create_item(params)
      assert subject.name == params.name
      assert subject.points == params.points
    end

    test "create_item/1 with invalid data returns error changeset" do
      item = insert(:item)
      params = %{name: item.name}

      assert {:error, %Ecto.Changeset{}} = Resource.create_item(params)
    end

    test "update_item/2 with valid data updates the item" do
      item = insert(:item)
      params = %{name: "novo-#{item.name}"}

      assert {:ok, %Item{} = subject} = Resource.update_item(item, params)
      assert subject.id == item.id
      assert subject.name == params.name
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = insert(:item)
      item_two = insert(:item)
      params = %{name: item_two.name}

      assert {:error, %Ecto.Changeset{}} = Resource.update_item(item, params)
      assert item == Resource.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = insert(:item)

      assert {:ok, %Item{}} = Resource.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Resource.get_item!(item.id) end
    end
  end
end
