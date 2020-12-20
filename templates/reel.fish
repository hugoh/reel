# ~/.config/fish/conf.d/reel.fish

# make the reel function available
contains $__fish_config_dir/plugins/mattmc3/reel/functions $fish_function_path
or set fish_function_path $__fish_config_dir/plugins/mattmc3/reel/functions $fish_function_path

# store your plugins in a fish_plugins list for ease, order matters
set fish_plugins \
    mattmc3/reel \
    # mattmc3/up.fish \
    # decors/fish-colored-man \
    # edc/bass \
    # fishingline/cd-ls \
    # jethrokuan/z
    # oh-my-fish/plugin-bang-bang
    # rafaelrinaldi/pure \
    laughedelic/fish_logo

# reel in (clone+load) your plugins
reel in $fish_plugins
