defmodule Analyzer do
  @moduledoc """
  Analyzer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def excute(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        res =
          body
          |> Floki.parse_document!()
          |> Floki.text(style: false)
          |> String.graphemes()
          |> Enum.reduce(%{}, fn char, acc ->
            Map.put(acc, char, (acc[char] || 0) + 1)
          end)

        {:ok, res}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "not found"}

      {:ok, _} ->
        {:error, "not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def validate_uri(str) do
    uri = URI.parse(str)

    case uri do
      %URI{scheme: nil} -> {:error, uri}
      %URI{host: nil} -> {:error, uri}
      %URI{path: nil} -> {:error, uri}
      uri -> {:ok, uri}
    end
  end
end
