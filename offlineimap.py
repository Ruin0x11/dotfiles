#! /usr/bin/env python2
from subprocess import check_output

def get_pass():
        check_output("panel-mail&", shell=True)
        return check_output("gpg -dq ~/.offlineimappass.gpg", shell=True).strip("\n")
