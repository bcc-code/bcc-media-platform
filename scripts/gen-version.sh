#!/bin/bash

sed -ibak s/DEVELOP/$(git rev-parse --short HEAD)/g version.json
