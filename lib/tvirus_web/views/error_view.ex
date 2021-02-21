defmodule TvirusWeb.ErrorView do
  use TvirusWeb, :view

  def render("custom_error.json", %{msg: msg}) do
    %{errors: %{detail: msg}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
