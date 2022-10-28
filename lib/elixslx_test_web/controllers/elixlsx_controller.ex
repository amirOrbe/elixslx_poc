defmodule ElixslxTestWeb.ElixlsxController do
  use ElixslxTestWeb, :controller
  require Elixlsx

  alias Xlsx.Builder

  def download(conn, _params) do
    xlsx_file = Builder.build_xlsx_file()

    send_download(
      conn,
      {:binary, xlsx_file},
      filename: "test.xlsx"
    )
  end
end
