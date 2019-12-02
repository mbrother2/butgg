# butgg
Simple backup solution from your server to Google Drive use curl

# What can this script do?
- Create cron auto backup
- Send error email if upload to Google Drive fail
- Auto remove old backup on Google Drive
- Run upload from your backup directory to Google Drive whenever you want
- Detail log

# Structure
```
$HOME (/root or /home/$USER)
   ├── bin
   │    ├── butgg.bash
   │    ├── cron_backup.bash
   │    └── gdrive.bash
   └── .butgg
        ├── butgg.conf
        ├── butgg.log
        ├── detail.log (exist if config email & upload fail)
        └── token.json
```
# OS support(x86_64):
- **Linux:** CentOS, Debian, Ubuntu, openSUSE
- **Commercial:** CloudLinux, SUSE Linux Enterprise

# Environment
- Server, VPS, shared hosting
---

# How to use
**On Linux system:**
```
curl -o butgg.bash https://raw.githubusercontent.com/mbrother2/butgg/master/butgg.bash
bash butgg.bash --setup
```

# Wiki
##### [Create own Google credential step by step](https://github.com/mbrother2/butgg/wiki/Create-own-Google-credential-step-by-step)
##### [Get Google folder ID](https://github.com/mbrother2/butgg/wiki/Get-Google-folder-ID)
##### [Turn on 2 Step Verification & create app's password for Google email](https://github.com/mbrother2/butgg/wiki/Turn-on-2-Step-Verification-&-create-app's-password-for-Google-email)
##### [How to use gdrive.bash](https://github.com/mbrother2/butgg/wiki/How-to-use-gdrive.bash)

# Change log
https://github.com/mbrother2/butgg/blob/master/CHANGLOG.md

# Options
Run command `bash butgg.bash --help` to show all options( After install you only need run `butgg.bash --help`)
```
butgg.bash - Backup to Google Drive solution

Usage: butgg.bash [options] [command]

Options:
  --help       show this help message and exit
  --setup      setup or reset all scripts & config file
    config     only setup config
    credential only setup credential
    no-update  setup butgg without update script
  --update     update to latest version
  --uninstall  remove all butgg scripts and .butgg directory
```

# Command
###### 1. Help
`butgg.bash --help`
Show help message and exit
##### Example
```
[thanh1@centos7 .gdrive]$ butgg.bash --help
butgg.bash - Backup to Google Drive solution

Usage: butgg.bash [options] [command]

Options:
  --help       show this help message and exit
  --setup      setup or reset all scripts & config file
    config     only setup config
    credential only setup credential
    no-update  setup butgg without update script
  --update     update to latest version
  --uninstall  remove all butgg scripts and .butgg directory
```

