# reel

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)

<img align="right"
     width="250"
     alt="reel"
     src="https://raw.githubusercontent.com/mattmc3/reel/resources/img/pexels-brent-keane-1687242.jpg">

> The simple, elegant, clutter-free fish plugin manager that shows you maybe don't even really need one

## Installation

TLDR; Just grab Reel with a simple git command and copy a file to your fish config.

```shell
git clone --depth 1 https://github.com/mattmc3/reel $__fish_config_dir/plugins/mattmc3/reel
cp $__fish_config_dir/plugins/mattmc3/reel/templates/reel.fish $__fish_config_dir/conf.d
```

## Introduction

Other plugin managers do too much magic, require extra variables or configuration files, and can clutter up your personal fish config.

Reel doesn't do any of that.
It doesn't need to.
It offers a much simpler way to think about managing your fish shell plugins.
The power of Reel is that it's a plugin manager that shows you don't really even need a plugin manager.
Let me show you what I mean.

The way Reel works is that it stores any plugins you clone from git in the `~/.config/fish/plugins` folder.
It then uses fish's built-in `$fish_function_path` and `$fish_complete_path` to tell fish where to find the plugin's key files.
This short snippet from Reel is the entirety of what you'd need to load your own plugins without using a "plugin manager".

```fish
function load_plugin -a plugin
    if test -d "$plugin/completions"; and not contains "$plugin/completions" $fish_complete_path
        set fish_complete_path "$plugin/completions" $fish_complete_path
    end
    if test -d "$plugin/functions"; and not contains "$plugin/functions" $fish_function_path
        set fish_function_path "$plugin/functions" $fish_function_path
    end
    for f in "$plugin/conf.d"/*.fish
        builtin source "$f"
    end
end
```

With this tiny snippet of code and a basic knowledge of git commands, you don't even really need Reel or any plugin manager.
Imagine that.
A tool so confident in itself that is shows you that you don't even need it.
But, Reel puts some extra goodies on top of this simple concept, so if you want those goodies then Reel right for you.

## Goodies

List your plugins:

```fish
reel ls
```

Initialize a plugin. Initializing means that the plugin will `git clone` if it's not found before trying to load it:

```fish
reel in mattmc3/reel
```

Load a plugin without trying to clone it first.

```fish
reel load my/plugin
```

Load a plugin from some location on your computer.
Loaded plugins don't have to come from git repos.

```fish
reel load ~/.config/fish/my_fancy_plugin
```

Update all your plugins:

```fish
reel up
```

Update a specific plugin:

```fish
reel up mattmc3/reel
```

Remove a plugin:

```fish
reel rm jorgebucaran/fisher
```

Clone a plugin without loading it. github.com is the assumed home of the plugin:

```fish
reel clone laughedelic/fish_logo
```

Clone a plugin from someplace other than github.com:

```fish
reel clone git@gitlab.com:my/fish_plugin.git
reel clone https://bitbucket.org/myother/fish_plugin.git
```

## Customization

Don't care for github.com and want reel to favor using bitbucket.org as the default git domain? Set the `$reel_git_default_domain` variable at the top of your `~/.config/fish/conf.d/reel.fish` file.

```fish
set -gx reel_git_default_domain "bitbucket.org"
```
