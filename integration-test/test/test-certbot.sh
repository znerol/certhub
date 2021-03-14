#!/bin/sh

set -e
set -u
set -x

STATUS=1

/bin/journalctl -fu certhub-certbot-run@certbot-test.service &
if /bin/systemctl start certhub-certbot-run@certbot-test.service; then
    STATUS=0
fi

exit ${STATUS}
