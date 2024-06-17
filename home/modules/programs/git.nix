{ pkgs, ... }:

let
  git-ssh-dispatch = pkgs.writeScriptBin "git-ssh-dispatch"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail
    
      # this script roughly acts like openssh
      # at least in terms of how git uses it
    
      if [[ $1 == '-G' && $# == 2 ]]; then
          ssh $@
          exit
      fi
    
      if [[ ! $2 =~ "git-(upload|receive)-pack '(.*)'" && $# == 2 ]]; then
          echo 'unexpected form' $@ >&2
          exit 1
      fi
    
      target=$1:$match[2]
    
      case $target in
    
          (git@github.com:dkuettel/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;
    
          (git@github.com:/dkuettel/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;

          (git@github.com:iff/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;

          (git@github.com:/iff/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;
    
          (git@github.com:wereHamster/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;
    
          (git@github.com:ThingWorx/*)
              key=work
              user="Yves Ineichen yineichen@ptc.com"
              ;;

          (git@github.com:ptc-yineichen/*)
              key=work
              user="Yves Ineichen yineichen@ptc.com"
              ;;
    
          (*)
              echo 'no match for' $target >&2
              exit 1
              ;;
    
      esac
    
      if [[ -e .git && -v user ]]; then
          if ! actual="$(git config --get user.name) $(git config --get user.email)"; then
              echo 'no git user is set instead of' $user >&2
              exit 1
          fi
          if [[ $actual != $user ]]; then
              echo 'git user is' $actual 'but expected' $user >&2
              exit 1
          fi
      fi
    
      echo $target '->' $key >&2
      ssh -i ~/.ssh/$key $@
    '';
in
{
  home.packages = [
    git-ssh-dispatch
  ];

  programs.git = {
    enable = true;
    userName = "Yves Ineichen";
    signing.key = "165AEDEB";

    extraConfig = {
      core = {
        sshCommand = "git-ssh-dispatch";
        pager = "less -FRSX";
        editor = "nvim";
        # excludesfile = /home/iff/.gitignore
      };
      color = {
        ui = "true";
        diff = "auto";
      };
      rerere = {
        enabled = 1;
      };

      merge = {
        tool = "nvim";
      };
    };

    aliases = {
      b = "branch -vv";
      ba = "branch -avv";
      c = "commit";
      cm = "commit -m";
      co = "checkout";
      coo = "!git checkout $(git branch -a --format '%(refname:short)' | sed 's~origin/~~' | sort | uniq | fzf)";
      f = "fetch --all --tags --prune --force";
      m = "merge";
      p = "push";
      pu = "push -u origin HEAD";
      s = "-c advice.statusHints=false status --show-stash";

      d = "diff -C";
      ds = "diff -C --stat";
      dsp = "diff -C --stat -p";
      dw = "diff -C --color-words";

      l = "log -C --decorate";
      ls = "log -C --stat --decorate";
      lsp = "log -C --stat -p --decorate";

      lc = "log ORIG_HEAD.. --stat --no-merges";

      lg = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s'";
      lga = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --all";
      l19 = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --all -19";
      lsd = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --all --simplify-by-decoration";
      lfp = "log --graph '--pretty=tformat:%Cblue%h%Creset %Cgreen%ar%Creset %Cblue%d%Creset %s' --first-parent";

      # "show-branch -g=N" can't be aliased for N easily, so we stop here:
      sb = "show-branch --sha1-name";

      ru = "remote update";
      rbi = "rebase -i";
      rbc = "rebase --continue";
      rbim = "rebase -i main";

      ls-del = "ls-files -d";
      ls-mod = "ls-files -m";
      ls-new = "ls-files --exclude-standard -o ";
      ls-ign = "ls-files --exclude-standard -o -i";

      # whois = "!sh -c 'git log -i -1 --pretty=\"format:%an <%ae>\n\" --author=\"$1\"' -";
      # whatis = "show -s --pretty='tformat:%h (%s, %ad)' --date=short";

      edit-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; v `f`";
      add-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; git add `f`";

      # fixup
      fu = "commit --amend --reset-author -C HEAD";
      fuu = "!git add -u && git fu";
    };
  };
}
