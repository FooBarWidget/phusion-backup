## The commands in this file are run upon restoring to a server,
## after install-script.sh is run and after files are copied over.
## This is a normal shell script, run in bash. Please ensure that
## all commands run here are idempotent!!

# Disable all daemon tools services until explicitly enabled by administrator.
if [[ -f /usr/bin/svc ]]; then
    services=$(/bin/ls -1 /etc/service)
    if [[ ${#services[@]} > 0 ]] && ! [[ ${#services[@]} = 1 && ${servers[0]} = "" ]]; then
        svc -d /etc/service/*
    fi
fi

# Phusion stuff.
if [[ -f /etc/init.d/firewall ]]; then
    /etc/init.d/firewall
    update-rc.d firewall defaults
fi
mkdir -p /var/log/nginx
