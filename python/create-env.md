# pythonの環境構築

最小構成の Ubuntu14 に python を導入するのが結構手こずることがわかったので覚書。

```bash
# 必要なライブラリが決まっている
# ちなみにこれは 3.6 でうまくいった。 3.7 ではうまく行かなかった。謎
# refs: https://github.com/pyenv/pyenv/wiki/common-build-problems
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev

# pyenv のインストール
git clone git://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# 環境変数を設定する
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile

# install python
pyenv install 3.6.6
pyenv global 3.6.6

# もともと aws-sam-cli が入れたかった
pip install aws-sam-cli
```