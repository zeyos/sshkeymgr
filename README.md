SSH Key Update
==============

Purpose
-------

This script automatically updates the `authorized_keys` file for your root user depending on the permissions form ZeyOS.
I created the script in order to centrally manager which users should have access to which server, instead
of manually editing all the authorized keys files manually.


Setup
-----

Add the extdata form and the REST service to [ZeyOS](https://www.zeyos.com)
Edit the server list and start assiging permissions and public keys to your users.

On the linux machines, check out the repository to the `/opt` directoy.

```
cd /opt/
git clone https://github.com/zeyosinc/sshkeymgr.git
```

Ensure that the script can be executed

```
chmod +x /opt/sshkeymgr/sshkeymgr.sh
```


Add a new cronjob to `/etc/cron.d`:

```
# /etc/cron.d/zeyos-sshkeymgr
# Updates the authorized_keys every hour

0 * * * * /opt/sshkeymgr/sshkeymgr.sh PLATFORMID SERVERNAME >/dev/null 2>&1
```

Replace `PLATFORMID` with your ZeyOS platform ID and `SERVERNAME` with the server name you have specified in your server list.

That's it, hope you find this helpful!
