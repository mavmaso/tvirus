defmodule TvirusWeb.SurvivorControllerTest do
  use TvirusWeb.ConnCase

  # import Tvirus.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up" do
    test "Add a survivor, returns :ok", %{conn: conn} do
      params = %{
        survivor: %{
          name: Faker.Person.PtBr.name(),
          age: (:rand.uniform(99) + 1),
          gender: Enum.random(["M", "F"]),
          last_location: %{
            latitude: "15.12",
            longitude: "-30.34"
          }
        }
      }

      conn = post(conn, Routes.survivor_path(conn, :sign_up, params))

      assert subject = json_response(conn, 201)["data"]
      assert subject["id"] |> is_integer()
      assert subject["name"] == params.survivor.name
      assert subject["age"] == params.survivor.age
      assert subject["gender"] == params.survivor.gender
      assert "#{subject["last_location"]["latitude"]}" == params.survivor.last_location.latitude
      assert "#{subject["last_location"]["longitude"]}" == params.survivor.last_location.longitude
      assert subject["infected"] == false
    end

    test "with invalid params, returns :error", %{conn: conn} do
      params = %{
        survivor: %{
          name: Faker.Person.PtBr.name(),
          age: (:rand.uniform(99) + 1),
          gender: Enum.random(["M", "F"]),
          last_location: %{
            latitude: nil,
          }
        }
      }

      conn = post(conn, Routes.survivor_path(conn, :sign_up, params))

      assert %{"errors" => %{"latitude" =>  _, "longitude" =>  _}} = json_response(conn, 422)
    end
  end
end
