# vagrant-hub

## Description
This is a Vagrant/Puppet configuration for the automated provisioning and
setup of a Debian 8 virtual machine hosting the 
[HUBzero example CMS](https://github.com/hubzero/hubzero-cms).

## Usage
Clone the repo, cd into the project directory, run `vagrant up`. The host 
machine's port 8080 is forwarded to the website, so visit 
[https://localhost:8080/](https://localhost:8080/) in your browser.

The default administrator account is user `admin` with password `password!`.

## Vagrant Tips
...
## PhpStorm Tips
...

## Supported Systems
This workflow has only been tested on Debian 8, but will likely work on most Linux distribution.

Using this workflow on Windows may pose additional concerns, specifically due to some 
unavoidable differences in the filesystem.

## Future Improvements
* Flexible modules that can be used with other site specifications
* Separate dev and production environment configurations
* Addition of hubzero_mailhog module
* Parameterization of more options such as PHP version selection
* Addition of hubzero_wrapper module, which wraps all main modules together
for simpler site configuration
