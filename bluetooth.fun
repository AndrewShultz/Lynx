#!/bin/bash

GBoom()###USE###
{
    #bluez-test-audio connect 0C:A6:94:9E:74:A5
    #sdptool browse bluez_sink.0C_A6_94_9E_74_A5
    echo "connect 0C:A6:94:9E:74:A5" | bluetoothctl
    #pacmd set-default-sink bluez_sink.0C_A6_94_9E_74_A5
}

GBoom2()###USE###
{
    echo "disconnect 0C:A6:94:9E:74:A5" | bluetoothctl
    bluez-test-audio disconnect 0C:A6:94:9E:74:A5
}
