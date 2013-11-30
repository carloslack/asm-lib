#!/bin/bash
grep _sig_ libS.S |cut -d ":" -f2 > main.h
