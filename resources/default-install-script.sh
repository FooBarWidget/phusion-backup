## The commands in this file are run upon restoring to a server.
## This is a normal shell script, run in bash. Please ensure that
## all commands run here are idempotent!!
##
## == DebConf questions
## 
## This default script makes sure that debconf questions are only
## asked when "cold restoring", i.e. this is the first time restoring
## to the server. Such questions are postponed until the end of this
## script so that you can answer everything at once without delaying
## the install.

# Standard, essential tools
apt-get update
apt-get -y upgrade
apt-get install -y \
    bash-completion screen iotop wget telnet gdebi-core \
    rsync rdiff-backup \
    ntp acl

# Non-essential but useful tools
apt-get install -y daemontools daemontools-run
# Security
apt-get install -y fail2ban
# Compiler toolchain
apt-get install -y build-essential gdb zlib1g-dev libcurl4-openssl-dev \
    libssl-dev libxml2-dev libxslt1-dev
# Monitoring tools
apt-get install -y smartmontools sysstat
# Utilities
apt-get install -y pv git-core

# SQL databases
if true; then
    # MySQL
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server libmysqlclient-dev
    package_name=$(dpkg-query -p mysql-server | grep Depends | grep -oEi 'mysql-server-[0-9a-z\.]+')
    run_at_end dpkg-reconfigure $package_name
    
    # SQLite3
    apt-get install -y sqlite3 libsqlite3-dev
fi

# Email support
if true; then
    # Exim
    DEBIAN_FRONTEND=noninteractive apt-get install -y exim4
    run_at_end dpkg-reconfigure -p medium exim4-config
    
    # Postfix
    # DEBIAN_FRONTEND=noninteractive apt-get install -y postfix
    # run_at_end dpkg-reconfigure -p medium postfix
fi

# Ruby Enterprise Edition
if true; then
    # basename=ruby-enterprise_1.8.7-2011.03_i386_ubuntu10.04.deb
    # basename=ruby-enterprise_1.8.7-2011.03_amd64_ubuntu10.04.deb
    # basename=ruby-enterprise_1.8.7-2011.03_amd64_debian5.0.deb
    basename=ruby-enterprise_1.8.7-2011.03_amd64_debian6.0.deb
    if [[ ! -f /usr/local/bin/ruby ]]; then
        rm -f $basename
        wget http://rubyenterpriseedition.googlecode.com/files/$basename
        gdebi -n $basename
        rm -f $basename
        
        # gem install --no-rdoc --no-ri nokogiri
        # gem install --no-rdoc --no-ri rails --version 2.3.11
        # gem install --no-rdoc --no-ri rails
    fi
fi

# Install users
if true; then
    # Specify list of usernames here, separated by space.
    # Each user will be created with a random password.
    # It's up to you to change the passwords later.
    # USERNAMES="john jane"
    USERNAMES=""
    
    for user in $USERNAMES; do
        if ! grep -q "^$user:" /etc/passwd; then
            password=$(tr -dc A-Za-z0-9 < /dev/urandom | (head -c $1 > /dev/null 2>&1 || head -c 15))
            adduser $user < /dev/null
            echo
            echo "$user:$password" | chpasswd
        fi
    done
fi

# Configure time zone
run_at_end dpkg-reconfigure tzdata
