{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # History configuration
    history = {
      size = 10000000;
      save = 10000000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    shellAliases = {
      # NixOS management (most frequently used)
      build = "sudo nixos-rebuild switch --flake ~/.config/nixos#nixos";
      
      # Shell management
      reload = "source ~/.zshrc";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # System info shortcuts
      ass = "asusctl";
      sup = "supergfxctl";
      
      # Safety aliases
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
    };

    # Additional shell configuration
    initExtra = ''
      # Set default editor
      export EDITOR="nvim"
      export VISUAL="nvim"
      
      # Enable vi mode if desired (comment out if you prefer emacs mode)
      bindkey -v
      
      # Improved directory navigation
      setopt AUTO_CD              # Change directory without cd
      setopt AUTO_PUSHD           # Make cd push old directory onto stack
      setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
      setopt PUSHD_MINUS          # Swap +/- directions for pushd
      
      # History settings
      setopt HIST_VERIFY          # Show command with history expansion before running
      setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
      
      # Completion enhancements
      setopt COMPLETE_IN_WORD     # Complete from both ends of word
      setopt ALWAYS_TO_END        # Move cursor to end after completion
      setopt AUTO_MENU            # Show menu on tab press
      
      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      
      # Better completion menu
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      
      # Custom functions based on your patterns
      
      # Simplified commit function
      commit() {
        if [ -z "$*" ]; then
          echo "Usage: commit <message>"
          return 1
        fi
        git commit -m "$*"
      }
      
      # Quick update shortcut
      update() {
        sudo nixos-rebuild switch --flake ~/.config/nixos#nixos
      }
      
      # Add your custom command functions here
      # (These appear to be custom scripts/aliases in your system)
      # gemini() { ... }
      # ass() { ... }
      # ff() { ... }
      # int() { ... }
      # hyb() { ... }
      # dgpu() { ... }
      
      # If you have zoxide installed
      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh)"
      fi
    '';
  };
}

