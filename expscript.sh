#!/usr/bin/expect

set timeout 10
set prompt "#"
set hostlist [open ./hosts r]
set hosts [read -nonewline $hostlist]

close $hostlist

stty echo
send_user "\nUser for SSH connection: "
expect_user -re "(.*)\n" {set sshuser $expect_out(1,string)}
send_user "\nPassword for SSH user: "
stty -echo
expect_user -re "(.*)\n" {set sshpass $expect_out(1,string)}
stty echo

foreach host [split $hosts "\n"] {
log_file -noappend ./logs/$host.log
spawn ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $sshuser@$host
expect {
  "assword:" { send -- "$sshpass\r"
  }
}
# commands to execute
# cisco seems to eat our first command, so we send some random text first
send -- "bogus text\r"
expect -re "$prompt"
send -- "sh ver\r"
exp_send "terminal length 0\n"
expect -re "$prompt"
send -- "exit\r"
}
