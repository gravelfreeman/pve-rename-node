#!/bin/bash
change_hostname() {
    local original_hostname=$(hostname)
    read -p "Enter new hostname: " new_hostname

    mkdir -p /tmp/qemu
    cp /etc/pve/nodes/$original_hostname/qemu-server/* /tmp/qemu/

    hostnamectl set-hostname "$new_hostname"

    sed -i "s/$original_hostname/$new_hostname/g" /etc/hosts

    # Restart Proxmox services
    services=("pveproxy.service" "pvebanner.service" "pve-cluster.service" "pvestatd.service" "pvedaemon.service")

    for service in "${services[@]}"
    do
        systemctl restart "$service"
    done

    rm -rf "/etc/pve/nodes/$original_hostname"
    cp /tmp/qemu/* /etc/pve/nodes/$new_hostname/qemu-server/
}
change_hostname
