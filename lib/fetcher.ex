defmodule Fetcher do
  @moduledoc """
  Documentation for `Fetcher`.
  """

  @doc """
  Fetches the given URL and returns a map with `:assets` and `:links`,
  containing all URLs present in the <img> and <a> tags respectively.
  Normalizes relative links into absolutes.

  ## Examples

      iex> Fetcher.fetch("http://localhost:8080/doctest")
      %{
        assets: ["http://localhost:8080/doctest/logo.png"],
        links: ["https://livebook.dev", "https://google.com"]
      }
  """

  def fetch(url) do
    with {:ok, response} <- Req.get(url),
         {:ok, html} <- Floki.parse_document(response.body) do
      %{
        assets: Floki.attribute(html, "img", "src") |> normalize(url),
        links: Floki.attribute(html, "a", "href") |> normalize(url)
      }
    else
      {:error, reason} -> reason
    end
  end

  defp normalize(links, url) do
    Enum.map(links, &if(URI.new!(&1).scheme, do: &1, else: "#{url}#{&1}"))
  end
end
