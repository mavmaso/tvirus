defmodule Tvirus.ItemFactory do
  defmacro __using__(_opts) do
    quote do
      def item_factory do
        %Tvirus.Resource.Item{
          name: Faker.Lorem.word(),
          points: (:rand.uniform(20) + 1)
        }
      end
    end
  end
end
