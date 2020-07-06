defmodule KaffyWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use KaffyWeb, :controller
      use KaffyWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: KaffyWeb
      import KaffyWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/kaffy_web/templates",
        namespace: KaffyWeb

      use Phoenix.HTML

      import KaffyWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
