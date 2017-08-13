defmodule FexrWeb.PageControllerTest do
  use FexrWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Fexr"
  end
end
