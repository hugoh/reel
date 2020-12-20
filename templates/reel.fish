# ~/.config/fish/conf.d/reel.fish

# make the reel function available
contains ~/.config/fish/plugins/mattmc3/reel/functions $fish_function_path
or set fish_function_path ~/.config/fish/plugins/mattmc3/reel/functions $fish_function_path

# store your plugins in a fish_plugins variable for ease
set fish_plugins \
    "mattmc3/reel" \
    # "decors/fish-colored-man" \
    # "edc/bass" \
    # "fishingline/cd-ls" \
    # jethrokuan/z
    # "fishingline/up" \
    "laughedelic/fish_logo"

# reel in (clone+load) your plugins
reel in $fish_plugins
