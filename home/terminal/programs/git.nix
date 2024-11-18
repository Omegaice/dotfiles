{
  lib,
  pkgs,
  ...
}: let
  worktree-clone = pkgs.writeShellApplication {
    name = "worktree-clone";
    runtimeInputs = [pkgs.git];
    text = ''
      url=$1
      basename=''${url##*/}
      name=''${2:-''${basename%.*}}

      mkdir "$name"
      cd "$name"

      # Moves all the administrative git files (a.k.a $GIT_DIR) under .bare directory.
      git clone --bare "$url" .bare
      echo "gitdir: ./.bare" > .git

      # Explicitly sets the remote origin fetch so we can fetch remote branches
      git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

      # Gets all branches from origin
      git fetch origin

      # Create a main branch folder if one doesn't exist
      main_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
      if [[ -n "$main_branch" && ! -d "$main_branch" ]]; then
          git worktree add "$main_branch"
      fi
    '';
  };
in {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      difftastic = {
        enable = true;
        background = "dark";
      };

      userName = "Omegaice";
      userEmail = "950526+Omegaice@users.noreply.github.com";

      aliases = {
        clone-worktree = "!bash ${lib.getExe worktree-clone}";
      };

      extraConfig = {
        branch.sort = "-committerdate";
        core = {
          fileMode = false;
          longpaths = true;
          untrackedcache = true;
        };
        diff = {
          algorithm = "histogram";
          submodule = "log";
        };
        fetch = {
          prune = true;
          pruneTags = true;
        };
        init.defaultBranch = "master";
        log = {
          abbrevCommit = true;
          date = "iso";
        };
        merge.conflictStyle = "zdiff3";
        push = {
          autoSetupRemote = true;
          followtags = true;
        };
        rebase = {
          autosquash = true;
          updateRefs = true;
        };
        safe.directory = [
          "*"
        ];
        status.submoduleSummary = true;
      };
    };

    gh = {
      enable = true;
      extensions = [pkgs.gh-actions-cache];
    };

    git-cliff = {
      # Generate changelog file from git commits
      enable = true;
    };
  };
}
