#!/usr/bin/env python3

import subprocess
import time
import os
import pwd

def main():
    mjpg_input = os.environ["MJPG_STREAMER_INPUT"]
    mjpg_device = os.environ["CAMERA_DEV"]
    cmd = ["sudo","/usr/local/bin/mjpg_streamer","-i","\"/usr/local/lib/mjpg-streamer/input_uvc.so {} -d {}\"".format(mjpg_input, mjpg_device),"-o","\"/usr/local/lib/mjpg-streamer/output_http.so -w /usr/local/share/mjpg-streamer/www -p 8080\""]
    klipper = subprocess.Popen(cmd)

    while 1:
        klipper.wait()
        time.sleep(1)


if __name__ == '__main__':
    main()
