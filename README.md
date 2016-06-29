# Monitoring clients for Palveluväylä
This repository contains clients which can be used to check the status of the the services in Palveluväylä. 

## Requirements

For monitoring client:

* Perl 5 (tested with perl v5.10.1 and v5.16.3)
* LWP::UserAgent
* HTTP::Request::Common
* XML::Parser::Lite::Tree
* Scalar::Util::Numeric
* MIME::Lite
* Config::Simple

```sh
# On Ubuntu, can be installed as follows
sudo apt-get install liblwp-mediatypes-perl liblwp-protocol-https-perl libxml-parser-lite-tree-perl libscalar-util-numeric-perl libmime-lite-perl libconfig-simple-perl
```

For report tool:

* Perl 5 (tested with perl v5.10.1)
* GD::Graph::bars
* GD::Graph::Data
* MIME::Lite
* Config::Simple

```sh
# On Ubuntu, can be installed as follows
sudo apt-get install libgd-graph-perl libmime-lite-perl libconfig-simple-perl
```



## Configuration
Prior to use, configure the XML in helloXML.pl and randomXML.pl. Also, configure monitor.ini. The configuration file monitor.ini is divided to three parts. Section [email] contains email settings for alert messages. Section [monitor] contains following settings:
* lock_file, the full path to a lock file, which is generated in case any of the calls failes. This file controls emails that are sent by the system and removing it must be handled separately, for example hourly by Cron.
* results_dir, where the result files (csv) should be generated
* target_host, the FQDN of the host that is polled
* here, usually the directory where the scripts reside
* timeout, for client versions where watchdog is used, time (integer) in seconds. For example, if the script is run once per minute, the timeout should be less than that unless wanted otherwise (you can run the script in parallel, of course, but the files could be opened by other process)

To use the reporting tool, configure report.ini
* the email section contains configurations for sending emails
* the main section contains the results_dir, which is the directory where the monitoring client generates results and graph_dir, where the reporting client will generate graphs

The [SSL] section is to set certificate and key files.
 
## simple_monitor.pl

The script simple_monitor.pl is the simplest version of clients. It does not offer watchdog but will have the alert message features. Simply configure the aforementioned files and run with ./simple_monitor.pl.
Generates a lock file (with default name alert.lock) to prevent re-sending of mail. Remove the lock file (in a cron script or something) if you want this to function again!

## report.pl

This script will function with the monitoring client and will send graphs of the previous day's results by email. Run the script with ./report.pl. Make sure you have an SMTP server configured.

# About these scripts

These scripts were originally made with limited time, so they are far from perfect. 

## Some features (& room for improvements)
* Scripts aren't very robust and the user should know what he or she is doing
* This script (monitor) won't check network connectivity or similar issues - your monitoring system should do it. It is run by cron periodically and is allowed to crash.
* The monitoring script may be accompanied by a watchdog process to limit its running time (not included here). The requests could be run in parallel to give both of them (hello and random) decent running time. But this would require extra work with file handles.
* The reporting script is naive in result generation, so a crashed monitoring script may lead to odd results, as it may have crashed before writing newline. This could be avoided with a little bit of improving the script.
