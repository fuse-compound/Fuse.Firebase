# Fuse.Firebase
[![license](https://img.shields.io/github/license/cbaggers/Fuse.Firebase.svg?maxAge=2592000)](https://github.com/cbaggers/Fuse.Firebase/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/cbaggers/Fuse.Firebase.svg?branch=master)](https://travis-ci.org/cbaggers/Fuse.Firebase)

This project's goal to make Firebase bindings for Fuse. Currently we have:

- Authentication using Email, Google & Facebook providers
- Basic Ad & Analytics support
- Realtime database
- Simple storage

All are welcome to come hacking on this so we can flesh this out to cover the full gammut of features provided by Firebase! Whether it's as small as a typo fix or as large and a entire feature, please feel free to fork and summit pull requests.

## Requirements

- Fuse version >= 0.25: This is needed as a bunch of changes shipped in that version to make this all possible including appcompat7 Activity as super class for the app's activity
- Firebase account
- [Cocoapods](https://cocoapods.org/) (if working on OSX) It should be enough just to run `sudo gem install cocoapods`

If you are using Facebook for authentication you will also need a Facebook developer account.

## Docs

See [here for our documentation](docs/index.md)
