#!/bin/bash

# I make this script publicly available under the term "public domain software."
# You can do whatever you want with it because it is truly free—unlike so-called "free" software with conditions, like the GNU licenses and other similar nonsense.
# If you're so eager to talk about freedom, then make it truly free.
# You don't have to accept any terms of use or license to use or modify it, because it comes with no CopyLeft.

# ----------
# NiPeGun's script to create an iso file from the ChromeOS .bon file
#
# Remote execution (may require sudo privileges):
#   curl -sL x | bash
#
# Remote execution as root (for systems without sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Remote execution without cache:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Remote execution with parameters:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Download and edit the file directly in nano:
#   curl -sL x | nano -
