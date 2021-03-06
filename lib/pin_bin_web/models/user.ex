defmodule PinBin.User do
  @moduledoc"""
  User model.

  A user of the application.
  """
  use PinBinWeb, :model

  @required_fields ~w(email username password)a
  @optional_fields ~w(admin)a

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean
    has_many :bins, PinBin.Bin
    has_many :pins, PinBin.Pin

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_changeset
  end

  @doc """
  Enforces registration logic on changeset.
  """
  def registration_changeset(struct, params) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_changeset
  end

  defp validate_changeset(struct) do
    struct
    |> unique_constraint(:email, [name: :users_email_index])
    |> unique_constraint(:username, [name: :users_username_index])
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
    |> downcase_email
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true,
                      changes: %{password: password}} ->
        put_change(changeset,
                   :password_hash,
                   Comeonin.Bcrypt.hashpwsalt(password))
      _ -> changeset
    end
  end

  defp downcase_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        put_change(changeset, :email, String.downcase(email))
      _ -> changeset
    end
  end
end
