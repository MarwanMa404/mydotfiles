#!/bin/bash

# Show the main menu with tabs for WiFi, Bluetooth, and Services
main_menu() {
    options="WiFi\nBluetooth\nServices\nExit"
    choice=$(echo -e "$options" | rofi -dmenu -p "Control Center")
    
    case "$choice" in
        "WiFi") wifi_menu ;;
        "Bluetooth") bluetooth_menu ;;
        "Services") services_menu ;;
        "Exit") exit 0 ;;
    esac
}

# WiFi Menu
wifi_menu() {
    networks=$(nmcli -t -f SSID,SECURITY dev wifi list | awk -F: '!seen[$1]++ {print $1}')
    
    if [[ -z "$networks" ]]; then
        echo "No networks found" | rofi -dmenu -p "WiFi"
        main_menu
        return
    fi

    chosen_network=$(echo -e "$networks" | rofi -dmenu -p "Select WiFi")

    if [[ -n "$chosen_network" ]]; then
        password=$(rofi -dmenu -password -p "Enter password for $chosen_network")
        nmcli dev wifi connect "$chosen_network" password "$password"
    fi

    main_menu
}

# Bluetooth Menu
bluetooth_menu() {
    devices=$(bluetoothctl devices | awk '{print $2, $3, $4, $5, $6}')
    
    if [[ -z "$devices" ]]; then
        echo "No Bluetooth devices found" | rofi -dmenu -p "Bluetooth"
        main_menu
        return
    fi

    chosen_device=$(echo -e "$devices" | rofi -dmenu -p "Select Bluetooth Device" | awk '{print $1}')

    if [[ -n "$chosen_device" ]]; then
        bluetoothctl connect "$chosen_device"
    fi

    main_menu
}

# Services Menu
services_menu() {
    services=$(systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}')
    
    if [[ -z "$services" ]]; then
        echo "No active services found" | rofi -dmenu -p "Services"
        main_menu
        return
    fi

    chosen_service=$(echo -e "$services" | rofi -dmenu -p "Manage Service")

    if [[ -n "$chosen_service" ]]; then
        action=$(echo -e "Restart\nStop" | rofi -dmenu -p "Action for $chosen_service")
        
        case "$action" in
            "Restart") sudo systemctl restart "$chosen_service" ;;
            "Stop") sudo systemctl stop "$chosen_service" ;;
        esac
    fi

    main_menu
}

# Start the main menu
main_menu

