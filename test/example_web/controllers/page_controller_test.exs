defmodule ExampleWeb.PageControllerTest do
  use ExampleWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200)
    body = html_response(conn, 200)
    title = Floki.find(body, "title")
      |> Floki.text
    assert title == "Hello Example!"
    header = Floki.find(body, "h2")
      |> Floki.text
    assert header == "Welcome to Phoenix!"
    sections = Floki.find(body, "h4")
      |> Enum.map(&Floki.text/1)
    assert sections == ["Resources", "Help"]
  end
end
