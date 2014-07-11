#nessus

## Overview

The nessus module installs, configures, and manages the nessus vulnerability scanner software.#nessus

## Setup

`include ::nessus` is sufficient to get nessus installed and running with default settings.  If you wish to activate an update feed, then you can specify an activation_code like this:

```puppet
class { '::nessus':
  activation_code => 'XXXX-XXXX-XXXX-XXXX'
}
```

##Usage

All interaction with the nessus module can be done through the main nessus class.


##Limitations

This module has some tests in place, but not many yet.  Additionally, it is not possible to completely test the activation portion of nessus, since each activation is unique, and you would need a new activation code from nessus every time you try to activate.

##ToDo

More test code is needed.

###Contributors

Many thanks to PuppetLabs and their ntp module for the template to work off of.  Individual contributors can be found at: [https://github.com/adamcrews/puppet-nessus/graphs/contributors](https://github.com/adamcrews/puppet-nessus/graphs/contributors)
