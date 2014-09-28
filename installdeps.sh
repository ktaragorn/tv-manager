#!/bin/sh
sudo apt-get install libx11-dev libpng12-dev #for tk
cpan -i YAML DBI DBD::CSV File::Spec::Functions SQL::Interp Tk Sort::Naturally File::Find::Rule Switch
