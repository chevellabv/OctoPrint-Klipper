#!/usr/bin/env python3

import subprocess
import time
import os
import pwd

OCTOPRINT = ["/opt/octoprint/venv/bin/octoprint", "serve"]


def main():
    # Start klipper
    klipper = subprocess.Popen(['sudo', '-u', 'octoprint', '/runklipper.py'])
    
    os.setgid(1000)
    os.setuid(1000)
    os.environ['HOME'] = '/home/octoprint'

    while 1:
        Poctoprint = subprocess.Popen(OCTOPRINT)
        Poctoprint.wait()
        time.sleep(1)


if __name__ == '__main__':
    main()

