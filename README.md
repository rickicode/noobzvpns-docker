# NoobzVpn-Server

### What is NoobzVpn ?

Independent tunneling protocol is now in stable stage git-master repository.

### How is work ?

Like other VPN this app just bypass network traffic like tcp,udp including dns. with wide-custom payload and more flexibility. unlike openvpn / ssh tunnel using Concurrent Transport, we use Multiplex Transport (like shadowsock) model with more flexibility to custom Transport model. :)

### Tunneling :

- Dual-Stack IPv4/IPv6
- All TCP, UDP, DNS

### Transport :

- Dual-Stack IPv4/IPv6
- TCP plain & SSL (HTTP/WebSocket/Direct/Etc, custom with your own :p)
- UDP (QUIC/DNS/Etc) ? #comming_soon, we not include it yet. because very poor in my test. but we keep working on it.

# Guide

### Minimum Requiment :

- Linux x86_64 with systemd init.
- 1 Core CPU, 512MB RAM, 500MB Disk Available (my extreme test)
- For other Linux with CPU x86(32bit), arm, arm64 server you can request and join beta test.
- For other init system, you can contribute this project to create/add support for other init system like s6, SysV, runit, OpenRC, etc...

### Installation :

- follow this step with **root user / root access** (sudo/doas/etc)

##### Docker CLI

```
docker run -d \
  --name noobz \
  --restart unless-stopped \
  -p 8885:8880 \
   rickicode/noobzvpns-docker:latest
```

##### Docker Compose

```
version: '3.8'

services:
  noobz:
    image: 'rickicode/noobzvpns-docker:latest'
    container_name: noobz
    restart: unless-stopped
    ports:
      - '8880:8880'
      - '4433:4433'
```

### Manage Service:

##### Start Service

- start service, you need to start it after installation to run noobzvpns service

#

```bash
systemctl start noobzvpns.service
```

##### Restart Service

- restart service, if you change configuration you need to restart the service

```bash
systemctl restart noobzvpns.service
```

##### Stop Service

- stop service, if you want to stop it

```bash
systemctl stop noobzvpns.service
```

##### Auto Start

- enable auto-start service after reboot or at boot. (enabled by default)

```bash
systemctl enable noobzvpns.service
```

- disable auto-start service (you can start it manually)

```bash
systemctl disable noobzvpns.service
```

##### Status

- simple log to see noobzvpns service status and check the error if needed

```bash
systemctl status noobzvpns.service -l
```

##### Logs

- see full logs to see error, warning, debug etc.

```bash
journalctl -u noobzvpns.service
```

### Configuration :

- `/etc/noobzvpns/config.json`

