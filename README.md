# LiveToken-Ui

[![Build Status](https://secure.travis-ci.org/x62en/livetoken-ui.png?branch=master)](https://travis-ci.org/x62en/livetoken-ui)

Easily implement token authentication (unique and temporary code) in your meteor project.
This is the user interface package, you could also check: livetoken-base wich will give you access to standard methods in order to make your own interface.

## Registration

First register yourself on [livetoken.io](http://livetoken.io) (it's free !) and retrieve your API Key (client_id) from your administration space.

___

## Install

Install with meteor:
  ```sh
    meteor add benmz:livetoken-ui
  ```

## Configuration and usage

Configure on server side (replace the xxxxx with your client API Key):
  ```coffeescript
    if Meteor.isServer
      Meteor.startup () ->
        configLiveToken
         auth: 'EMAIL-ONLY'
         client_id: 'xxxxxxxxxxxxxxxxxxx'
  ```

Use it in your code (exemple below use):
  ```jade
    +loginLiveToken
  ```

___

## Configuration options

>There's different options available in order to configure your authentication method.
>These options must be set on server-side to Accounts.livetoken object

**auth**: Define the authentication method.
>Valid options are: EMAIL-ONLY / PHONE-ONLY / EMAIL-OR-PHONE / EMAIL-AND-PHONE

**client_id**: Define your client API key fo livetoken.io

**retry**: Define the max number of attempts your client can try token code before it gets invalidated
> default: 3

**timeout**: Define the max number of seconds before a token is invalidated
> default: 300


