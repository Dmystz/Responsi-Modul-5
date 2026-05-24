## ============================================================
## Constraints - Nexys A7 100T
## Mealy FSM Traffic Light
## ============================================================

## Clock 100 MHz
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ============================================================
## Push Buttons
## ============================================================

## M17 - W input (toggle: tekan = w jadi 1, tekan lagi = w jadi 0)
set_property PACKAGE_PIN M17 [get_ports btn_w]
set_property IOSTANDARD LVCMOS33 [get_ports btn_w]

## N17 - Reset (tekan = kembali ke state Red)
set_property PACKAGE_PIN N17 [get_ports btn_reset]
set_property IOSTANDARD LVCMOS33 [get_ports btn_reset]

## ============================================================
## LEDs Output Lampu
## ============================================================

## H17 - LED Merah (Zr)
set_property PACKAGE_PIN H17 [get_ports led_red]
set_property IOSTANDARD LVCMOS33 [get_ports led_red]

## K15 - LED Kuning (Zy)
set_property PACKAGE_PIN K15 [get_ports led_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports led_yellow]

## J13 - LED Hijau (Zg)
set_property PACKAGE_PIN J13 [get_ports led_green]
set_property IOSTANDARD LVCMOS33 [get_ports led_green]

## ============================================================
## Seven Segment Display
## seg[7..0] = CA CB CC CD CE CF CG DP
## ============================================================

set_property PACKAGE_PIN T10 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]

set_property PACKAGE_PIN R10 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN K16 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

set_property PACKAGE_PIN K13 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

set_property PACKAGE_PIN P15 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

set_property PACKAGE_PIN T11 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

set_property PACKAGE_PIN L18 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

set_property PACKAGE_PIN H15 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

## Anode (an) aktif LOW
set_property PACKAGE_PIN J17 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]

set_property PACKAGE_PIN J18 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

set_property PACKAGE_PIN T9  [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN J14 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN P14 [get_ports {an[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]

set_property PACKAGE_PIN T14 [get_ports {an[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]

set_property PACKAGE_PIN K2  [get_ports {an[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]

set_property PACKAGE_PIN U13 [get_ports {an[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]
