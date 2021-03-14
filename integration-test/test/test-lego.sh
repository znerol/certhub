#!/bin/sh

set -e
set -u
set -x

STATUS=1

/bin/journalctl -fu certhub-lego-run@lego-test.service &
if /bin/systemctl start certhub-lego-run@lego-test.service; then
    STATUS=0
fi

exit ${STATUS}
