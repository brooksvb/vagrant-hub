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

## Supported Systems
This workflow has only been tested on Ubuntu, but will likely work on any Linux distribution.

Using this workflow on Windows may pose additional concerns, specifically due to some 
unavoidable differences in the filesystem.

## TODO List
* Add alias for running puppet in VM
* Add metadata to hubzero modules for dependencies and descriptions
* Add dependencies within each module so as to not rely on outside dependency definitions
    * Not sure what the best practice is to architect this in puppet
* Restructure environments into production and dev, with modules outside
* Add hubzero_mailhog module
* Add a simple bash prompt module (clear indication of being inside VM, add colors for clarity)
* Add support for selecting PHP version
* Add support for specifying desired default passwords and accounts
* Use official hubzero-cms database schema and seed instead of the one of unknown source