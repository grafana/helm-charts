#!/bin/bash

CHARTVERSION=$(jx-release-version -previous-version=from-file:"$1")
export CHARTVERSION

yq eval '.version = env(CHARTVERSION)' -i "$1"
