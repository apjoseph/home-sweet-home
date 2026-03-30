# Agent Instructions for Nix Devshells

This project uses **Nix** for dependency management. To ensure you have access
to the correct tools and versions, please follow these guidelines at the start
of every session:

1. **Environment Check:** Before running build commands, linters, or language
   servers, verify you are running within the project's development shell
   environment.
   * If you encounter "command not found" errors for standard tools (like
      `cargo`, `go`, `npm`, `nil`, `nixfmt`), it is likely because the devshell
      is not active in your current process.

2. **Execution Strategy:**
   * **Preferred:** If `direnv` is active (indicated by `.envrc`), the
      environment should be loaded. Verify with `which <tool>`.
   * **Fallback:** If a tool is missing, execute it inside the Nix shell
      explicitly using:

        ```bash
        nix develop --command <command> <args>
        ```

   **Example:* `nix develop --command cargo build`

3. **Nix Formatting:**
   * This project uses `nix fmt` (which usually maps to `alejandra` or
      `nixpkgs-fmt`). Always prefer `nix fmt` over calling formatters directly.

4. **Flakes:**
   * This project is a Flake (`flake.nix` exists). Ensure you use
      flake-compatible commands (e.g., `nix build`, `nix develop`).

By following these steps, you will avoid "tool not found" loops and ensure
reproducible behavior.