###### 2. Setup
`butgg.bash --setup`
Set up or reset all scripts & config file
##### Example
```
thanh3@ubuntu1804:~$ bash butgg.bash --setup
[ 29/11/2019 08:32:37 ] ---
[ 29/11/2019 08:32:37 ] Creating necessary directory...
[ 29/11/2019 08:32:37 ] Create directory /home/thanh3/.butgg successful
[ 29/11/2019 08:32:37 ] Check write to /home/thanh3/.butgg successful
[ 29/11/2019 08:32:37 ] Create directory /home/thanh3/bin successful
[ 29/11/2019 08:32:37 ] Check write to /home/thanh3/bin successful
[ 29/11/2019 08:32:37 ] Checking OS...
[ 29/11/2019 08:32:37 ] OS supported
[ 29/11/2019 08:32:37 ] Checking necessary package...
[ 29/11/2019 08:32:37 ] Package curl is installed
[ 29/11/2019 08:32:37 ] Cheking network...
[ 29/11/2019 08:32:37 ] Connect Github successful
[ 29/11/2019 08:32:38 ] Connect Google successful
[ 29/11/2019 08:32:38 ] Downloading gdrive script from github...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11707  100 11707    0     0  23274      0 --:--:-- --:--:-- --:--:-- 23228
[ 29/11/2019 08:32:39 ] Check md5sum for file gdrive.bash successful
[ 29/11/2019 08:32:39 ] Downloading script cron file from github...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 10571  100 10571    0     0  20289      0 --:--:-- --:--:-- --:--:-- 20250
[ 29/11/2019 08:32:40 ] Check md5sum for file cron_backup.bash successful
[ 29/11/2019 08:32:40 ] Downloading setup file from github...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 13999  100 13999    0     0  52235      0 --:--:-- --:--:-- --:--:-- 52430
[ 29/11/2019 08:32:40 ] Check md5sum for file butgg.bash successful
[ 29/11/2019 08:32:40 ] Setting up gdrive credential...
Read more: https://github.com/mbrother2/butgg/wiki/Create-own-Google-credential-step-by-step
 Your Google API client_id: 782896115405-qs2evi3rqlnkjm2vond8onilq9xxxxxx.apps.googleusercontent.com
 Your Google API client_secret: g7p_kcdNEq_ULsfxrTxxxxxx

Authentication needed
Go to the following url in your browser:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=782896115405-qs2evi3rqlnkjm2vond8onilq9xxxxxx.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=state

Enter verification code: 4/twHfAyKzH1F9KuDZVLnoe0z8Dy0WwH5S9VMiWOpzMZqIGfF0Xxxxxxx
Generating token file...
Email: backupxxxxxx@gmail.com
Total: 15.00 GB
Used : 0 B
Free : 15.00 GB
[ 29/11/2019 08:33:40 ] Setup gdrive credential successful
[ 29/11/2019 08:33:40 ] Setting up config file...

 Which directory on your server do you want to upload to Google Drive?(default /home/thanh3/backup): 
 How many days do you want to keep backup on Google Drive?(default 7): 

Read more https://github.com/mbrother2/butgg/wiki/Get-Google-folder-ID
 Your Google folder ID(default None): 

Read more https://github.com/mbrother2/butgg/wiki/Turn-on-2-Step-Verification-&-create-app's-password-for-Google-email
 Do you want to send email if upload error(default no)(y/n): 

[ 29/11/2019 08:34:05 ] [WARNING] Directory /home/thanh3/backup does not exist! Ensure you will be create it after.
[ 29/11/2019 08:34:08 ] Setup config file successful
[ 29/11/2019 08:34:08 ] Setting up cron backup...
no crontab for thanh3
[ 29/11/2019 08:34:08 ] Setup cronjob to backup successful

[ 29/11/2019 08:34:08 ] +-----
[ 29/11/2019 08:34:08 ] | SUCESSFUL! Your information:
[ 29/11/2019 08:34:08 ] | Backup dir      : /home/thanh3/backup
[ 29/11/2019 08:34:08 ] | Config file     : /home/thanh3/.butgg/butgg.conf
[ 29/11/2019 08:34:08 ] | Log file        : /home/thanh3/.butgg/butgg.log
[ 29/11/2019 08:34:08 ] | Keep backup     : 7 days
[ 29/11/2019 08:34:08 ] | Google folder ID: None
[ 29/11/2019 08:34:08 ] | Your email      : None
[ 29/11/2019 08:34:08 ] | Email password  : None
[ 29/11/2019 08:34:08 ] | Email notify    : None
[ 29/11/2019 08:34:08 ] | butgg.bash file : /home/thanh3/bin/butgg.bash
[ 29/11/2019 08:34:08 ] | Cron backup file: /home/thanh3/bin/cron_backup.bash
[ 29/11/2019 08:34:08 ] | gdrive.bash file: /home/thanh3/bin/gdrive.bash
[ 29/11/2019 08:34:08 ] | Cron backup     : 0 0 * * * bash /home/thanh3/bin/cron_backup.bash >/dev/null 2>&1
[ 29/11/2019 08:34:08 ] | Google token    : /home/thanh3/.butgg/token.json
[ 29/11/2019 08:34:08 ] +-----

IMPORTANT: Please run command to use butgg: source /home/thanh3/.profile 
If you get trouble when use butgg.bash please report here:
https://github.com/mbrother2/butgg/issues
```

