# midrib

## Getting started

Prereqs

* Install ruby (you prob want to use rvm)

* Install gems: `gem install bundler` and `gem install rails`

* Install yarn

```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
```

Run the server

```
git clone git@github.com:stephengrice/midrib
bundle install
rails s
```
