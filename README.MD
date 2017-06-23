# Installation

#### 1. Copy your composer auth file to the `env/.composer/` dir
   * `mkdir -p env/conf/composer/ && cp ~/.composer/auth.json env/conf/composer/auth.json`

#### 2. Run docker's containers
   * `docker-compose up`

#### 3. Mount source code directory to your host machine
   * `cd env && make mount ; cd -`

#### 4. Unmount source code directory to your host machine
   * `cd env && make unmount ; cd -`

#### 6. Add virtual hosts to your hosts file
`0.0.0.0	magento1.local	php55.magento1.local	php56.magento1.local	php70.magento1.local	php71.magento1.local`

`0.0.0.0	magento2.local	php55.magento2.local	php56.magento2.local	php70.magento2.local	php71.magento2.local`

`0.0.0.0	xhgui.local`

# Available tools

### tideways + xhgui for profiling PHP code
To enable profiler you have to trigger `php-profiler.sh 1` inside the php container(php56, php70).

For disabling profiler, please trigger `php-profiler.sh 0` inside the php container(php56, php70).

For accessing xhgui, don't forget to add the following line to your hosts file:

`0.0.0.0	xhgui.local`

After this you can see all the profiles by the [link](http://xhgui.local/).

### Xdebug

##### Pre-requirements
xDebug configuration is using remote host ip = 10.254.254.254.

if you are using Mac OSX you have to create ip 10.254.254.254 as an alias on your loopback device 127.0.0.1
by using next command:
```
sudo curl -o /Library/LaunchDaemons/osx.docker.loopback.plist \
https://raw.githubusercontent.com/tshabatyn/supportDevbox/master/env/php/osx.docker.loopback.plist \
&& sudo launchctl load /Library/LaunchDaemons/osx.docker.loopback.plist
```
More details you can find here: https://gist.github.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93

Also you can create loop back alias by using next command: `sudo ifconfig lo0 alias 10.254.254.254 netmask 255.255.255.0` 

By defaults deebugger disabled.
For enabling debbugger, please, execute the following command inside the php container(php56, php70).

```bash
# enable debugger
php-debugger.sh 1

# disable debugger
php-debugger.sh 0

# the following command will also disable the debugger
php-debugger.sh
```

### FAQ

#### How to increase docker container's storage size?

You can find my foundings by the [link](https://gist.github.com/tshabatyn/8fda3b236b92dc38fb1191eaaf9f8930).
