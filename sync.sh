rsync -av --delete ~/.config/nvim/ .config/nvim/
rsync -av --delete --exclude plugged --exclude plug.vim.old ~/.vim/ .vim/
rsync -av  --delete ~/.vimrc .vimrc
rsync -av  --delete ~/.tmux.conf .tmux.conf
