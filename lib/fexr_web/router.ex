defmodule FexrWeb.Router do
  use FexrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", FexrWeb do
    pipe_through :api

    get "/latest", ApiController, :latest
    get "/:date", ApiController, :historical
  end

  scope "/", FexrWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
