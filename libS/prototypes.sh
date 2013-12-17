#!/bin/bash
>main.h
ls l*.S |while read line ; do
    cat $line | grep -o "fn.*" |cut -d " " -f2-9999 >>main.h
done
