#!/bin/bash

# Color definitions
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

# Clear screen and show header
clear
echo -e "${BOLD}${CYAN}=============================="
echo -e "   QUINTON'S PORT BOUNCER v1     "
echo -e "==============================${RESET}"
echo ""

# Display options
echo -e "${YELLOW}Select a vHost switchport to bounce:${RESET}"
echo -e "------------------------------------"
echo -e "${GREEN}  1)${RESET} vHost01 (port 17)"
echo -e "${GREEN}  2)${RESET} vHost02 (port 18)"
echo -e "${GREEN}  3)${RESET} vHost03 (port 19)"
echo -e "${GREEN}  4)${RESET} vHost04 (port 20)"
echo -e "${GREEN}  a)${RESET} All vHosts (ports 17-20)"
echo ""

# Read user input
read -p "$(echo -e "${BOLD}Enter choice [1-4 or a]: ${RESET}")" choice

# Handle input
case "$choice" in
    1) target_ports="0/17" ;;
    2) target_ports="0/18" ;;
    3) target_ports="0/19" ;;
    4) target_ports="0/20" ;;
    a|A) target_ports="0/17-20" ;;
    *)
        echo -e "${RED}❌ Invalid choice. Exiting.${RESET}"
        exit 1
        ;;
esac

echo ""
echo -e "${CYAN}▶ Selected port(s): ${BOLD}${target_ports}${RESET}"


# Export the value so expect can read it
export TARGET_PORTS=$target_ports

# Run the expect script
expect ./nv_portbouncer.sh
