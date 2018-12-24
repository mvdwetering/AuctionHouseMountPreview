#
# Input data obtained from the Battle.NET API
#
# How to get/update the data:
# * Get an API key from https://develop.battle.net/
# * Create files called "client_id" and "client_secret" in the same directory as this script and put your Battle.NET API Client ID and Client Secret in there.
# * Run this script, it will update mounts.lua with the latest data from the API
# * Commit and release
#

from wowapi import WowApi

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

def GetClientId():
    return GetFirstLineOfFile("client_id")

def GetClientSecret():
    return GetFirstLineOfFile("client_secret")

def GetFirstLineOfFile(name):
    with open (name, "r") as thefile:
        firstline = thefile.readline()
        return firstline

def main():
    api = WowApi(GetClientId(), GetClientSecret())
    response = api.get_mounts("eu")

    mounts = {}
    for mount in response["mounts"]:
        # Mounts without itemIds are not learned from items and therefore cannot be on the AH or vendor.
        # Examples are the Paladin and Warlock mounts
        if mount["itemId"]:
            mounts[mount["itemId"]] = { 'name': mount["name"], 'creatureId': mount["creatureId"] , 'spellId': mount["spellId"] }

    GenerateLuaOutput("mounts", mounts)

if __name__ == "__main__":
    main()
