#!/bin/bash

scp $@ dec41@linux.ds.cam.ac.uk:`echo $PWD | sed 's|.*/notes|public_html/notes|'`
