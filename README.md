#nessus

[![Build Status](https://travis-ci.org/adamcrews/puppet-nessus.svg)](https://travis-ci.org/adamcrews/puppet-nessus)
[![Puppet Forge](http://img.shields.io/puppetforge/v/adamcrews/nessus.svg)](https://forge.puppetlabs.com/adamcrews/nessus)

####Table of Contents

1. [Overview](#overview)
2. [Setup - The basics](#setup)
3. [Usage - Configuration options and examples](#usage)
4. [Reference - Class, parameter, and fact documentation](#reference)
5. [Limitations](#limitations)
6. [ToDo](#todo)
7. [Contributors](#contributors)

##Overview

The nessus module installs, configures, and manages the nessus vulnerability scanner software.

##Setup

`include ::nessus` is sufficient to get nessus installed and running with default settings.  If you wish to activate an update feed, then you can specify an activation_code like this:

```puppet
class { '::nessus':
  activation_code => 'XXXX-XXXX-XXXX-XXXX'
}
```

##Usage

All interaction with the nessus module can be done through the main nessus class.
You can simply toggle the optios in `::nessus` to have complete functionality.

###Bare minimum setup

```puppet
include '::nessus'
```

###Install the professional feed

```puppet
class { '::nessus':
  activation_code => 'XXXX-XXXX-XXXX-XXXX'
}
```

###Create a user
```puppet
nessus::user { 'admin':
  password  => '1adam12_1adam12',
  admin     => true,
}
```

##Reference

###Classes

####Public Classes

* nessus: Main class, includes all other classes.

####Private Classes

* nessus::install: Handles installing the package.  It must be available in wherever your system pulls packages from.
* nessus::config: Activate and configure nessus.
* nessus::service: Handles the service.

###Parameters

The following parameters are available in the nessus module:

####`activation_code`

The code used to download nessus plugin updates.

####`package_name`

The name of the nessus package being installed, defaults to 'Nessus'.

####`package_ensure`

Determines what to do with the package, valid options are present/installed, latest, or absent.

####`security_center`

Configure nessus to be connected to Security Center.

####`service_name`

The service name for nessusd.

####`service_ensure`

Determines the state of the service, valid options are running or stopped.

####`service_manage`

Selects wether puppet should manage the service.

##Facts

* `nessus_activation_code` is set to the code that is active on the node, or undefined if no code is active.

##Limitations

This module has some tests in place, but not many yet.  Additionally, it is not possible to completely test the activation portion of nessus, since each activation is unique, and you would need a new activation code from nessus every time you try to activate.

##ToDo

* Manage nessus config items.
* More spec tests are needed.
* Expand supported platforms.  So far only Nessus 5.2.7 and Nessus 6 on CentOS6 has been tested.

###Contributors

Many thanks to PuppetLabs and their ntp module for the template to work off of.  Individual contributors can be found at: [https://github.com/adamcrews/puppet-nessus/graphs/contributors](https://github.com/adamcrews/puppet-nessus/graphs/contributors)
