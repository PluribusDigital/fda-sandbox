#! /bin/bash
set -e

BUILD_TAG=$1
ENV_NAME=$2
APP_NAME=$ENV_NAME

DOCKERRUN_FILE=Dockerrun.aws.json

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

cd deploy/beanstalk
# variable substitutions
sed -e "s/<TAG>/eval/" \
    -e "s/<POSTGRES_USER>/$POSTGRES_USER/" \
    -e "s/<OPENFDA_POSTGRES_VERSION>/$OPENFDA_POSTGRES_VERSION/" \
    -e "s/<POSTGRES_PASSWORD>/$POSTGRES_PASSWORD/" \
    -e "s/<OPENFDA_API_KEY>/$OPENFDA_API_KEY/" \
    -e "s/<NEW_RELIC_KEY>/$NEW_RELIC_KEY/" \
    < $DOCKERRUN_FILE.template > $DOCKERRUN_FILE

# elastic beanstalk requires application source to be zipped
zip -r $DOCKERRUN_FILE.zip $DOCKERRUN_FILE .ebextensions

aws s3 cp $DOCKERRUN_FILE.zip s3://$EB_BUCKET/$DOCKERRUN_FILE.zip
aws elasticbeanstalk create-application-version --application-name $APP_NAME \
  --version-label $BUILD_TAG --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE.zip \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name $ENV_NAME \
    --version-label $BUILD_TAG --region us-east-1
	
cd ../..
