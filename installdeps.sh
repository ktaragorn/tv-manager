#!/bin/sh
sudo apt-get install libx11-dev #for tk
cpan -i DBI DBD::CSV File::Spec::Functions SQL::Interp Tk Sort::Naturally File::Find::Rule
