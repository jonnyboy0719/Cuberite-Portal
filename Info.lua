g_PluginInfo =
{
	Name = "Portal-v2",
	Version = "3.0.0",
	Date = "2015-11-09",
	SourceLocation = "https://github.com/jonnyboy0719/Cuberite-Portal/",
	Description = [[Create portals to other places on the world, or to other worlds!]],

	Commands =
	{
		["/ptoggle"] =
		{
			Permission = "portal.create",
			Handler = HandleToggleCommand,
			HelpString = "Switches to volume selection mode",
			ParameterCombinations = {
			  {
			  	Params = "",
			  	Help = "toggles the selection mode",
				}
			},
		},

		["/pcreate"] =
		{
			Permission = "portal.create",
			Handler = HandleMakeWarpCommand,
			HelpString = "Creates warp point with given name",
			ParameterCombinations = {
			  {
			  	Params = "<portalName>",
			  	Help = "portal called <portalName> gets created if it doesn't exist",
				}
			},
		},

		["/pconnect"] =
		{
			Permission = "portal.create",
			Handler = HandleConnectCmd,
			HelpString = "Connects 2 portals together",
			ParameterCombinations = {
			  {
			  	Params = "<portalName1> <portalName2>",
			  	Help = "portalName1 gets connected to PortalName2. If portalName2 is already a target of portalName1 it is removed",
				}
			},
		},

		["/pdest"] =
		{
			Permission = "portal.create",
			Handler = HandleMakeDestinationCommand,
			HelpString = "Create the destination for a portal",
			ParameterCombinations = {
			  {
			  	Params = "<portalName>",
			  	Help = "portal destination set to your position",
				}
			},
		},
		["/pinfo"] =
		{
			Permission = "portal.info",
			Handler = HandleInfoCmd,
			HelpString = "lists portals, or details for portal/player",
			ParameterCombinations = {
			  {
				  Params = "",
				  Help = "Lists out all portals with connections",
				},
			  {
				  Params = "<portalName>",
				  Help = "Shows individual portal config",
				},
			  {
				  Params = "<playerName>",
				  Help = "Shows current plugin state for a player",
				},
			  {
				  Params = "me",
				  Help = "Shows current plugin state for current player",
				},
			},
		},
		["/pmanage"] =
		{
			Permission = "portal.manage",
			Handler = handleManageCmd,
			HelpString = "enable/disable individual portals or all at once",
			ParameterCombinations = {
				{
					Params = "enable/disable <portalName>",
					Help = "Enable or disable a portal",
				},
				{
					Params = "enable/disable all",
					Help = "Enable or disable all portals",
				},
			},
		},
		["/pteleport"] = 
		{
			Permission = "",
			Handler = HandleTeleport,
			HelpString = "teleports the user when they are in a teleport hub",
			ParameterCombinations = {
			  {
			  	Params = "portalName",
			  	Help = "",
			  },
			},
		},
		["/phelp"] =
		{
		  Permission = "",
		  Handler = HandleHelpCmd,
		  HelpString = "Prints available commands for plugin or details about a command",
			ParameterCombinations = {
			  {
			  	Params = "",
			  	Help = "prints all commands",
				},
			  {
			  	Params = "<commandName>",
			  	Help = "prints command help",
				},
			},
		},
	},
} 
