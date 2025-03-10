new_client_dns () {
    echo "Select a DNS server for the client:"
    echo "   1) Current system resolvers"
    echo "   2) Google"
    echo "   3) 1.1.1.1"
    echo "   4) OpenDNS"
    echo "   5) Quad9"
    echo "   6) AdGuard"
    read -p "DNS server [1]: " dns
    until [[ -z "$dns" || "$dns" =~ ^[1-6]$ ]]; do
        echo "$dns: invalid selection."
        read -p "DNS server [1]: " dns
    done
        # DNS
    case "$dns" in
        1|"")
            # Locate the proper resolv.conf
            # Needed for systems running systemd-resolved
            if grep '^nameserver' "/etc/resolv.conf" | grep -qv '127.0.0.53' ; then
                resolv_conf="/etc/resolv.conf"
            else
                resolv_conf="/run/systemd/resolve/resolv.conf"
            fi
            # Extract nameservers and provide them in the required format
            dns=$(grep -v '^#|^;' "$resolv_conf" | grep '^nameserver' | grep -v '127.0.0.53' | grep -oE '[0-9]{1,3}(.[0-9]{1,3}){3}' | xargs | sed -e 's/ /, /g')
        ;;
        2)
            dns="8.8.8.8, 8.8.4.4"
        ;;
        3)
            dns="1.1.1.1, 1.0.0.1"
        ;;
        4)
            dns="208.67.222.222, 208.67.220.220"
        ;;
        5)
            dns="9.9.9.9, 149.112.112.112"
        ;;
        6)
            dns="94.140.14.14, 94.140.15.15"
        ;;
    esac
}
