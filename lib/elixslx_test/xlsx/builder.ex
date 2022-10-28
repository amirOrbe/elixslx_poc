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
      "updated_at"
    ]
  end

  def fake_post_list do
    posts =
      Enum.map(1..100, fn n ->
        [
          "ngihgirg",
          n,
          "#{NaiveDateTime.utc_now()}",
          "#{NaiveDateTime.utc_now()}"
        ]
      end)

    [headers() | posts]
  end

  def build_xlsx_file do
    posts = get_posts()

    sheet = %Sheet{
      name: "Posts",
      rows: posts
    }

    workbook = %Workbook{sheets: [sheet]}

    {:ok, {_, data_xlsx}} = Elixlsx.write_to_memory(workbook, "example.xlsx")

    data_xlsx
  end
end
