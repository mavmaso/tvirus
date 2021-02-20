defmodule TvirusWeb.SurvivorControllerTest do
  use TvirusWeb.ConnCase

  import Tvirus.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up" do
    test "Add a survivor, returns :ok", %{conn: conn} do
      params = %{
        name: Faker.Person.PtBr.name(),
        age: (:rand.uniform(99) + 1),
        gender: Enum.random(["M", "F"]),
        last_location: %{
          latitude: 15.12,
          longitude: -30.34
        }
      }

      conn = post(conn, Routes.survivor_path(conn, :sign_up, params))

      assert subject = json_response(conn, 200)["data"]["survivor"]
      assert subject["id"] |> is_integer()
      assert subject["name"] == params.name
      assert subject["age"] == params.age
      assert subject["gender"] == params.gender
      assert subject["last_location"]["latitude"] == params.last_location.latitude
      assert subject["last_location"]["longitude"] == params.last_location.longitude
    end
  end
end
