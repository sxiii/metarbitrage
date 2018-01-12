#!/bin/bash

clear

tickerswex=( btc_usd btc_eur btc_rur ltc_btc ltc_usd ltc_eur ltc_rur nmc_btc nmc_usd nvc_btc nvc_usd usd_rur eur_rur ppc_btc ppc_usd dsh_btc dsh_rur dsh_usd dsh_eth eth_btc eth_usd eth_eur eth_rur bch_usd bch_btc bch_rur bch_eth zec_btc zec_usd )
tickersyob=( btc_usd btc_eur btc_rur ltc_btc ltc_usd ltc_eur ltc_rur nmc_btc nmc_usd nvc_btc nvc_usd usd_rur eur_rur ppc_btc ppc_usd dash_btc dash_rur dash_usd dash_eth eth_btc eth_usd eth_eur eth_rur bcc_usd bcc_btc bcc_rur bcc_eth zec_btc zec_usd )
tickersexm=( BTC_USD BTC_EUR BTC_RUB LTC_BTC LTC_USD LTC_EUR LTC_RUB NMC_BTC NMC_USD NVC_BTC NVC_USD USD_RUB EUR_RUB PPC_BTC PPC_USD DASH_BTS DASH_RUB DASH_USD DASH_ETH ETH_BTC ETH_USD ETH_EUR ETH_RUB BCH_USD BCH_BTC BCH_RUB BCH_ETH ZEC_BTC ZEC_USD )

end=$(echo ${tickerswex[@]} | wc -w)

echo "\/------------------------------------------------------------------------------\/"
echo "|| M E T A R B I T R A G E                                    Handle with care! ||"
echo "|| This script helps you to arbitrage cryptocurrencies between exchanges.       ||"
echo "|| Please wait, scanning $end crypocurrency pairs on two exchanges.               ||"
echo "||                                        Written by Security XIII on 8.12.2017 ||"
echo "\/------------------------------------------------------------------------------\/"
echo ""
text=( "PAIR NAME" "YOBIT.NET" "Y vol" "WEX.NZ" "W vol" "EXMO.ME" "E Vol" "DIFF. Y/W" "DIFF. Y/E" "DIFF. W/E" )
printf "%-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-30s\n" " ${text[0]}" "${text[1]}" "${text[2]}" "${text[3]}" "${text[4]}" "${text[5]}" "${text[6]}" "${text[7]}" "${text[8]}" "${text[9]}"
echo "-------------------------------------------------------------------------------------------------------------------------------"

for i in `seq 0 $(($end-1))`; do

	w=""; y=""; e=""; r=""; r2=""; r3="";

	curl -f -s https://wex.nz/api/3/ticker/"${tickerswex[i]}" > wfile
	w=$(cat wfile | jq '.'"${tickerswex[i]}"'.sell')
	wv=$(cat wfile | jq '.'"${tickerswex[i]}"'.vol')
	rm wfile

	curl -f -s https://yobit.net/api/3/ticker/"${tickersyob[i]}" > yfile
	y=$(cat yfile | jq '.'"${tickersyob[i]}"'.sell')
	yv=$(cat yfile | jq '.'"${tickersyob[i]}"'.vol')
	rm yfile

	curl -f -s https://api.exmo.com/v1/ticker > efile
	e=$(cat efile | jq '.'"${tickersexm[i]}"'.sell_price' | awk -F'"' '{ print $2 }')
	ev=$(cat efile | jq '.'"${tickersexm[i]}"'.vol' | awk -F'"' '{ print $2 }')
	rm efile

	[[ $w == null ]] && w=""; [[ $y == null ]] && y=""; [[ $e == null ]] && e=""; 
	[[ $wv == null ]] && wv=""; [[ $yv == null ]] && yv=""; [[ $ev == null ]] && ev="";
 
	[[ $w =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $y =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r=$(echo "scale=8;(($y/$w)-1)*100" | bc)
	[[ $y =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $e =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r2=$(echo "scale=8;(($y/$e)-1)*100" | bc)
	[[ $e =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $w =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r3=$(echo "scale=8;(($w/$e)-1)*100" | bc)


	printf "%-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-20s\n" "${tickersyob[$i]}" "${y:0:10}" "${yv:0:10}" "${w:0:10}" "${wv:0:10}" "${e:0:10}" "${ev:0:10}" "${r:0:10}" "${r2:0:10}" "${r3:0:10}"

done

echo "-------------------------------------------------------------------------------------------------------------------------------"
#sleep 60
