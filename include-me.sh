REPO_FOLDER=$HOME/Documenti/proj/mix/repos

# install packages if not already installed to check if already installed
install_pkg_if_not_installed ()
{
  name=$1
  dpkg -s $name &> /dev/null  

  if [ $? -ne 0 ]
  then
    echo "$name: not installed"
    echo "sudo apt-get update"
    echo "sudo apt-get install $name"
    echo "install_pkgs_if_not_installed $name"
  else
    echo "$name: installed"
  fi
}

install_pkgs_if_not_installed ()
{
  for pkg in "$@"
  do
    install_pkg_if_not_installed $pkg
  done
}
