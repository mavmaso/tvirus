defmodule Tvirus.InventoryFactory do
  defmacro __using__(_opts) do
    quote do
      def inventory_factory do
        %Tvirus.Resource.Inventory{
          item_id: insert(:item).id,
          survivor_id: insert(:survivor).id
        }
      end
    end
  end
end
