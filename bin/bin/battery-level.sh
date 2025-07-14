#!/usr/bin/env sh

ALL_PATHS=$(bluetoothctl gatt.list-attributes | ag "Battery Level" -B2 | ag 'org/bluez' | awk '{$1=$1};1')
L_ATTRIBUTES_PATH=$(echo "$ALL_PATHS" | head -n1)
R_ATTRIBUTES_PATH=$(echo "$ALL_PATHS" | tail -n1)

L_KB_HEX=$(gdbus call --system --dest org.bluez --object-path $L_ATTRIBUTES_PATH --method org.bluez.GattCharacteristic1.ReadValue "{}" | sed -E 's/.*0x([0-9a-fA-F]+).*/\1/')
R_KB_HEX=$(gdbus call --system --dest org.bluez --object-path $R_ATTRIBUTES_PATH --method org.bluez.GattCharacteristic1.ReadValue "{}" | sed -E 's/.*0x([0-9a-fA-F]+).*/\1/')

if [[ $1 = "--ascii" ]]; then
	echo "🅻$((16#$L_KB_HEX))% 🆁$((16#$R_KB_HEX))%"
fi

if [[ $1 = "--raw" ]]; then
	echo "$((16#$L_KB_HEX)) $((16#$R_KB_HEX))"
fi

if [[ $1 = "" ]]; then
	echo "Left: $((16#$L_KB_HEX))%; Right: $((16#$R_KB_HEX))%"
fi

if [[ $1 = "-h" || $1 = "--help" ]]; then
	echo "Usage: $0 [--ascii|--raw|-h|--help]"
	echo "            Show battery as full text"
	echo "  --ascii   Show battery as icons"
	echo "  --raw     Show battery as numbers"
	echo "  -h, --help  Show this help"
fi
