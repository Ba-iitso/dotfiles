function fish_prompt -d "Write out the prompt"
    set -l last_status $status
    # Prompt status only if it's not 0
    set -l stat
    if test $last_status -ne 0
        set stat (set_color $fish_color_error)"[$last_status]"(set_color normal)
    end
    set -l nix_shell_info (
        if test -n "$IN_NIX_SHELL"
            echo -n "<nix-shell> "
        end
    )
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s%s%s@%s%s%s %s%s%s%s> ' (set_color $fish_color_user) $USER (set_color $fish_color_normal) (set_color $fish_color_host) \
        $hostname $nix_shell_info (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) $stat
end
