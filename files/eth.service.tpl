[Unit]
Description=ethminer
After=network.target

[Service]
Type=simple
ExecStart=/tmp/ethminer -G -F http://eth-us.dwarfpool.com:80/${wallet_address}
Restart=always
RemainAfterExit=false
StartLimitIntervalSec=5
RestartSec=3

StandardOutput=journal

[Install]
WantedBy=multi-user.target