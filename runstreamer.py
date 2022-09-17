#!/usr/bin/env python3

import subprocess
import time
import os
import pwd

def main():
    while 1:
        mjpg_input = os.environ("MJPEG_STREAMER_INPUT")
        mjpg_device = os.environ("CAMERA_DEV")
        cmd = "/usr/local/bin/mjpg_streamer -i \"/usr/local/lib/mjpg-streamer/input_uvc.so {} -d {}\" -o \"/usr/local/lib/mjpg-streamer/output_http.so -w /usr/local/share/mjpg-streamer/www -p 8080\"".format(mjpg_input, mjpg_device)
        klipper = subprocess.Popen(cmd.split(" "))
        if klipper.wait() == 0:
            # Exited cleanly, don't sleep for long
            time.sleep(1)
        else:
            # Something went wrong, wait a bit before trying again
            time.sleep(30)


if __name__ == '__main__':
    main()
