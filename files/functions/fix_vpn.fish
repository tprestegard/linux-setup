function fix_vpn
    sudo route del -net default gw _gateway netmask 0.0.0.0 dev tun0
end
