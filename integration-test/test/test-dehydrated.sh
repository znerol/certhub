#!/bin/sh

set -e
set -u
set -x

STATUS=1

su -s /bin/sh -c "dehydrated --register --accept-terms --config /etc/certhub/dehydrated-test.dehydrated.conf" - certhub
journalctl -fu certhub-dehydrated-run@dehydrated-test.service &
if systemctl start certhub-dehydrated-run@dehydrated-test.service; then
    STATUS=0
fi

exit ${STATUS}
