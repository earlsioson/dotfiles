rsync -av --delete --exclude plugin/packer_compiled.lua ~/.config/nvim/ .config/nvim/
rsync -av --delete --exclude plugged --exclude plug.vim.old ~/.vim/ .vim/
rsync -av --delete ~/.config/kitty/ .config/kitty/
rsync -av  --delete ~/.vimrc .vimrc
rsync -av  --delete ~/.tmux.conf .tmux.conf
