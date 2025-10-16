#!/bin/bash
set -e

/usr/lib/systemd/systemd-udevd --daemon
udevadm trigger --subsystem-match=input