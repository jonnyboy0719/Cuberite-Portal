g_PluginInfo =
{
	Name = "Portal-v2",
	Version = "2.0.4",
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
		},

		["/pinit"] =
		{
			Permission = "portal.create",
			Handler = HandleMakeWarpCommand,
			HelpString = "Creates warp point with given name",
		},

		["/pconnect"] =
		{
			Permission = "portal.create",
			Handler = HandleMakeEnterCommand,
			HelpString = "Connects 2 portals together",
		},

		["/pdest"] =
		{
			Permission = "portal.create",
			Handler = HandleMakeDestinationCommand,
			HelpString = "Create the destination for a portal ID",
		},
		["/plist"] =
		{
			Permission = "portal.info",
			Handler = HandleListPortals,
			HelpString = "List the created portals",
		},
		["/pdetail"] =
		{
			Permission = "portal.info",
			Handler = HandleListPortalDetails,
			HelpString = "List config for individual portal",
		},
		["/pplayerdata"] =
		{
			Permission = "portal.info",
			Handler = HandlePLayerDetails,
			HelpString = "List Current player state [for debugging]",
		},
		["/pdisable"] =
		{
			Permission = "portal.create",
			Handler = HandleToggleDisablePortal,
			HelpString = "Disables a portal",
		},
		["/penable"] =
		{
			Permission = "portal.create",
			Handler = HandleToggleDisablePortal,
			HelpString = "Enbales a portal",
		},
		["/pglobaltoggle"] =
		{
			Permission = "portal.create",
			Handler = HandleToggleAllPortalsdisabled,
			HelpString = "Toggles global portal disable",
		},
	},
} 
