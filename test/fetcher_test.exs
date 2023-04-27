defmodule FetcherTest do
  use ExUnit.Case
  doctest Fetcher

  @base_url "http://localhost:8080"

  @urls [
    "https://google.com",
    "https://livebook.dev",
    "https://github.com",
    "https://elixir-lang.org",
    "https://elixirschool.com/en"
  ]

  test "get all links" do
    assert Fetcher.fetch(@base_url) == %{
             assets: [
               "http://localhost:8080/logo.png",
               "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
               "https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_272x92dp.png"
             ],
             links: ["http://localhost:8080/relative_link.html", "https://google.com"]
           }
  end

  test "no links and no assets" do
    assert Fetcher.fetch(@base_url <> "/nolinks") == %{assets: [], links: []}
  end

  test "normalize relative urls" do
    assert Fetcher.fetch(@base_url <> "/relative") == %{
             assets: [],
             links: [@base_url <> "/relative/relative_link.html"]
           }
  end

  test "preserve assets with data scheme" do
    assert Fetcher.fetch(@base_url <> "/data") == %{
             assets: [
               "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
             ],
             links: []
           }
  end

  # External calls. Excluded by default. Run using `mix test --include external:true`
  @tag :external
  test "all links and assets are valid URIs with scheme" do
    for url <- @urls do
      links = Fetcher.fetch(url)
      assert Enum.map(links.assets, &URI.new!(&1).scheme) |> Enum.all?()
      assert Enum.map(links.links, &URI.new!(&1).scheme) |> Enum.all?()
    end
  end
end
