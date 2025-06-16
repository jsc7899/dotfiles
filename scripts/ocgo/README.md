# OCGO

## About

This is a program written in `golang` to make using `openconnect` with SSO logins easier.
It uses the [golang bindings](https://github.com/playwright-community/playwright-go?tab=readme-ov-file) for the browser testing framework [Playwright](https://playwright.dev/).

## Usage

You can use it standalone by running `./ocgo` in your terminal.

### reset_dns.sh

You can also chain it with the `reset_dns.sh` script to clean up your DNS after `openconnect` exits: `./ocgo || ./reset_dns.sh`

(The `||` operator means "run the next command if the previous command does not exit successfully". So if `openconnect` fails or you kill it (with <CTRL-C>), then `reset_dns.sh` will run.)

Note, `reset_dns.sh` will set the DNS server of your primary network interface to 1.1.1.1 by default, but you can also specify your
own preferred nameserver: `./reset_dns.sh 8.8.8.8`

### alias

Then you can save the entire command as an alias by adding the following to your `~/.bashrc` or `~/.zshrc`:
`alias vpn='cd path_to_ocgo && ./ocgo || ./reset_dns.sh'`
where `path_to_ocgo` is the path to the place where you downloaded `ocgo` and `reset_dns.sh`

## Operation

It works by using Playwright to automate the process of opening a browser and filling out the standard UT SSO login
form. After a successful login, Playwright is able to grab the `webvpn` cookie and pass it to `openconnect` which uses it to login to the vpn.
