defmodule AnalyzerWeb.PageController do
  use AnalyzerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def analyze(conn, %{"url" => url}) do
    {status, _} = Analyzer.validate_uri(url)

    if status == :ok do
      case Analyzer.excute(url) do
        {:ok, res} ->
          conn
          |> put_flash(:info, "Analyze successfully.")

          render(conn, "analyze.html", res: res)

        {:error, _} ->
          conn
          |> put_flash(:info, "Analyze failed.")
          |> redirect(to: Routes.page_path(conn, :index))
      end
    else
      conn
      |> put_flash(:info, "Link problem")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
