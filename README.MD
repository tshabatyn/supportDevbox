# Installation

#### 1. Copy your composer auth file to the `env/.composer/` dir
   * `mkdir -p env/conf/composer/ && cp ~/.composer/auth.json env/conf/composer/auth.json`

#### 2. Add IP alias, on your host machine, for enable Xdebug
   * `sudo ifconfig lo0 alias 10.254.254.254 netmask 255.255.255.0`

#### 3. Run docker's containers
   * `docker-compose up`

#### 4. Mount source code directory to your host machine
   * `cd env && make mount ; cd -`

#### 5. Unmount source code directory to your host machine
   * `cd env && make unmount ; cd -`

#### 6. Add virtual hosts to your hosts file
`0.0.0.0	magento1.local	php55.magento1.local	php56.magento1.local	php70.magento1.local	php71.magento1.local`

`0.0.0.0	magento2.local	php55.magento2.local	php56.magento2.local	php70.magento2.local	php71.magento2.local`

`0.0.0.0	xhgui.local`

# Available tools

### xhprof + xhgui for profiling PHP code
To enable profiler you have to add GET parameter `profile=1`. You have to do it once.
After first request it will create cookie, all the further requests will be profiled.

For accessing xhgui add the following line to your hosts:

`127.0.0.1 xhgui.local`

After this you can see all the profiles by the [link](http://xhgui.local/).

To disable profiler you have to add GET parameter `profile=0`. It will unset cookie.
After this profiler will be disabled, for all the further requests.

### Xdebug

Please make sure that you didn't miss second step from Installation. Also, there is an issue, you should enable debugger
 only after containers will up.

```bash
# enable debugger
xdebug-php.sh 1

# disable debugger
xdebug-php.sh 0

# shows php version info, with information about Xdebug if it is enabled
xdebug-php.sh
```

### FAQ

#### How to increase docker container's storage size?

```bash
sudo dockerd --storage-opt dm.basesize=150G
```
Please, note! It will restart your docker!
After the restart, you will not lose any data, which was there in the containers.
