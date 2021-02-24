defmodule Tvirus.DETSTest do
  use Tvirus.DataCase

  alias Tvirus.DETS

  import Tvirus.Factory

  defp clear_DETS(survivor_id) do
    key = String.to_atom("#{survivor_id}")
    {:ok, table} = :dets.open_file(:flag, [type: :set])
    :dets.delete(table, key)

    :dets.close(:flag)
  end

  describe "list_flager/2" do
    test "first time usign this survivor_id, returns :ok" do
      survivor = insert(:survivor)
      flager = insert(:survivor)

      assert subject = DETS.list_flager(survivor.id, flager.id)

      assert subject == [flager.id]
      assert clear_DETS(survivor.id)
    end

    test "second time usign this survivor_id, returns :ok" do
      survivor = insert(:survivor)
      flager = insert(:survivor)
      flager_two = insert(:survivor)

      assert _subject = DETS.list_flager(survivor.id, flager.id)
      assert subject = DETS.list_flager(survivor.id, flager_two.id)

      assert subject == [flager.id, flager_two.id]
      assert clear_DETS(survivor.id)
    end

    test "same flager can't flag two time the same survivor, returns :ok" do
      survivor = insert(:survivor)
      flager = insert(:survivor)

      assert _subject = DETS.list_flager(survivor.id, flager.id)
      assert subject = DETS.list_flager(survivor.id, flager.id)

      assert subject == [flager.id]
      assert clear_DETS(survivor.id)
    end
  end
end
