import boto3
import logging
import sys

FORMAT = '[%(levelname)-2s] %(message)s'
logging.basicConfig(format=FORMAT, level=20)
logger = logging.getLogger()

if len(sys.argv) < 2:
    logger.error('Missing argument: stop or terminate')
    sys.exit(1)
if sys.argv[1] != 'stop' or sys.argv[1] != 'terminate':
    logger.error('valid arguments: ["stop", "terminate"]')
    sys.exit(1)

#get regions
ec2_client = boto3.client('ec2')
regions = [region['RegionName'] for region in ec2_client.describe_regions()['Regions']]
    
for r in regions:
    logger.debug('Region: {}'.format(r))
    ec2 = boto3.resource('ec2', region_name=r)
    # stop instance based on existance of tag yelpCamp:true
    instances = ec2.instances.filter(Filters=[{"Name": "tag:yelpCamp", 'Values': ['true']}])
    for instance in instances:
        if sys.argv[1] == 'stop':
            logging.info('Stopping instance:  {}'.format(instance.id))
            instance.stop()
            logger.info("Stopped instance: {}".format(instance.id))
        elif sys.argv[2] == 'terminate':
            logging.info('terminating instance:  {}'.format(instance.id))
            instance.terminate()
            logger.info("Terminated instance: {}".format(instance.id))
        