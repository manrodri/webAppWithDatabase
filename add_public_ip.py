import os
import sys
import logging
import re


def set_up_logger():
    # set logger
    FORMAT = '[%(levelname)-2s] %(message)s'
    logging.basicConfig(format=FORMAT, level=10)
    logger = logging.getLogger()
    return logger
logger = set_up_logger()

script_dir = os.getcwd()
hosts_path = os.path.join(script_dir, sys.argv[2])
logger.info('Path to host file: {}'.format(hosts_path))

public_ip = ''
with open(sys.argv[1], 'r') as f:
    for line in f:
        if re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", line):
            public_ip = line.strip()
        else:
            logger.error('No public_ip found in "/jenkins_tmp/ip.txt"')
            sys.exit(5)
        logger.info(public_ip)

with open(hosts_path, 'r') as f:
    lines = [line for line in f]

p = re.compile(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
lines[-1] = p.sub(public_ip, lines[-1])

os.remove(hosts_path)
logger.info('host file removed')
with open(hosts_path, 'w') as f:
        for line in lines:
            f.write(line)
if os.path.exists(hosts_path):
    logger.info('hosts file created')




        