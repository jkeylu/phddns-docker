TODAY_TXT="/tmp/today.txt"
USER_DATA="/tmp/oraysl.status"

if [[ ! -f "$TODAY_TXT" ]]; then
    touch "$TODAY_TXT"
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $@"
}

restart_phddns() {
    phddns restart
    sleep 2
    phddns status
}

while true
do
    if [[ `date +%e` != "$(cat "$TODAY_TXT")" ]]; then
        log "This is a new day."
        date +%e > "$TODAY_TXT"
        restart_phddns
    fi

    if ! (ps -e | grep -q 'oraynewph'); then
        log "oraynewph is not running"
        restart_phddns
    fi
    if ! (ps -e | grep -q 'oraysl'); then
        log "oraysl is not running"
        restart_phddns
    fi

    STATUS=`head -n 3 $USER_DATA  | tail -n 1 | cut -d= -f2-`
    if [[ "$STATUS" == "OFFLINE" ]]; then
        log "phddns status is offline"
        restart_phddns
    fi

    sleep 1m
done
