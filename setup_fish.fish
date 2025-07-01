#!/usr/bin/env fish

# Fish Shell Migration Setup Script
# Run this script to set up your Fish shell configuration

echo "Setting up Fish shell configuration..."

# Create Fish config directory if it doesn't exist
set config_dir ~/.config/fish
if not test -d $config_dir
    mkdir -p $config_dir
    echo "Created Fish config directory: $config_dir"
end

# Create functions directory
set functions_dir $config_dir/functions
if not test -d $functions_dir
    mkdir -p $functions_dir
    echo "Created functions directory: $functions_dir"
end

# Copy main config file
if test -f config.fish
    cp config.fish $config_dir/config.fish
    echo "Copied main config to $config_dir/config.fish"
end

# Copy function files
for func_file in functions/*.fish
    if test -f $func_file
        cp $func_file $functions_dir/
        echo "Copied $func_file to $functions_dir/"
    end
end

echo ""
echo "Fish shell setup complete!"
echo ""
echo "Next steps:"
echo "1. Install Fish shell: brew install fish"
echo "2. Install Fisher (plugin manager): curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
echo "3. Install useful plugins:"
echo "   - fisher install PatrickF1/fzf.fish  # FZF integration"
echo "   - fisher install jethrokuan/z        # Directory jumping"
echo "   - fisher install jorgebucaran/nvm.fish  # Node version manager"
echo "4. Set Fish as default shell: chsh -s /opt/homebrew/bin/fish"
echo "5. Restart your terminal"
echo ""
echo "Your Zsh aliases and functions have been converted to Fish equivalents."