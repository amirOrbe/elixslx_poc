defmodule ElixslxTestWeb.ElixlsxController do
  use ElixslxTestWeb, :controller
  require Elixlsx

  alias Elixlsx.{Sheet, Workbook}

  def download(conn, _params) do
    sheet1 =
      Sheet.with_name("First")
      # Set cell B2 to the string "Hi". :)
      |> Sheet.set_cell("B2", "Hi")

    workbook = %Workbook{sheets: [sheet1]}

    sheet2 =
      %Sheet{
        name: "Second",
        rows: [["Encabezados", 2, 3, 4, 5], [1, 2], ["increased row height"], ["hello", "world"]]
      }
      |> Sheet.set_row_height(3, 40)

    {:ok, {_, data_xlsx}} =
      Workbook.append_sheet(workbook, sheet2) |> Elixlsx.write_to_memory("example.xlsx")

    send_download(
      conn,
      {:binary, data_xlsx},
      filename: "test.xlsx"
    )
  end
end
