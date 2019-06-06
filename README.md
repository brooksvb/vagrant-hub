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

## Development with vagrant-hub
The HUBzero CMS is located in `/var/www/dev` inside the virtual machine. Currently, the
most promising method to developing and testing CMS changes seems to be configuring an
rsync-type deployment method with your PHP IDE. eg. Get a local copy of CMS, change files, 
deploy files to VM, check website in browser. If your IDE supports automatically pushing
newly changed files to deployment, you may wish to configure this as well.

### xdebug
In order to use xdebug you will need a local copy of the CMS and an IDE configured to accept
xdebug connections on port 9000 (default xdebug port). You also need a browser plugin to send 
the cookie that triggers the debugger, like 
[Xdebug helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc).

When your IDE receives a connection, it may ask you to map the remote PHP files to their location
on your local machine, and then you should be good to go.

### MailHog
MailHog is installed on the machine for mail debugging, but has not been thoroughly tested yet.

## Vagrant Tips
`vagrant up` - Creates a machine if nonexistent, otherwise turns existing machine on

`vagrant reload` - Turn off and on machine

`vagrant reload --provision` - Turn off and on machine, and run the provisioners (puppet, shell
scripts)

`vagrant destroy` - Delete virtual machine

`vagrant status` - Self explanatory

`vagrant ssh` - Self explanatory

When you configure certain local services or programs to connect to the machine, you may do so
through SSH. The best way to configure this is to configure the SSH connection to use a private
key pair, then select the `private_key` that appears in `./.vagrant/machines/***/private_key`.
You will use `vagrant` as the user.

For connecting to the development database, I've found that the easiest way is to connect through
an SSH tunnel using the above method. Forwarding the database port and connecting via said port
has given me inexplicable trouble in the past.

## PhpStorm Tips
...

## Supported Systems
This workflow has only been tested on Debian 8, but will likely work on most Linux distributions.

Using this workflow on Windows may pose additional concerns, specifically due to some 
unavoidable differences in the filesystem.

## Future Improvements
* Flexible modules that can be used with other site specifications
* Separate dev and production environment configurations
* Addition of hubzero_mailhog module
* Parameterization of more options such as PHP version selection
* Addition of hubzero_wrapper module, which wraps all main modules together
for simpler site configuration in one module
