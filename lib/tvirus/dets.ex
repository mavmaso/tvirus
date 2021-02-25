defmodule Tvirus.DETS do
    @moduledoc """
  The module responsable for DETS
  """

  @doc """
  Returns and flags, if already not, the list of Survivors' id that flaged a Survivor.
  Both id need to different if not returns `[]`
  """
  def list_flager(survivor_id, flager_id) when survivor_id != flager_id do
    key = String.to_atom("#{survivor_id}")
    {:ok, table} = :dets.open_file(:flag, [type: :set])

    response =
      case :dets.lookup(table, key) do
        [] ->
          true = :dets.insert_new(table, {key, [flager_id]})
          [flager_id]
        value ->
          list = if value[key] != [flager_id], do: value[key] ++ [flager_id], else: value[key]
          :dets.insert(table, {key, [flager_id]})
          list
      end

    :dets.close(:flag)
    response
  end

  def list_flager(survivor_id, flager_id) when survivor_id == flager_id, do: []
end
