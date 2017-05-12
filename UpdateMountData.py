#
# Input data obtained from the Battle.NET API
#
# How to get/update the data:
# * Get an API key from https://dev.battle.net/
# * Create a file called "apikey" in the same directory as this script and put your Battle.NET API key in there.
# * Run this script, it will update mounts.lua with the latest data from the API
# * Commit and release
#

import requests
import json

def GenerateLuaOutput(name, itemList):
    with open("{0}.lua".format(name), "w") as text_file:

        text_file.write( "-- Do not edit\n")
        text_file.write( "-- This file is generated from data obtained from the Battle.net API\n")
        text_file.write( "\n")
        text_file.write( "local addonName, AHMP = ...\n")
        text_file.write( "\n")
        text_file.write( "local {0} = {{}}\n".format(name))
        text_file.write( "\n")

        for itemId in sorted(itemList.keys()):
            text_file.write( "{0}[{1}] = {{ creatureId = {2}, spellId = {3} }}  -- {4}\n".format(name, itemId, itemList[itemId]["creatureId"], itemList[itemId]["spellId"], itemList[itemId]["name"]))
            
        text_file.write("\n")
        text_file.write("AHMP.{0} = {0}\n".format(name))
        text_file.write("\n")


def GetApiKey():
    with open ("apikey", "r") as apikeyfile:
        apikey = apikeyfile.readline()
        return apikey
        

# Gather relevant data from json obtained from the Battle.net API
r = requests.get('https://eu.api.battle.net/wow/mount/?locale=en_GB&apikey={}'.format(GetApiKey()))
if r.status_code == 200:
    data = r.json()

    mounts = {}
    for mount in data["mounts"]:
        # Mounts without itemIds are not learned from items and therefore cannot be on the AH or vendor and can be excluded
        # for example the Paladin and Warlock mounts
        if mount["itemId"]:
            mounts[mount["itemId"]] = { 'name': mount["name"], 'creatureId': mount["creatureId"] , 'spellId': mount["spellId"] }

    GenerateLuaOutput("mounts", mounts)
