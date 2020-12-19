# http://github.com/mattmc3/reel
# Copyright mattmc3, 2020-2021
# MIT license, https://opensource.org/licenses/MIT

set -g reel_version 0.1.0
set -q reel_plugins_path; or set -g reel_plugins_path $HOME/.config/fish/plugins
set -q reel_git_default_domain; or set -g reel_git_default_domain "github.com"

function __reel_usage
    set -l b (set_color --bold)
    set -l n (set_color normal)

    echo "reel - manage your fish plugins"
    echo ""
    echo "Comands:"
    echo "$b ls$n                 List installed plugins"
    echo "$b in$n <plugins...>    Initialize plugins, cloning from git if necessary"
    echo "$b rm$n <plugins...>    Remove an existing plugin"
    echo "$b up$n <plugins...>    Update the specified plugins"
    echo "$b up$n                 Update all plugins"
    echo "$b source$n <paths...>  Source a plugin from a directory"
    echo "$b clone$n <plugin>     git clone the specified plugin"
    echo ""
    echo "Options:"
    echo "       -v or --version  Print version"
    echo "       -h or --help     Print this help message"
end

function __reel_ls
    for p in $reel_plugins_path/*/*
        string replace -a "$reel_plugins_path/" "" $p
    end
end

function __reel_up -a plugin
    if not test -d "$reel_plugins_path/$plugin"
        echo "plugin not found: $plugin" >&2 && return 1
    end
    echo "updating plugin $plugin..."
    command git -C "$reel_plugins_path/$plugin" pull --recurse-submodules origin
end

function __reel_parse_giturl
    # try to parse a git URL
    set -l parsed (string match -r '^((?:https?|git|ssh):\/\/)(.+)\/([^\/]+)\/([^\/]+?)(?:.git)?$' $argv)
    or set -l parsed (string match -r '^(git@)(.+):([^\/]+)\/([^\/]+?)(?:.git)?$' $argv)
    or set -l parsed (string match -r '^([^\/]+)\/([^\/]+)$' $argv)

    if test (count $parsed) -eq 3
        set parsed "https://$reel_git_default_domain/$parsed[2]/$parsed[3]" "https://" "$reel_git_default_domain" $parsed[2..-1]
    else if test (count $parsed) -ne 5
        echo "unable to parse git URL: $argv" >&2 && return 1
    end

    # return the parsed URL as url, protocol, domain, user, and repo
    for item in $parsed
        echo $item
    end
end

function __reel_clone -a plugin
    set -l urlparts (__reel_parse_giturl $plugin)
    if test $status -ne 0
        echo "invalid plugin: $plugin" >&2 && return 1
    end
    set -l plugindir "$reel_plugins_path/$urlparts[4]/$urlparts[5]"
    if test -d $plugindir
        echo "plugin already exists" >&2 && return 1
    end
    echo "cloning repo $plugin..."
    command git clone --recursive --depth 1 $urlparts[1] $plugindir
end

function __reel_source -a plugin_dir
    if not test -d "$plugin_dir"
        echo "plugin not found: $plugin_dir" >&2 && return 1
    end
    if test -d "$plugin_dir/completions"; and not contains "$plugin_dir/completions" $fish_complete_path
        set fish_complete_path "$plugin_dir/completions" $fish_complete_path
    end
    if test -d "$plugin_dir/functions"; and not contains "$plugin_dir/functions" $fish_function_path
        set fish_function_path "$plugin_dir/functions" $fish_function_path
    end
    for f in "$plugin_dir/conf.d"/*
        source "$f"
    end
end

function __reel_in -a plugin
    if not test -d "$reel_plugins_path/$plugin"
        __reel_clone "$plugin"
    end
    __reel_source "$reel_plugins_path/$plugin"
end

function __reel_rm
    if test (count $argv) -eq 0
        echo "plugin argument expected" >&2 && return 1
    end
    set plugin_path "$reel_plugins_path/$argv"
    if not test -d "$plugin_path"
        echo "plugin not found: $argv" >&2 && return 1
    else if not __reel_can_rm "$plugin_path"
        echo "plugin path not removable: $argv" >&2 && return 1
    else
        echo "removing $plugin_path..."
        command rm -rf "$plugin_path"
    end
end

function __reel_can_rm
    # do a small set of checks to make sure someone isn't being evil with
    # relative paths or accidentally gets burnt by a typo
    set -l abs_pluginsdir (realpath "$reel_plugins_path")
    set -l abs_pluginpath (realpath "$argv")

    set -l path (realpath "$argv")
    if not string match -q -- "$abs_pluginsdir/*/*" "$abs_pluginpath"
        return 1
    else if not test -d "$abs_pluginpath/.git"
        return 1
    end
end

function reel -a cmd --description 'Manage your fish plugins'
    set argv $argv[2..-1]
    switch "$cmd"
        case -v --version
            echo "reel, version $reel_version"
        case "" -h --help
            __reel_usage
        case ls list
            __reel_ls
        case up update
            test (count $argv) -gt 0; or set argv (__reel_ls)
            for p in $argv
                __reel_up $p
            end
        case in init initialize install clone source rm remove
            if test (count $argv) -eq 0
                echo "expecting a plugin parameter" >&2 && return 1
            end
            contains $cmd install init initialize; and set cmd in
            contains $cmd remove; and set cmd rm
            for p in $argv
                __reel_$cmd $p
            end
        case \*
            echo "reel: Unknown flag or command: \"$cmd\" (see `reel -h`)" >&2 && return 1
    end
end
