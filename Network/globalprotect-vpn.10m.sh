#!/usr/bin/env bash

################################################################################
# Add this to /etc/sudoers to make this plugin work
# YOUR_MAC_USER_NAME ALL=(ALL) NOPASSWD: /opt/homebrew/bin/openconnect, /bin/kill
################################################################################

# <xbar.title>globalprotect</xbar.title>
# <xbar.version>v0.1.0</xbar.version>
# <xbar.author>Roman Geraskin</xbar.author>
# <xbar.author.github>rgeraskin</xbar.author.github>
# <xbar.desc>Plugin to connect/disconnect to GlobalProtect VPN with openconnect client</xbar.desc>
# <xbar.image></xbar.image>
# <xbar.dependencies>openconnect</xbar.dependencies>

# vars
# <xbar.var>string(VAR_PORTAL=""): Portal address. Like "https://global.protect.me"</xbar.var>
# <xbar.var>string(VAR_CMD_USERNAME=""): CLI command to get username. Like "echo john.doe" for plaintext</xbar.var>
# <xbar.var>string(VAR_CMD_PASSWORD=""): CLI command to get password. Like "bw get password globalprotect" for bitwarden</xbar.var>
# <xbar.var>string(VAR_CMD__2FA_CODE=""): CLI command to get 2fa code. Like "security find-generic-password -a john -s cli/globalprotect/totp-secret -w | totp-cli instant" for MacOS keychain</xbar.var>

# constants
PIDFILE="/tmp/globalprotect.pid"
ICON_ON="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"
ICON_OFF="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"

command=$1
portal="$2"
cmd_username="$3"
cmd_password="$4"
cmd__2fa_code="$5"

function run_gp() {
    export PATH="$PATH:/opt/homebrew/bin"

    # eval commands
    username=$(eval "$cmd_username")
    password=$(eval "$cmd_password")
    _2fa_code=$(eval "$cmd__2fa_code")

    if [ -z "$portal" ] || [ -z "$username" ] || [ -z "$password" ] || [ -z "$_2fa_code" ]; then
        echo "Error: Missing credentials"
        exit 1
    fi

    (echo $password; echo $_2fa_code) | \
        sudo openconnect \
            --protocol=gp $portal \
            -u $username \
            --passwd-on-stdin \
            --non-inter \
            --pid-file=$PIDFILE \
            -q -b >/dev/null 2>&1
}

function stop_gp() {
    sudo kill $(cat $PIDFILE) >/dev/null 2>&1
}

function gp_is_running() {
    if [ -f "$PIDFILE" ]; then
        pid=$(cat $PIDFILE)

        if ps -p $pid > /dev/null; then
            return 0
        fi
    fi

    return 1
}

# xbar plugin
if [ -z "$command" ]; then
    status=$("$0" status)
    if [ "$status" == "GlobalProtect is running" ]; then
        echo "| image=$ICON_ON"
        echo ---
        echo "Stop GlobalProtect | bash=$0 param1=stop refresh=true terminal=false "
    elif [ "$status" == "GlobalProtect is not running" ]; then
        echo "| image=$ICON_OFF"
        echo ---
        echo "Start GlobalProtect | bash=$0 param1=start param2='"$VAR_PORTAL"' param3='"$VAR_CMD_USERNAME"' param4='"$VAR_CMD_PASSWORD"' param5='"$VAR_CMD__2FA_CODE"' refresh=true terminal=false"
    else
        echo "gp error"
    fi
elif [ "$command" == "start" ]; then
    if ! gp_is_running; then
        run_gp
    fi
elif [ "$command" == "stop" ]; then
    if gp_is_running; then
        stop_gp
    fi
elif [ "$command" == "status" ]; then
    if gp_is_running; then
        echo "GlobalProtect is running"
    else
        echo "GlobalProtect is not running"
    fi
fi