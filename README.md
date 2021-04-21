# SFDX App

This is the code base for the Direct SMS AppExchange Salesforce Labs app that I created. If you want to check this out for yourself (and I recommend you do), then do the following.

### Prerequisites

Setup Salesforce DX (link [here](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_develop.htm))

This assumes you've already setup your marketing cloud SMS API endpoint and have the Keywork, APIKey, ClientID and ClientSecret
values for that endpoint. Be sure that your endpoints work in postman before attempting this!

## Installation

Firstly, clone this repo...

```
git clone https://github.com/adamSellers/smsUtility.git
```

Install the testing and linting tools.

```
npm i
```

Then, create a fresh scratch org.

```
sfdx force:org:create -a sms -s -f config/project-scratch-def.json
```

The Marketing cloud API has been updated to a tenant specific API (this is a [good thing](https://developer.salesforce.com/docs/atlas.en-us.mc-apis.meta/mc-apis/index-api.htm)). So ensure that you update the remote site settings files at /force-app/main/default/aura/remoteSiteSettings.

For the auth API (to get your token) set the URL value to:

```
https://[YOUR-SUBDOMAIN]auth.marketingcloudapis.com
```

For the SMS API (that sends your message) set the URL value to:

```
https://[YOUR-SUBDOMAIN]rest.marketingcloudapis.com
```

Source push the world!

```
sfdx force:source:push
```

Open the scratch

```
sfdx force:org:open
```

## Description of Files and Directories

Repo contains:

- Lightning Web Component Bundle - directSMS
- Example of the Aura component - SMSGun component
- MessageGunController.cls, apex class for said component
- Test class (eww) for said controller
- Remote site settings for Marketing Cloud API
- Static resource (Marketing Cloud logo) for component file.

## TODO

- Add Jest tests for LWC
- Move the remote site settings into settings or custom metadata etc.

## Issues

oh so many that I don't even know about yet... log em if you find em :)

Happy hacking!
