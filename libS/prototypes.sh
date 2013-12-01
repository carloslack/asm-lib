#!/bin/bash
cat libS.S | grep -o "fn.*" |cut -d " " -f2-9999 >main.h