- | key          | range                                          | type                    | example                                                                                         | description                                                                                                                                                                                                                                                                            |
  | ------------ | ---------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | tcp_std      | 1-65535                                        | number-array            | [80,8080]                                                                                       | server port of tcp plain protocol                                                                                                                                                                                                                                                      |
  | tcp_ssl      | 1-65535                                        | number-array            | [443, 4433]                                                                                     | server port of tcp with ssl protocol                                                                                                                                                                                                                                                   |
  | ssl_cert     | can't be empty                                 | string-path             | "/etc/noobzvpns/cert.pem"                                                                       | ssl certificate, you can create self-signed certificate on your own. or using letsencrypt/certbot as alternative                                                                                                                                                                       |
  | ssl_key      | can't be empty                                 | string-path             | "/etc/noobzvpns/key.pem"                                                                        | ssl privatekey, both ssl_cert & ssl_key you can create your own. or using free alternative like letsencrypt with certbot                                                                                                                                                               |
  | ssl_version  | SSLv2, SSLv23, TLSv1_1, TLSv1_2, TLSv1_3, AUTO | string-unsensitive-case | AUTO                                                                                            | select spesific SSL/TLS version or set to AUTO for automatic selection (recommended, be flexible to client)                                                                                                                                                                            |
  | conn_timeout | 5-60                                           | number-by-seconds       | 60                                                                                              | give client connection timeout when no data arrived/sended                                                                                                                                                                                                                             |
  | dns_resolver | empty or resolv.conf path                      | string-path             | /etc/resolv.conf                                                                                | dns resolver file, on many distribution like debian/ubuntu/base using /etc/resolv.conf to save dns address (nameserver), you can create and set new one (don't change /etc/resolv.conf) just create file like /etc/resolv.conf with "**nameserver dns1**", "**nameserver dns2**", etc. |
  | http_ok      | [cr],[lf][crlf],[lfcr]                         | smart-string-replacer   | "HTTP/1.1 101 Switching Protocols[crlf]Upgrade: websocket[crlf]Connection: Upgrade[crlf][crlf]" | HTTP response for send to client if client detected using HTTP/s transport                                                                                                                                                                                                             |

### SSL Certificate

noobzvpn server has default ssl certificate (self-signed certificate) generated by openssl

##### SSL Certificate

```
/etc/noobzvpns/cert.pem
```

##### SSL Private Key

```
/etc/noobzvpns/key.pem
```

You can change it using your own certificate or free certificate from [Let's Encrypt](https://letsencrypt.org/) using [cerbot](https://certbot.eff.org/) or [acme.sh](https://github.com/acmesh-official/acme.sh) , see configuration details above to settings path for ssl certificate and ssl private key.

### User Account

Managing user(s) its simple and done by command line, adding user, set expired days, etc. you need a **_root user / root access_** to do this.

##### Add User

Register / Add new User followed by Password

```bash
noobzvpns --add-user [username] [password]
```

- username maximum is 16 characters
- only allow characters (A-Z a-z 0-9 . - \_ @)
- password must be filled with any characters and make sure to keep strong enough

##### Block User

Blocking registered user for disable tunneling service

```bash
noobzvpns --block-user [username]
```

- only registered user you can do this

##### Unblock User

Unblocking blocked registered user to allow user for tunneling service

```bash
noobzvpns --unblock-user [username]
```

- only registered user you can do this

##### Set Expiration

setup for expiration days per-user

```bash
noobzvpns --expired-user [username] [days]
```

- only registered user you can set this
- **0** : unlimited days (no expiration)
- **1-n** : limited by days

##### Renew Expiration

Re-new issued date, when user has expired you can re-new the expiration by updating issued date.

```bash
noobzvpns --renew-user [username]
```

- only registered user you can do this

##### Change Password

Change password for registered user

```bash
noobzvpns --password-user [username] [new_password]
```

- only registered user you can do this

##### Rename User

Change username for registered user

```bash
noobzvpns --rename-user [old_username] [new_username]
```

- only registered user you can do this

##### Remove User

Remove/Delete for registered user

```bash
noobzvpns --remove-user [username]
```

- only registered user you can do this

##### Remove All User

**_WARNING_** clean up / remove all registered user(s), be careful this action can't be undone and no confirmation after executed.

```bash
noobzvpns --remove-all-user
```

##### Info User

Get specific Info for registered user, like password, issued date, expiration days, status (block/expired/active).

```bash
noobzvpns --info-user [username]
```

- only registered user you can do this

##### Info All Users

Get Info All about registered users like password, issued date, expiration days, status (block/expired/active).

```bash
noobzvpns --info-all-user
```

##### NOTE :

- You can combine commands above, just for example:

```bash
# noobzvpns --add-user [username] [password] --expired-user [username] [days]
noobzvpns --add-user Admin-123 SeCuRePaSsWoRd456 --expired-user Admin-123 30
```

- for offline guide commands you just execute `noobzvpns` in your terminal / ssh and see the guide.
- HIDDEN Command just for testing / debugging. maybe not for you, just ignore it :)

```bash
noobzvpns --start-service --debug
```
