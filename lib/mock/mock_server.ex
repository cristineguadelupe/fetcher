defmodule Fetcher.MockServer do
  # Mock server for tests
  @moduledoc false
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @mimetype "text/html"

  get "/" do
    conn
    |> put_resp_content_type(@mimetype)
    |> send_resp(200, """
    <img src="/logo.png">
    <img src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==">
    <a href="/relative_link.html">Relative link</a>
    <a href="https://google.com">Google</a>
    <img src="https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_272x92dp.png">
    """)
  end

  get "/nolinks" do
    conn
    |> put_resp_content_type(@mimetype)
    |> send_resp(200, "No links and no assets!")
  end

  get "/data" do
    conn
    |> put_resp_content_type(@mimetype)
    |> send_resp(200, """
    <img src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==">
    """)
  end

  get "/relative" do
    conn
    |> put_resp_content_type(@mimetype)
    |> send_resp(200, """
    <a href="/relative_link.html">Relative link</a>
    """)
  end

  get "/doctest" do
    conn
    |> put_resp_content_type(@mimetype)
    |> send_resp(200, """
    <a href="https://livebook.dev">Livebook</a>
    <a href="https://google.com">Google</a>
    <img src="/logo.png">
    """)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
