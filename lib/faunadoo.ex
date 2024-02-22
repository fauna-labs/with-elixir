defmodule Faunadoo do
  alias HTTPoison

  def query(fql_expression, key) do
    url = "https://db.fauna.com/query/1"

    headers = [
      {"accept", "application/json, text/plain, */*"},
      {"authorization", "Bearer #{key}"},
      {"x-format", "simple"},
      {"x-typecheck", "false"}
    ]

    body = %{
      "query" => fql_expression,
      "arguments" => %{}
    }

    case HTTPoison.post(url, Jason.encode!(body), headers, hackney: [ssl: [{:versions, '[tlsv1.2]'}]]) do
      {:ok, %{status_code: 200, body: response_body}} ->
        {:ok, decode_response(response_body)}

      {:error, reason} ->
        {:error, "Failed to execute query: #{reason}"}
    end
  end

  defp decode_response(body) do
    {:ok, Jason.decode!(body)["data"]}
  end
end
