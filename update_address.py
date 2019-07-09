import sys
import argparse

# build parser and parse arguments
parser = argparse.ArgumentParser(description='command line tool to substitute IP ADDRESS IN HOST FILE')

parser.add_argument('hosts_file')
parser.add_argument('ipAddress_file')

parser.add_argument('--version', '-v', action='version', version='%(prog)s 1.0')

args = parser.parse_args()

hosts_file = args.hosts_file
ip_address_file = args.ipAddress_file

def main():
    # get address
    with open(ip_address_file, 'r') as f:
        ip_address = f.read().strip()

    # update address in host file
    with open(hosts_file, 'rw') as f:
        for line in f:
            if 'ansible_user=jenkins' in line:
                words = line.split()
                words[0] = ip_address
                " ".join(words)

if __name__ == '__main__':
    main()