import os
import sys
import logging

def set_up_logger():
    # set logger
    FORMAT = '[%(levelname)-2s] %(message)s'
    logging.basicConfig(format=FORMAT, level=10)
    logger = logging.getLogger()
    return logger
logger = set_up_logger()

script_dir = os.getcwd()
hosts_path = os.path.join(script_dir, sys.argv[1])
logger.info('Path to host file: {}'.format(hosts_path))

new_line = '{}'.format(os.environ.get('YELPCAMP_HOST'))
logger.info(new_line)

with open(hosts_path, 'r') as f:
    lines = [line for line in f]

lines[-1] = new_line

os.remove(hosts_path)
logger.info('host file removed')
with open(hosts_path, 'w') as f:
        for line in lines:
            f.write(line)
if os.path.exists(hosts_path):
    logger.info('hosts file created')





        