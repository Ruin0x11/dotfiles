#! /usr/bin/env python2
from subprocess import check_output

def get_pass():
    return check_output("gpg -dq ~/.config/offlineimap/pass.gpg", shell=True).strip("\n")
