#!/bin/bash
# Example: ./ssh.sh 192.168.1.0 root

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <network_prefix> <username>"
  exit 1
fi

NETWORK=$1
USER=$2

BASE=$(echo $NETWORK | awk -F'.' '{print $1"."$2"."$3}')

echo "Scanning for SSH on $BASE.1 to $BASE.254 ..."

# Loop through possible host addresses in the /24
for i in {1..254}; do
    IP="$BASE.$i"
    echo "Trying $IP..."
    # Attempt an SSH connection with a 5-second timeout, using batch mode so no prompts appear
    ssh -o BatchMode=yes -o ConnectTimeout=5 -i /path/to/your/sshkey $USER@$IP 'echo "Connected to $(hostname)"' 2>/dev/null && \
      echo "-> Successful connection at $IP" &
done

wait
echo "Scanning complete."
