## tidydirs
Keeps dir trees tidy. `mktdir` creates a *tidydir,* which has the following characteristics:
- contains an '_in' folder by default, where you can place stuff which you plan to move to some location down that folder path,
- contains an '_out' folder by default, for stuff which should be moved to a different tree brach,
- contains a '_misc' folder by default, which you can use at your discretion, but is carpet we sweep our stuff under for a very "tidy" tidydir.

Everything will be moved to _misc by a daily cron job which
- is not itself a *tidydirs*
- is not a static organisational folder like '_misc', which start with an underscore, and
- has not been touched in 72 hours.

To be added: helpers to parse the _misc folders to delete duplicates, find largest files and quickly and comfortably move stuff around the file tree, etc. So Far no magic, but helps me avoid folders growing full of junk over time and keep better overview.

## Install and run
Clone repo and run `make install` with root privileges. After that, you can use `mktdir` and the cron job should be running.

---
