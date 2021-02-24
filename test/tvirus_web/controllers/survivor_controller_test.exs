defmodule TvirusWeb.SurvivorControllerTest do
  use TvirusWeb.ConnCase

  import Tvirus.Factory
  import Mock

  alias Tvirus.Resource

  setup %{conn: conn} do
    insert(:item, %{name: "Fiji Water", points: 14})
    insert(:item, %{name: "Campbell Soup", points: 12})
    insert(:item, %{name: "First Aid Pouch", points: 10})
    insert(:item, %{name: "AK47", points: 8})

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
          },
          inventory: [
            "Fiji Water",
            "Campbell Soup",
            "Campbell Soup",
            "First Aid Pouch",
            "AK47",
            "First Aid Pouch",
            "Campbell Soup"
          ]
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
      assert subject["inventory"]["fiji_water"] == 1
      assert subject["inventory"]["campbell_soup"] == 3
      assert subject["inventory"]["first_aid_pouch"] == 2
      assert subject["inventory"]["ak47"] == 1
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

  describe "flag/2" do
    test "with valid params but not flag 5 time yet, returns :ok", %{conn: conn} do
      survivor = insert(:survivor)
      params = %{flager_id: insert(:survivor).id}

      conn = put(conn, Routes.survivor_path(conn, :flag, survivor.id, params))

      assert subject = json_response(conn, 200)["data"]
      assert subject["id"] == survivor.id
      assert subject["infected"] == false
    end

    test "with valid params and already flag 4, returns :ok", %{conn: conn} do
      survivor = insert(:survivor)

      key = String.to_atom("#{survivor.id}")
      assert {:ok, table} = :dets.open_file(:flag, [type: :set])
      assert :dets.insert(table, {key, ["ola","oi","yo","hi"]})

      params = %{flager_id: insert(:survivor).id}

      conn = put(conn, Routes.survivor_path(conn, :flag, survivor.id, params))

      assert subject = json_response(conn, 200)["data"]
      assert subject["id"] == survivor.id
      assert subject["infected"] == true

      assert :dets.delete(table, key)
      assert :dets.close(table)
    end
  end

  describe "reports/2" do
    test "percentage of infected survivors, returns :ok", %{conn: conn} do
      insert(:survivor,%{inventory: [
        Resource.get_item_by_name("Fiji Water"),
        Resource.get_item_by_name("First Aid Pouch")
      ]})
      insert(:survivor,%{inventory: [
        Resource.get_item_by_name("Campbell Soup"),
        Resource.get_item_by_name("AK47"),
        Resource.get_item_by_name("First Aid Pouch")
      ]})
      insert(:survivor,%{inventory: [Resource.get_item_by_name("Campbell Soup")]})
      insert(:survivor, %{infected: true, inventory: [Resource.get_item_by_name("AK47")]})
      insert(:survivor, %{infected: true, inventory: [Resource.get_item_by_name("AK47")]})

      items_map = %{
        "fiji_water" => "1/5",
        "campbell_soup" => "2/5",
        "first_aid_pouch" => "2/5",
        "ak47" => "3/5"
      }

      conn = get(conn, Routes.survivor_path(conn, :reports))

      assert subject = json_response(conn, 200)["data"]
      assert subject["infected"] == "40.0%"
      assert subject["non_infected"] == "60.0%"
      assert subject["items_per_survivors"] == items_map
      assert subject["lost_points"] == 16
    end
  end
end
