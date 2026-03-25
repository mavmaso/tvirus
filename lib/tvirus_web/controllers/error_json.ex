defmodule TvirusWeb.ErrorJSON do
  def custom_error(%{msg: msg}), do: %{errors: %{detail: msg}}

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