---
`butgg.bash --setup config`
Only edit butgg.conf
##### Example
```
thanh3@ubuntu1804:~$ butgg.bash --setup config
[ 29/11/2019 08:53:46 ] ---
[ 29/11/2019 08:53:46 ] Creating necessary directory...
[ 29/11/2019 08:53:46 ] Directory /home/thanh3/.butgg existed. Skip
[ 29/11/2019 08:53:46 ] Check write to /home/thanh3/.butgg successful
[ 29/11/2019 08:53:46 ] Directory /home/thanh3/bin existed. Skip
[ 29/11/2019 08:53:46 ] Check write to /home/thanh3/bin successful
[ 29/11/2019 08:53:46 ] Setting up config file...

 Which directory on your server do you want to upload to Google Drive?(default /home/thanh3/backup): 
 How many days do you want to keep backup on Google Drive?(default 7): 

Read more https://github.com/mbrother2/butgg/wiki/Get-Google-folder-ID
 Your Google folder ID(default None): 

Read more https://github.com/mbrother2/butgg/wiki/Turn-on-2-Step-Verification-&-create-app's-password-for-Google-email
 Do you want to send email if upload error(default no)(y/n): 

[ 29/11/2019 08:53:50 ] [WARNING] Directory /home/thanh3/backup does not exist! Ensure you will be create it after.
[ 29/11/2019 08:53:53 ] Setup config file successful

[ 29/11/2019 08:53:53 ] +-----
[ 29/11/2019 08:53:53 ] | SUCESSFUL! Your information:
[ 29/11/2019 08:53:53 ] | Backup dir      : /home/thanh3/backup
[ 29/11/2019 08:53:53 ] | Keep backup     : 7 days
[ 29/11/2019 08:53:53 ] | Google folder ID: None
[ 29/11/2019 08:53:53 ] | Your email      : None
[ 29/11/2019 08:53:53 ] | Email password  : None
[ 29/11/2019 08:53:53 ] | Email notify    : None
[ 29/11/2019 08:53:53 ] | Config file     : /home/thanh3/.butgg/butgg.conf
[ 29/11/2019 08:53:53 ] +-----
```

---
`butgg.bash --setup credential`
Only reset Google Drive token
##### Example
```
thanh3@ubuntu1804:~$ butgg.bash --setup credential
[ 29/11/2019 08:54:20 ] ---
[ 29/11/2019 08:54:20 ] Creating necessary directory...
[ 29/11/2019 08:54:20 ] Directory /home/thanh3/.butgg existed. Skip
[ 29/11/2019 08:54:20 ] Check write to /home/thanh3/.butgg successful
[ 29/11/2019 08:54:20 ] Directory /home/thanh3/bin existed. Skip
[ 29/11/2019 08:54:20 ] Check write to /home/thanh3/bin successful
[ 29/11/2019 08:54:20 ] Setting up gdrive credential...

Authentication needed
Go to the following url in your browser:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=782896115405-qs2evi3rqlnkjm2vond8onilq9xxxxxx.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=state

Enter verification code: 4/twGPcleEacfd6I1VEMSYxpNE0J304z9UeIHoCp17N7cFRJMHfxxxxxx
Generating token file...
Email: backuptogg@gmail.com
Total: 15.00 GB
Used : 7.05 KB
Free : 15.00 GB
[ 29/11/2019 08:54:48 ] Setup gdrive credential successful
```

