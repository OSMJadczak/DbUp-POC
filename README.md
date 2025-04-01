# README #

CABS Database Related Code and operations

### What is this repository for? ###

This repository stores various elements related with CABS database including backup and maintenance tasks.
It contains an application relying on DbUp library to perform automated upgrade and downgrade of scripts.

### Target:

Automation of database scripts deployment during development of CABS.
1.Deployment of up-to-date version of application - done
2.Deployment of current scripts via Azure DevOps pipelines as an artifact - done
3.Specifying deployment groups in Azure DevOps - TODO #1
4.Pulling latest version of application and necessary scripts on target machines - TODO #2
5.Automated upgrade of database - tested on local machine, TODO #3 on target
6.Automated clean-up of scripts ran - TODO #3

### TODOs:

#1 - Specifying deployment groups in Azure DevOps
#2 - Creating Azure pipelines
#3 - testing upgrades on target machine databases (verifying for accesses etc.)
#4 - Currently clean-up is not idempotent, meaning that clean-up scripts are retained in history of scripts run. Running downgrade with the same scripts should have deleted them, but they still retain. That implies that as of now, clean-up scripts information have to be manually deleted from run history.