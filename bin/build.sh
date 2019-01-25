#!/bin/bash
./bin/clean.sh
name=game

zip -r -0 $name.love data/*
cd src/ && zip -r ../$name.love *