---
`butgg.bash --setup no-update`
Setup butgg without update script
##### Example
```
thanh3@ubuntu1804:~$ butgg.bash --setup no-update
[ 29/11/2019 08:56:29 ] ---
[ 29/11/2019 08:56:29 ] Creating necessary directory...
[ 29/11/2019 08:56:29 ] Directory /home/thanh3/.butgg existed. Skip
[ 29/11/2019 08:56:29 ] Check write to /home/thanh3/.butgg successful
[ 29/11/2019 08:56:29 ] Directory /home/thanh3/bin existed. Skip
[ 29/11/2019 08:56:29 ] Check write to /home/thanh3/bin successful
[ 29/11/2019 08:56:29 ] Checking OS...
[ 29/11/2019 08:56:29 ] OS supported
[ 29/11/2019 08:56:29 ] Checking necessary package...
[ 29/11/2019 08:56:29 ] Package curl is installed
[ 29/11/2019 08:56:29 ] Cheking network...
[ 29/11/2019 08:56:29 ] Connect Github successful
[ 29/11/2019 08:56:29 ] Connect Google successful
[ 29/11/2019 08:56:29 ] Setting up gdrive credential...

Email: backupxxxxxx@gmail.com
Total: 15.00 GB
Used : 7.05 KB
Free : 15.00 GB
[ 29/11/2019 08:56:31 ] Setup gdrive credential successful
[ 29/11/2019 08:56:31 ] Setting up config file...

 Which directory on your server do you want to upload to Google Drive?(default /home/thanh3/backup): 
 How many days do you want to keep backup on Google Drive?(default 7): 

Read more https://github.com/mbrother2/butgg/wiki/Get-Google-folder-ID
 Your Google folder ID(default None): 

Read more https://github.com/mbrother2/butgg/wiki/Turn-on-2-Step-Verification-&-create-app's-password-for-Google-email
 Do you want to send email if upload error(default no)(y/n): 

[ 29/11/2019 08:56:35 ] [WARNING] Directory /home/thanh3/backup does not exist! Ensure you will be create it after.

[ 29/11/2019 08:56:38 ] Setup config file successful
[ 29/11/2019 08:56:38 ] Setting up cron backup...
[ 29/11/2019 08:56:38 ] Cron backup existed. Skip

[ 29/11/2019 08:56:38 ] +-----
[ 29/11/2019 08:56:38 ] | SUCESSFUL! Your information:
[ 29/11/2019 08:56:38 ] | Backup dir      : /home/thanh3/backup
[ 29/11/2019 08:56:38 ] | Config file     : /home/thanh3/.butgg/butgg.conf
[ 29/11/2019 08:56:38 ] | Log file        : /home/thanh3/.butgg/butgg.log
/home/thanh3/.butgg/butgg.log
[ 29/11/2019 08:56:38 ] | Keep backup     : 7 days
[ 29/11/2019 08:56:38 ] | Google folder ID: None
[ 29/11/2019 08:56:38 ] | Your email      : None
[ 29/11/2019 08:56:38 ] | Email password  : None
[ 29/11/2019 08:56:38 ] | Email notify    : None
[ 29/11/2019 08:56:38 ] | butgg.bash file : /home/thanh3/bin/butgg.bash
[ 29/11/2019 08:56:38 ] | Cron backup file: /home/thanh3/bin/cron_backup.bash
[ 29/11/2019 08:56:38 ] | gdrive.bash file: /home/thanh3/bin/gdrive.bash
[ 29/11/2019 08:56:38 ] | Cron backup     : 0 0 * * * bash /home/thanh3/bin/cron_backup.bash >/dev/null 2>&1
[ 29/11/2019 08:56:38 ] | Google token    : /home/thanh3/.butgg/token.json
[ 29/11/2019 08:56:38 ] +-----

IMPORTANT: Please run command to use butgg: source /home/thanh3/.profile 
If you get trouble when use butgg.bash please report here:
https://github.com/mbrother2/butgg/issues
```
 
