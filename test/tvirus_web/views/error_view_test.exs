defmodule TvirusWeb.ErrorJSONTest do
  use TvirusWeb.ConnCase, async: true

  test "renders 404.json" do
    assert TvirusWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert TvirusWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
