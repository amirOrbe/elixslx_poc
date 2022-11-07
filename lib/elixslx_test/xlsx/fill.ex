defmodule ElixslxTest.Xlsx.Fill do
  @moduledoc false

  alias ElixslxTest.Blog.Post
  alias ElixslxTest.Repo

  def bulk_insert do
    date =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    list_of_posts =
      1..10_000
      |> Stream.map(fn _ ->
        generate_post(date)
      end)
      |> Stream.chunk_every(10_000)

    Repo.transaction(
      fn ->
        Enum.each(list_of_posts, fn posts ->
          Repo.insert_all(Post, posts)
        end)
      end,
      timeout: :infinity
    )

    :ok
  end

  def generate_post(date) do
    %{
      title: Faker.Lorem.paragraph(1..10) |> String.slice(0..150),
      views: Faker.Random.Elixir.random_between(1, 1_000_000),
      inserted_at: date,
      updated_at: date
    }
  end
end
