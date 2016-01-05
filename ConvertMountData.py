#
# Input data obtained from the Battle.NET API
#
# How to get/update the data:
# Use the docs page to "try" the API (login first to get the access token)
# https://dev.battle.net/io-docs
#
# Then GET the mount masterlist from /wow/mount
# Copy paste the response in the mounts.json file
#
# Run this script and redirect the output to mounts.lua
#

import json

mounts = {}

# Gather relevant data from json obtained from the Battle.net API
with open("mounts.json") as data_file:    
    data = json.load(data_file)
    
    filemounts = data["mounts"]
    
    for mount in filemounts:
        # Mounts without itemIds are not learned from items and therefore cannot be on the AH and can be excluded
        # for example the paladin adn warlock mounts
        if mount["itemId"]:
            mounts[mount["itemId"]] = { 'name': mount["name"], 'creatureId': mount["creatureId"] }


# Generate lua output
print "-- Do not edit"
print "-- This file is generated from data obtained from the Battle.net API"
print ""
print "local addonName, AHMP = ..."
print ""
print "local mounts = []"
print ""

for itemId in mounts:
    print "mounts[{0}] = {1}  -- {2}".format(itemId, mounts[itemId]["creatureId"], mounts[itemId]["name"])
    
print ""
print "AHMP.mounts = mounts"
print ""
