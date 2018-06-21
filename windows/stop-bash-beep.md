# WSL bash の beep を止める

コマンドプロンプトはbeepのサービス切るとか暴挙に出てるが、1コマンド実行するだけで良かった。
```
echo "set bell-style none" >> ~/.inputrc
```