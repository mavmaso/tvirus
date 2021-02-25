defmodule TvirusWeb.Router do
  use TvirusWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TvirusWeb do
    pipe_through :api

    get "/reports", SurvivorController, :reports

    post "/sign_up", SurvivorController, :sign_up
    post "/trade_items", SurvivorController, :trade_items

    put "/location/:id", SurvivorController, :location
    put "/flag/:id", SurvivorController, :flag
  end
end
