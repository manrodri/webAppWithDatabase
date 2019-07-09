import sys
import argparse
import string
import shutil
import os

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
        print(ip_address)
  
    with open(hosts_file,"r+") as s:
        for line in s.readlines():
            if 'ansible_user=jenkins' in line:
                to_replace = line.split()[0]
                new_line = line.replace(to_replace, ip_address)
                print('NEW LINE IS: {}'.format(new_line))
    with open(hosts_file, 'r') as r:
        with open('tmp_file', 'w') as w:
            for line in r:
                if 'ansible_user=jenkins' in line:
                    print('writing: {}'.format(new_line))
                    w.write(new_line)
                else:
                    print('writing: {}'.format(new_line))
                    w.write(line)
    shutil.copyfile('tmp_file', hosts_file)
    os.remove('tmp_file')

if __name__ == '__main__':
    main() 