defmodule RoutiqWeb.UserLoginLive do
  use RoutiqWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-surface relative overflow-hidden">
      <!-- Background decoration -->
      <div class="absolute -top-40 -right-40 w-96 h-96 bg-brand rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-pulse"></div>
      <div class="absolute -bottom-40 -left-40 w-96 h-96 bg-accent rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-pulse" style="animation-delay: 2s;"></div>
      
      <div class="relative w-full max-w-md p-8 bg-surface/40 backdrop-blur-xl rounded-3xl shadow-2xl border border-white/10 mx-4">
        <.header class="text-center mb-8">
          <h1 class="font-display text-4xl font-bold text-white mb-2 bg-gradient-to-r from-accent to-brand bg-clip-text text-transparent">Welcome back</h1>
          <:subtitle>
            <span class="text-gray-400">Don't have an account?</span>
            <.link navigate={~p"/users/register"} class="font-semibold text-accent hover:text-white transition-colors duration-300">
              Sign up
            </.link>
          </:subtitle>
        </.header>

        <.simple_form
          for={@form}
          id="login_form"
          action={~p"/users/log_in"}
          phx-update="ignore"
          class="space-y-6"
        >
          <.input field={@form[:email]} type="email" label="Email" required class="bg-surface/50 border-white/10 text-white focus:border-accent" />
          <.input field={@form[:password]} type="password" label="Password" required class="bg-surface/50 border-white/10 text-white focus:border-accent" />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" class="text-accent" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-accent hover:text-white transition-colors">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Signing in..." class="w-full bg-gradient-to-r from-brand to-accent hover:from-accent hover:to-brand text-white font-bold py-3 rounded-lg shadow-lg transform hover:scale-[1.02] transition-all duration-300">
              Sign in <span aria-hidden="true" class="ml-2">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
