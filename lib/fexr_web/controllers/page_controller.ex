defmodule FexrWeb.PageController do
  use FexrWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
