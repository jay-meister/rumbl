
## Make a dummy Repo database
in `/lib/rumbl/repo.ex`

```elixir
# use Ecto.Repo, otp_app: :rumbl
def all(Rumbl.User) do
  [%Rumbl.User{id: "1", name: "Jose", username: "josevalim", password: "elixir"},
  %Rumbl.User{id: "2", name: "Bruce", username: "redrapids", password: "7langs"},
  %Rumbl.User{id: "3", name: "Chris", username: "chrismccord", password: "phx"}]
end
def all(_module), do: []
def get(module, id) do
  Enum.find all(module), fn map -> map.id == id end
end
def get_by(module, params) do
  Enum.find all(module), fn map ->
    Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
  end
end
```

And disable the Ecto Repo supervisor in `/lib/rumbl/rumbl.ex`
```elixir
  # supervisor(Rumbl.Repo, []),
```

## Create template partials:

create a new file in given directory, render it using `<%= render "partial.html", user: @user`

## Changeset Action for error in form

```elixir
<%= if @changeset.action do %>
  <div class="alert alert-danger">
    <p>Ooops. Something went wrong</p>
  </div>
<% end %>

<%= text_input f, :name, placeholder: "Name", class: "form-control" %>
<%= error_tag f, :name %>

```
