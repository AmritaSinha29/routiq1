defmodule RoutiqWeb.UserRegistrationLive do
  use RoutiqWeb, :live_view

  alias Routiq.Accounts
  alias Routiq.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-surface relative overflow-hidden py-12">
      <!-- Background decoration -->
      <div class="absolute -top-40 -left-40 w-96 h-96 bg-accent rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-pulse"></div>
      <div class="absolute -bottom-40 -right-40 w-96 h-96 bg-brand rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-pulse" style="animation-delay: 2s;"></div>
      
      <div class="relative w-full max-w-md p-8 bg-surface/40 backdrop-blur-xl rounded-3xl shadow-2xl border border-white/10 mx-4">
        <.header class="text-center mb-8">
          <h1 class="font-display text-4xl font-bold text-white mb-2 bg-gradient-to-r from-brand to-accent bg-clip-text text-transparent">Create Account</h1>
          <:subtitle>
            <span class="text-gray-400">Already registered?</span>
            <.link navigate={~p"/users/log_in"} class="font-semibold text-accent hover:text-white transition-colors duration-300">
              Log in
            </.link>
          </:subtitle>
        </.header>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
          class="space-y-6"
        >
          <.error :if={@check_errors}>
            <div class="bg-danger/20 text-danger border border-danger/50 p-4 rounded-lg">
              Oops, something went wrong! Please check the errors below.
            </div>
          </.error>

          <.input field={@form[:email]} type="email" label="Email" required class="bg-surface/50 border-white/10 text-white focus:border-accent" />
          <.input field={@form[:password]} type="password" label="Password" required class="bg-surface/50 border-white/10 text-white focus:border-accent" />
          
          <.input 
            field={@form[:role]} 
            type="select" 
            label="Your Role" 
            prompt="Select your role"
            options={[
              {"Export Manager", "export_manager"},
              {"Regulatory Lead", "regulatory_lead"},
              {"CHA Agent", "cha_agent"},
              {"Supply Chain Director", "supply_chain_director"},
              {"Buyer/Importer", "buyer"}
            ]}
            required 
            class="bg-surface/50 border-white/10 text-white focus:border-accent"
          />

          <:actions>
            <.button phx-disable-with="Creating account..." class="w-full bg-gradient-to-r from-accent to-brand hover:from-brand hover:to-accent text-white font-bold py-3 rounded-lg shadow-lg transform hover:scale-[1.02] transition-all duration-300">
              Create an account
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
