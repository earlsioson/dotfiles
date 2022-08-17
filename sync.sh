rsync -av --delete --exclude plugin/packer_compiled.lua .config/nvim/ ~/.config/nvim/
rsync -av --delete --exclude plugged --exclude plug.vim.old .vim/ ~/.vim/
rsync -av  .vimrc ~/.vimrc
rsync -av  .tmux.conf ~/.tmux.conf
