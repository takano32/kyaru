# 1. PowerShellを管理者として起動
# 2. Set-ExecutionPolicy Bypass で実行ポリシーを変更
# 3. ./setup-windows.ps1 で実行する
Set-ExecutionPolicy Bypass
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
cinst ruby
cinst msys2
refreshenv
ridk install 1 2 3
gem install bundler
bundle install