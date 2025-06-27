SSH Key Update
==============

Purpose
-------

This script automatically updates the `authorized_keys` file for your root user depending on the permissions from ZeyOS. It allows you to centrally manage which users should have access to which server, instead of manually editing all the authorized keys files.

Setup
-----

1. Add the extdata form for the `users` object and the REST service to your [ZeyOS](https://www.zeyos.com) platform.
2. Edit the server list in the form and start assigning permissions and public keys to your users in the user management module.
3. On the Linux machines, clone the repository to the `/opt` directory:

   ```bash
   cd /opt/
   git clone https://github.com/zeyosinc/sshkeymgr.git
   ```

4. Ensure that the script can be executed:

   ```bash
   chmod +x /opt/sshkeymgr/sshkeymgr.sh
   ```

5. Optionally, create a `keys` directory next to the script and place additional public key files inside. Only valid SSH public keys will be appended to the target file.

6. Add a new cronjob to `/etc/cron.d`:

   ```
   # /etc/cron.d/zeyos-sshkeymgr
   # Updates the authorized_keys every hour

   0 * * * *   root   /opt/sshkeymgr/sshkeymgr.sh [--target /custom/path] PLATFORMID SERVERNAME >/dev/null 2>&1
   ```

   Replace `PLATFORMID` with your ZeyOS platform ID and `SERVERNAME` with the server name specified in your server list. You may optionally use `--target` to specify a custom authorized_keys path.

That's it, hope you find this helpful!

Sample Screen
-------------

This is a sample of how the user management in ZeyOS looks like:

![Sample screen](https://raw.githubusercontent.com/zeyosinc/sshkeymgr/master/ZeyOS/screenshot.png)