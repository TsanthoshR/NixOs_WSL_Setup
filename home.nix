{ config, pkgs, user, herdrPkg, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
    fzf
    jq
    lazygit
    nodejs
    wezterm
    nerd-fonts.hack
    herdrPkg
  ];

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = "bindkey '^f' autosuggest-accept";
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      ll = "ls -la";
      la = "ls -A";
      l = "ls";
      v = "nvim";
      cc = "claude --dangerously-skip-permissions";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in the repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  # Single-file symlink, not the whole directory: herdr writes runtime state
  # (session.json, herdr-*.log) into this same directory, which must never
  # end up inside a path that lives in a (public) git repo.
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr/config.toml";

  # Single-file symlink, not the whole directory: ~/.claude also holds
  # .credentials.json and conversation history, which must never end up
  # inside a path that lives in a (public) git repo.
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
