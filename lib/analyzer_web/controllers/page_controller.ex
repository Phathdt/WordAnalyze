defmodule AnalyzerWeb.PageController do
  use AnalyzerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
