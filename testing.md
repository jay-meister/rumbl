Testing

mix test

mix test ./test/controllers/category_controller_test.exs:4


Add helper functions to tests:
./test/support/test_helpers.ex
```elixir
defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo

  def insert_users(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "supersecret"
      }, attrs)

      %Rumbl.User{}
      |> Rumbl.User.registration_changeset(changes)
      |> Repo.insert!
  end

  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end
end
```

in ./test/support/conn_case.ex
```elixir
  import Rumbl.Router.Helpers
  import Rumbl.TestHelpers
```

Now insert_users and insert_video are available in tests:
```elixir
defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  test "requires user auth on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      put(conn, video_path(conn, :update, "123", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "123"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
```
