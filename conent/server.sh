#!/usr/bin/env bash

set -e
exec 2>&1

generate_config() {
  cat > /tmp/config.json << EOF
{
  "log": {
    "level": 1,
    "format": {
      "without_time": false
    }
  },
  "runtime": {
    "mode": "multi_thread",
    "worker_count": 10
  },
  "servers": [
    {
      "server": "0.0.0.0",
      "server_port": 8388,
      "method": "chacha20-ietf-poly1305",
      "password": "Y02ds+Tb6hzEtQsrmNKzKg=="
    }
  ],

  "manager_address": "127.0.0.1",
  "manager_port": 61000,

  "dns": "google",
  "dns_cache_size": 1,
  "mode": "tcp_and_udp",

  "no_delay": false,
  "keep_alive": 15,
  "ipv6_first": true,
  "ipv6_only": false
}
EOF
}

generate_pm2_file() {
  cat > /tmp/ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: "web",
      script: "/usr/src/app/ssmanager -c /tmp/config.json"
    }
  ]
}
EOF
}


generate_config
generate_pm2_file

[ -e /tmp/ecosystem.config.js ] && pm2 start /tmp/ecosystem.config.js