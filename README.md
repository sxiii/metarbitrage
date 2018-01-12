# Metarbitrage
Cryptocurrency Arbitrage Script Sources

## The Task
This scripts aims at several cryptocurrency exchanges, looking for their cryptocurrency and crypto-fiat rate differences. It shows you different fiat and crypto-fiat pairs and aims to help in cryptocurrency arbitrage.

By using arbitrage, you can use rate differences ("spread") as a profit generating mechanism, e.g. you can earn some money.

## Notice
Arbitrage can't be always perfect. Please check that both exchanges have working wallets in both ways: for deposit and for withdrawal, too. Often arbitrage rates higher than 20-30% are related to wallet being frozen on exchange. Also, note, that the "volume" column is VERY important - it can take forever to trade currency with low volume! Triple-check and note that you can loose some of your money in case of manual mistakes.

## Language
The script is written in bash. Works in Linux (Ubuntu, Arch?) also tested on Mac.

## Requirements
* curl - for interacting with exchange APIs
* bc - for some mathematical operations
* html2text - to parse HTML, needed only to load BTC futures from CBOE, if you don't like them you can comment out (add # to the beginning of the line) the row that starts with: `d=$(curl -s http://cfe.cboe.com/cfe-products/xbt-cboe-bitcoin-futures...`
* jq - to parse JSON

You can install all of the requirements in ubuntu like this: `sudo apt install curl bc html2text jq` - it should take just few megabytes or less.

For archlinux or arch-based distros like Manjaro, try: `pacman -S curl bc html2text jq`

## Usage
0. Install git if you don't already ( ubuntu - `sudo apt install git` )
1. Clone this repo: `git clone https://github.com/sxiii/metarbitrage`
2. Enter the downloaded folder: `cd metarbitrage`
3. Run the specified script: `./crypto.sh` or `./crypto-fiat.sh`
4. Wait for script to finish work. If it's not working, check the requirements. If it's still not working, please add github issue to this repo with error details, thanks!

## The future
I'm planning to develop this script to become a sort of arbitrage bot. We will have a look if some developers would like to join me.

## Crypto
This script is for cryptocurrency <-> cryptocurrency arbitrage only. One-way.
![Crypto](https://imgur.com/sXvmJjP.png)

## Cryptofiat
This script is for crypto <-> crypto and crypto <-> fiat arbitrage.
![CryptoFiat](https://imgur.com/pi84xzs.png)

## Supported exchanges
* cryptofiat.sh: YoBit.net, Wex.nz, Exmo.me
* crypto.sh: YoBit.net, Wex.nz, Exmo.me, Openledger (Bitshares, Rudex), Kraken

Note: WIP (work-in-progress) some of exchanges might be broken. Please make a pull request if you feel you fixed or added some exchange. Thanks!

## HELP! - this is WIP (Work In Progress)
Please join me with development if you like this arbitrage script. Thanks.
