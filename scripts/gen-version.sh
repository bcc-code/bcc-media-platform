#!/bin/bash

sed -i bak s/DEVELOP/$(git rev-parse --short HEAD)/g version.json
