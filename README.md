#Cuberite-Portal

This project is a plugin for the [cuberite](https://cuberite.org/) minecraft server. It allows users to create and use portals in minecraft.

---

##Installation

To install either use [git](https://git-scm.com/) if you know how, or go to the [releases](https://github.com/curioussavage/Cuberite-Portal/releases) page on github and download the latest version. place it in the `PLugins` folder inside your cuberite server install.


---
##Setup and Configuration

No configuration is required for the plugin itself, but you must enable the plugin by adding the line `Plugin=Cuberite-Portal`  to the `settings.ini` file in your cuberite servers folder. Or alternatively start cuberite and in the web admin under on the plugins page you can enable it.

*("Cuberite-Portal" is the name of the folder so if you name the folder that has the plugin files differently make sure to change this to match)*

---
## Usage

Normal players only interact with the plugin by entering portals and being sent somewhere else. If a portal has multiple destinations they will be prompted with a list of options and told to use the command `/pteleport <name>` to choose where to go.

Users who are tasked with making portals will need to complete the following steps.

1. use `/ptoggle` to enable selection mode. User must use a wooden sword to select points. Only left clicking works for this.
2. After two points are selected *(usually the two base blocks of columns)* the portal is created with `/pcreate <portalName>`
3. The user must use `/dest <portalName>` to set where the plugin will teleport someone when they go to this portal *(this can be inside the portal or somewhere nearby)*
4. To be used the portal must be connected to another portal. Once you have another portal use `/pconnect <portalName> <destinationPortalName>` to connect them. This must be done in each direction if you want players to be able to teleport both ways If you enter the command again that portal will be removed from the possible destinations. Multiple destinations may be added.

---
##Commands

1. `/ptoggle` - togggle the selection mode
2. `/pcreate` - create a portal
3. `/pconnect` - add/remove destinations
4. `/pinfo` - get information about portals
5. `/pmanage` - disable/enable portals
6. `/pteleport` - choose a destination when in a portal with multiple options.
7. `/phelp` - get information about commands.

