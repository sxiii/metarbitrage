#!/bin/bash

clear

tickerswex=( ltc_btc nmc_btc nvc_btc ppc_btc dsh_btc dsh_ltc dsh_eth eth_btc eth_ltc etc_eth etc_btc bch_btc bch_ltc bch_eth bch_dsh zec_btc eos_btc eos_eth gno_eth gno_btc rep_eth rep_btc xlm_btc xmr_btc xrp_btc)
tickersyob=( ltc_btc nmc_btc nvc_btc ppc_btc dash_btc dash_ltc dash_eth eth_btc eth_ltc etc_eth etc_btc bcc_btc bcc_ltc bcc_eth bcc_dash zec_btc eos_btc eos_eth gno_eth gno_btc rep_eth rep_btc xlm_btc xmr_btc xrp_btc)
tickersexm=( LTC_BTC NMC_BTC NVC_BTC PPC_BTC DASH_BTC DASH_LTC DASH_ETH ETH_BTC ETH_ltc ETC_ETH ETC_BTC BCH_BTC BCH_LTC BCH_ETH BCH_DASH ZEC_BTC EOS_BTC EOS_ETH GNO_ETH GNO_BTC REP_ETH REP_BTC XLM_BTC XMR_BTC XRP_BTC)
tickersol=( LTC_BTC NMC_BTC NVC_BTC PPC_BTC DASH_BTC DASH_LTC DASH_ETH ETH_BTC ETH_LTC ETC_ETH ETC_BTC BCH_BTC BCH_LTC BCH_ETH BCH_DASH ZEC_BTC EOS_BTC EOS_ETH GNO_ETH GNO_BTC REP_ETH REP_BTC XLM_BTC XMR_BTC XRP_BTC)
tickerskra=( XLTCXXBT null  null    null    DASHXBT  null     null     XETHXXBT null   XETCXETH ETCXBT BCHXBT  null    null    null     XZECXXBT EOSXBT EOSETH  GNOETH  GNOXBT  XREPXETH XREPXXBT XXLMXXBT XXMRXXBT XXRPXXBT)
# "ETHXBT.d" "ICNETH" "ICNXBT" "XDGXBT"

end=$(echo ${tickerswex[@]} | wc -w)

d=$(curl -s http://cfe.cboe.com/cfe-products/xbt-cboe-bitcoin-futures | html2text | grep -A5 "Cboe XBT Bitcoin Futures Trading Data")

echo "\/------------------------------------------------------------------------------\/"
echo "|| M E T A R B I T R A G E                                    Handle with care! ||"
echo "|| This script helps you to arbitrage cryptocurrencies between exchanges.       ||"
echo "|| Please wait, scanning $end crypocurrency pairs on two exchanges.               ||"
echo "||                                        Written by Security XIII on 8.12.2017 ||"
echo "\/------------------------------------------------------------------------------\/"
echo ""
echo "$d"
echo ""

text=( "PAIR NAME" "YOBIT.NET" "Y volume" "WEX.NZ" "W volume" "EXMO.ME" "E Volume" "OpenLedger" "O Volume" "Kraken" "K Volume" "DIFF. Y/W" "DIFF. Y/E" "DIFF. W/E" "DIFF. Y/K" "DIFF. W/K" "DIFF. E/K" )
printf "%-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-30s\n" " ${text[0]}" "${text[1]}" "${text[2]}" "${text[3]}" "${text[4]}" "${text[5]}" "${text[6]}" "${text[7]}" "${text[8]}" "${text[9]}" "${text[10]}" "${text[11]}" "${text[12]}" "${text[13]}" "${text[14]}" "${text[15]}" "${text[16]}"
echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------"

for i in `seq 0 $(($end-1))`; do

	w=""; y=""; e=""; r=""; r2=""; r3=""; r4=""; r5=""; r6="";

	wfile=$(mktemp)
	curl -f -s https://wex.nz/api/3/ticker/"${tickerswex[i]}" > "${wfile}"
	w=$(cat "${wfile}" | jq '.'"${tickerswex[i]}"'.sell')
	wv=$(cat "${wfile}" | jq '.'"${tickerswex[i]}"'.vol')
	rm "${wfile}"

	yfile=$(mktemp)
	curl -f -s https://yobit.net/api/3/ticker/"${tickersyob[i]}" > "${yfile}"
	y=$(cat "${yfile}" | jq '.'"${tickersyob[i]}"'.sell')
	yv=$(cat "${yfile}" | jq '.'"${tickersyob[i]}"'.vol')
	rm "${yfile}"

	efile=$(mktemp)
	curl -f -s https://api.exmo.com/v1/ticker > "${efile}"
	e=$(cat "${efile}" | jq '.'"${tickersexm[i]}"'.sell_price' | awk -F'"' '{ print $2 }')
	ev=$(cat "${efile}" | jq '.'"${tickersexm[i]}"'.vol' | awk -F'"' '{ print $2 }')
	rm "${efile}"


	ofile=$(mktemp)
	curl -f -s https://stats.openledger.info/api/asset/pairs > "${ofile}"
	o=$(cat "${ofile}" | jq '.'"${tickersol[i]}"'.last')
	ov=$(cat "${ofile}" | jq '.'"${tickersol[i]}"'.baseVolume')
	rm "${ofile}"

	kbuf=$(printf "%s," "${tickerskra[@]}")
	khelp=${kbuf//",null"/}
    kfile=$(mktemp)
	curl -f -s https://api.kraken.com/0/public/Ticker?pair=${khelp::-1} > "${kfile}"
	k=$(cat "${kfile}" | jq '.result.'"${tickerskra[i]}"'.c[0]' | awk -F'"' '{ print $2 }')
	kv=$(cat "${kfile}" | jq '.result.'"${tickerskra[i]}"'.c[1]' | awk -F'"' '{ print $2 }')
	rm "${kfile}"


	[[ $w == null ]] && w=""; [[ $y == null ]] && y=""; [[ $e == null ]] && e=""; 
	[[ $wv == null ]] && wv=""; [[ $yv == null ]] && yv=""; [[ $ev == null ]] && ev="";
	[[ $o == null ]] && o=""; [[ $ov == null ]] && ov=""; [[ $k == null ]] && k=""; [[ $kv == null ]] && kv="";

	[[ $y =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $w =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r=$(echo "scale=8;(($y/$w)-1)*100" | bc)  # Yobit / Wex
	[[ $y =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $e =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r2=$(echo "scale=8;(($y/$e)-1)*100" | bc) # Yobit / Exmo
	[[ $w =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $e =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r3=$(echo "scale=8;(($w/$e)-1)*100" | bc) # Wex / Exmo
	[[ $y =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $k =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r4=$(echo "scale=8;(($y/$k)-1)*100" | bc) # Yobit / Kraken
	[[ $w =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $k =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r5=$(echo "scale=8;(($w/$k)-1)*100" | bc) # Wex / Kraken
	[[ $e =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && [[ $k =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] && r6=$(echo "scale=8;(($e/$k)-1)*100" | bc) # Exmo / Kraken



	

printf "%-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-20s\n" "${tickersyob[$i]}" "${y:0:10}" "${yv:0:10}" "${w:0:10}" "${wv:0:10}" "${e:0:10}" "${ev:0:10}" "${o:0:10}" "${ov:0:10}" "${k:0:10}" "${kv:0:10}" "${r:0:10}" "${r2:0:10}" "${r3:0:10}" "${r4:0:10}" "${r5:0:10}" "${r6:0:10}"

done

echo "-------------------------------------------------------------------------------------------------------------------------------------------"
