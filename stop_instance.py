import boto3
import logging
import sys
import argparse

FORMAT = '[%(levelname)-2s] %(message)s'
logging.basicConfig(format=FORMAT, level=20)
logger = logging.getLogger()

# build parser and parse arguments
parser = argparse.ArgumentParser(description='command line tool to stop or terminate ec2 instance running previous app version')

parser.add_argument('action', choices=['stop', 'terminate'], help='stop or terminate ec2 instance')
parser.add_argument('--version', '-v', action='version', version='%(prog)s 1.0')
parser.add_argument('--debug', action='store_true')

args = parser.parse_args()

#get regions
ec2_client = boto3.client('ec2')
regions = [region['RegionName'] for region in ec2_client.describe_regions()['Regions']]
    
for r in regions:
    logger.debug('Region: {}'.format(r))
    ec2 = boto3.resource('ec2', region_name=r)
    # stop instance based on existance of tag yelpCamp:true
    instances = ec2.instances.filter(Filters=[{"Name": "tag:yelpCamp", 'Values': ['true']}])
    for instance in instances:
        if args.action == 'stop':
            logging.info('Stopping instance:  {}'.format(instance.id))
            instance.stop()
            logger.info("Stopped instance: {}".format(instance.id))
        elif args.action == 'terminate':
            logging.info('terminating instance:  {}'.format(instance.id))
            instance.terminate()
            logger.info("Terminated instance: {}".format(instance.id))
        