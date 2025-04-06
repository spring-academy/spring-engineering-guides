# Educates Cluster Configuration and Change Log

## Overview

While the README [Workshop environment configuration section](#workshop_environment_configuration)
covers highlights of configurating the *development* environment,
this documentation will provide more details covering the educates clusters
supporting any/all environments that are configured to deploy workshops sourced
from this repository configuration.

The [Changelog](#changelog) will cover only platform changes to the associated educates clusters
that are not covered under the the relevant environment
[config](https://github.com/spring-academy/spring-engineering-guides/tree/main/config)
directories in this repo.

## Current environments

### Development

The *Development Environment* is used as a persistent near-realtime general purpose review environment
for workshops in this repo.

Contact @robertmcnees for access credentials

- URL: https://spring-engineering-dev-ui.acad-spr-eng1.labs.spring-staging.academy
- [workshop environment config location](https://github.com/spring-academy/spring-engineering-guides/tree/main/config/dev/workshops.yaml)
- cluster id: `acad-spr-eng1`
- educates version: `2.6.16`
- cloud provider: AWS EKS
- number nodes: 3 node
- node instance type: `m6i.2xlarge`

### Demo

The *Demo Environment* is currently used as a near-realtime review environment for optimized
demos for workshops in this repo.

Contact @robertmcnees for access credentials

- URL: https://spring-engineering-demos-ui.acad-spr-eng2.labs.spring-staging.academy
- [workshop environment config location](https://github.com/spring-academy/spring-engineering-guides/tree/main/config/demos/workshops.yaml)
- cluster id: `acad-spr-eng2`
- educates version: `2.6.16`
- cloud provider: AWS EKS
- number nodes: 3 node
- node instance type: `c6i.4xlarge`

## Changelog

TBD for upcoming changes