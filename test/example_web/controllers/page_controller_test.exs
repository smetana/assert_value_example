defmodule ExampleWeb.PageControllerTest do
  use ExampleWeb.ConnCase
  import AssertValue

  defp serialize_response(conn) do
    %Plug.Conn{status: status, resp_body: body} = conn
    "Status: #{status}" <>
    "\nTitle: " <>
    (body
      |> Floki.find("title")
      |> Floki.text) <>
    "\n" <>
    (body
      |> Floki.find("h1,h2,h3,h4")
      |> Enum.map(fn({tagName, _attrs, content}) ->
          "#{tagName}: #{Floki.text(content)}"
         end)
      |> Enum.join("\n")) <>
    "\n"
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert_value serialize_response(conn) == """
    Status: 200
    Title: My App Example!
    h2: Welcome to Phoenix!
    h4: Resources
    h4: Help
    """
  end

  test "GET /hello", %{conn: conn} do
    conn = get conn, "/hello"
    assert_value serialize_response(conn) == """
    Status: 200
    Title: My App Example!
    h2: Hello World
    """
  end
end
