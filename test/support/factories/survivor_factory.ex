defmodule Tvirus.SurvivorFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Faker.Person.PtBr
      alias Tvirus.Player.Survivor

      def survivor_factory do
        %Survivor{
          name: PtBr.name(),
          age: :rand.uniform(99) + 1,
          gender: Enum.random(["M", "F"]),
          latitude: 15.12,
          longitude: -30.34,
          infected: false
        }
      end
    end
  end
end
