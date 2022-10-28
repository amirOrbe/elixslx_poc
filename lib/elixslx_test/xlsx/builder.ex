defmodule Xlsx.Builder do
  @moduledoc false
  require Elixlsx

  alias Elixlsx.{Sheet, Workbook}
  alias ElixslxTest.Blog.Post
  alias ElixslxTest.Repo

  def get_posts do
    stream = Repo.stream(Post)

    {:ok, posts} =
      Repo.transaction(
        fn ->
          Enum.map(stream, fn post ->
            [
              post.id,
              post.title,
              post.views,
              NaiveDateTime.to_string(post.inserted_at),
              NaiveDateTime.to_string(post.updated_at)
            ]
          end)
        end,
        timeout: :infinity
      )

    [headers() | posts]
  end

  defp headers do
    [
      "id",
      "title",
      "views",
      "inserted_at",
      "updated_at",
      "value",
      "total of value",
      "date format",
      "number format"
    ]
  end

  def fake_post_list do
    posts =
      Enum.map(1..100, fn n ->
        [
          n,
          "ngihgirg",
          n + 1,
          "#{NaiveDateTime.utc_now()}",
          "#{NaiveDateTime.utc_now()}",
          1
        ]
      end)

    [headers() | posts]
  end

  def build_xlsx_file do
    posts = fake_post_list()

    sheet =
      %Sheet{
        name: "Posts",
        rows: posts
      }
      |> Sheet.set_cell("G2", {:formula, "SUM(F2:F101)"},
        num_format: "0.00",
        bold: true
      )
      |> Sheet.set_cell("H2", {:formula, "NOW()"}, num_format: "yy-mm-dd")
      |> Sheet.set_cell("I2", Enum.random(1..10), num_format: "0.0000")
      |> Sheet.set_cell("J2", {:formula, "CONCAT(B2:B101)"})

    workbook = %Workbook{sheets: [sheet]}

    {:ok, {_, data_xlsx}} = Elixlsx.write_to_memory(workbook, "example.xlsx")

    data_xlsx
  end
end