###### 3. Update
`butgg.bash --update`
Update to latest version
##### Example
```
[thanh1@centos7 .gdrive]$ butgg.bash --update
thanh3@ubuntu1804:~$ butgg.bash --update
[ 29/11/2019 08:58:02 ] ---
[ 29/11/2019 08:58:02 ] Creating necessary directory...
[ 29/11/2019 08:58:02 ] Directory /home/thanh3/.butgg existed. Skip
[ 29/11/2019 08:58:02 ] Check write to /home/thanh3/.butgg successful
[ 29/11/2019 08:58:02 ] Directory /home/thanh3/bin existed. Skip
[ 29/11/2019 08:58:02 ] Check write to /home/thanh3/bin successful
[ 29/11/2019 08:58:02 ] Checking OS...
[ 29/11/2019 08:58:02 ] OS supported
[ 29/11/2019 08:58:02 ] Checking necessary package...
[ 29/11/2019 08:58:02 ] Package curl is installed
[ 29/11/2019 08:58:02 ] Cheking network...
[ 29/11/2019 08:58:02 ] Connect Github successful
[ 29/11/2019 08:58:02 ] Connect Google successful
[ 29/11/2019 08:58:02 ] Downloading gdrive script from github...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11707  100 11707    0     0  20793      0 --:--:-- --:--:-- --:--:-- 20793
[ 29/11/2019 08:58:03 ] Check md5sum for file gdrive.bash successful
[ 29/11/2019 08:58:03 ] Downloading script cron file from github...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 10571  100 10571    0     0  20173      0 --:--:-- --:--:-- --:--:-- 20173
[ 29/11/2019 08:58:04 ] Check md5sum for file cron_backup.bash successful
[ 29/11/2019 08:58:04 ] Downloading setup file from github...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 14011  100 14011    0     0  22856      0 --:--:-- --:--:-- --:--:-- 22893
[ 29/11/2019 08:58:05 ] Check md5sum for file butgg.bash successful
```
###### 4. Uninstall
`butgg.sh --uninstall`
Remove all butgg scripts and .butgg directory
##### Example
```
[thanh1@centos7 .gdrive]$ butgg.bash --uninstall
[ 29/11/2019 09:05:14 ] ---
[ 29/11/2019 09:05:14 ] Removing all butgg.bash scripts...
[ 29/11/2019 09:05:14 ] Remove all butgg.bash scripts successful
 Do you want remove /home/thanh1/.butgg directory?(y/n) n
[ 29/11/2019 09:05:18 ] Skip remove /home/thanh1/.butgg directory
```
###### 5. Run upload to Google Drive immediately
`cron_backup.bash`
Run upload to Google Drive immediately without show log
`cron_backup.bash -v`
Run upload to Google Drive immediately with show log detail
##### Example
```
[thanh1@centos7 ~]$ cron_backup.bash -v
[ 29/11/2019 09:02:54 ] ---
[ 29/11/2019 09:02:54 ] Checking OS...
[ 29/11/2019 09:02:55 ] OS supported
[ 29/11/2019 09:02:55 ] Start upload to Google Drive...
[ 29/11/2019 09:02:56 ] Directory 14_11_2019 existed. Skipping...
[ 29/11/2019 09:02:57 ] Uploading file /home/thanh1/backup2/backup/a.txt to directory 14_11_2019...
[ 29/11/2019 09:02:59 ] [UPLOAD] Uploaded file /home/thanh1/backup2/backup/a.txt to directory 14_11_2019
[ 29/11/2019 09:02:59 ] Uploading file /home/thanh1/backup2/backup/b.txt to directory 14_11_2019...
[ 29/11/2019 09:02:02 ] [UPLOAD] Uploaded file /home/thanh1/backup2/backup/b.txt to directory 14_11_2019
[ 29/11/2019 09:02:02 ] Uploading directory /home/thanh1/backup2/backup/thanh1 to directory 14_11_2019...
[ 29/11/2019 09:02:03 ] [UPLOAD] Uploaded directory /home/thanh1/backup2/backup/thanh1 to directory 14_11_2019
[ 29/11/2019 09:02:03 ] Uploading directory /home/thanh1/backup2/backup/thanh2 to directory 14_11_2019...
[ 29/11/2019 09:02:04 ] [UPLOAD] Uploaded directory /home/thanh1/backup2/backup/thanh2 to directory 14_11_2019
[ 29/11/2019 09:02:04 ] Finish! All files and directories in /home/thanh1/backup2/backup are uploaded to Google Drive in directory 14_11_2019
[ 29/11/2019 09:02:05 ] Directory 15_10_2019 does not exist. Nothing need remove!
```
