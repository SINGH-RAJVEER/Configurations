{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      format = ''
        [╭─](bold green)$directory$git_branch$git_status
        [╰─](bold green)$character'';
      directory = {
        style = "bold blue";
        truncation_length = 5;
        truncate_to_repo = false;
      };
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      git_status = {
        style = "bold red";
        conflicted = "Conflicted ";
        ahead = "Ahead ";
        behind = "Behind ";
        diverged = "Diverged ";
        untracked = "? ";
        stashed = "stashed ";
        modified = "Modified ";
        staged = "+ ";
        renamed = "Renamed ";
        deleted = "Deleted ";
        format = "[$all_status]($style)";
      };
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[V](bold green)";
      };
    };
  };
}
