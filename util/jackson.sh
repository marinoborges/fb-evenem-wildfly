#!/bin/bash
cd $JBOSS_HOME
zip jackson.zip ./modules/system/layers/base/com/fasterxml/jackson/core/*/main/module.xml ./modules/system/layers/base/com/fasterxml/jackson/core/*/main/*2.8.8*
