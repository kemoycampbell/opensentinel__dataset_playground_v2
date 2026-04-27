For each model that we are testing:
 -  Run the terraform to init and create the bucket
 -  run the open sentinel system
 -  Try these manual actions 1 at a time to see if the system detects and create PR for them:
    - Enable buccket versioning
    - Change default encryption to use bucket key