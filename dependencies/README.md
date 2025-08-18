Dependencies for the build environment for various package managers.  Used in
`.github/workflows/`.

== apt_packages.txt 패키지 설치
sudo apt-get update && sudo apt-get install -y $(tr '\n' ' ' < apt_packages.txt) 

== gem install mathematical 설치시 문제 발생시, 처리방안
git clone https://github.com/gjtorikian/mathematical.git
git submodule update --init

script/bootstrap
bundle exec rake compile

* gem 만들기와 설치하기
gem build [your_gem_name].gemspec
==> [your_gem_name]-[version].gem : 설치 가능한 패키지가 생성됨
gem install [your_gem_name]-[version].gem
(ex) gem install ./mathematical-1.6.20.gem

== npm 이용하여, 의존성 패키지 설치
sudo apt update
sudo apt install nodejs npm
sudo npm install -g bytefield-svg@1.8.0
sudo npm install -g wavedrom-cli@2.6.8