#!/usr/bin/expect -f

log_user 1

# ---- Configurable variables ----
set hostname "NV1535P"
set password "password"
set timeout 10

set port_range $env(TARGET_PORTS)
set config_prompt "(config-giga-swx $port_range)#"

# ---- Start SSH session ----
spawn ssh $hostname

expect {
    "yes/no" { send "yes\r"; exp_continue }
    "assword:" { send "$password\r" }
}

# ---- Enter enable mode ----
expect "*>"
send "enable\r"
expect "assword:"
send "$password\r"

# ---- Enter config terminal and run commands ----

expect "#"
send "config t\r"

expect "(config)#"
send "interface range gigabit-switchport $port_range\r"
expect "$config_prompt"

sleep 0.125
send "shutdown\r"
sleep 2
expect "$config_prompt"

send "no shutdown\r"
expect "$config_prompt"

# ---- Manual intervention option ----
puts "\n🕒 Waiting $timeout seconds before exiting session..."
flush stdout

for {set i 0} {$i < $timeout} {incr i} {
    set wait_timeout 1
    expect -timeout $wait_timeout {
        -re "(.*)\n" {
            puts $expect_out(1,string)
            exp_continue
        }
        timeout {
            # Just wait 1 second, then continue
        }
    }
}

puts "\n✅ Timeout reached. Exiting session."
send "exit\r"
expect "(config)#"
send "exit\r"
expect "#"
send "exit\r"
expect eof
