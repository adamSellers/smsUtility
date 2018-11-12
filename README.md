# SFDX  App
[![Build Status](https://travis-ci.org/adamSellers/smsUtility.svg?branch=master)](https://travis-ci.org/adamSellers/smsUtility)

This is the code base for the Direct SMS AppExchange Salesforce Labs app that I created. If you want to check this out for yourself (and I recommend you do), then do the following. 

### Prerequisites

Setup Salesforce DX (link [here](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_develop.htm))


## Installation
Firstly, clone this repo...
````
git clone https://github.com/adamSellers/smsUtility.git
````
Then, create a fresh scratch org.
````
sfdx force:org:create -a sms -s -f config/project-scratch-def.json
````
Source push the world!
````
sfdx force:source:push
````
enjoy the goodness..
````
sfdx force:org:open
````

## Description of Files and Directories
Repo contains: 

- SMS Component file (SMSGun.cmp), style, design, controller and helper files
- MessageGunController.cls, apex class for said component
- Test class (eww) for said controller
- Remote site settings for Marketing Cloud API
- Static resource (Marketing Cloud logo) for component file.
- Flexipages for the org default setups for both the case and contact object
    
## Issues
oh so many that I don't even know about yet... however, one issue that YOU will have..

1. SMSGun.css file references my namespace, you'll want to change this bit 'background-image: url(/resource/sms_direct__mclogo) !important;' to not reference my namespace (the sms_direct bit). 

Happy hacking!

