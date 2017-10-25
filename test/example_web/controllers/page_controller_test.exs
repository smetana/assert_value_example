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
    |> canonicalize_response
  end

  defp canonicalize_response(text) do
    text
    |> String.replace(~r/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+Z/, "<TIMESTAMP>")
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert_value serialize_response(conn) == """
    Status: 200
    Title: My App Example!
    h2: Welcome to Phoenix!
    h4: Resources
    h4: Help
    h4: Created: <TIMESTAMP>
    """
  end

  test "GET /hello", %{conn: conn} do
    conn = get conn, "/hello"
    assert_value serialize_response(conn) == """
    Status: 200
    Title: My App Example!
    h2: Hello World
    h4: Created: <TIMESTAMP>
    """
  end
end
