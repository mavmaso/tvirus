defmodule TvirusWeb.SurvivorControllerTest do
  use TvirusWeb.ConnCase

  import Tvirus.Factory
  import Mock

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up/2" do
    test "with valid params, returns :ok", %{conn: conn} do
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

    test "with PostgreSQL error, returns :error", %{conn: conn} do
      with_mock Tvirus.Repo, transaction: fn _func, _opt -> {:error, %{}} end do
        params = %{survivor: %{name: Faker.Person.PtBr.name()}}

        conn = post(conn, Routes.survivor_path(conn, :sign_up, params))

        assert %{"errors" => %{"detail" => "transaction_error"}} = json_response(conn, 400)
      end
    end
  end

  describe "location/2" do
    test "with valid params, returns :ok", %{conn: conn} do
      survivor = insert(:survivor)
      params = %{
        last_location: %{
          latitude: "37.421925",
          longitude: "-122.0841293"
        }
      }

      conn = put(conn, Routes.survivor_path(conn, :location, survivor.id, params))

      assert subject = json_response(conn, 200)["data"]
      assert subject["id"] == survivor.id
      assert "#{subject["last_location"]["latitude"]}" == params.last_location.latitude
      assert "#{subject["last_location"]["longitude"]}" == params.last_location.longitude
    end

    test "with invalid id, returns :error", %{conn: conn} do
      params = %{last_location: %{}}

      conn = put(conn, Routes.survivor_path(conn, :location, 1, params))

      assert %{"detail" => "Not Found"} = json_response(conn, 404)["errors"]
    end
  end
end
