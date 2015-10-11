g_PluginInfo = 
{
	Name = "Portal",
	Version = "2.0.3",
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

		["/pwarp"] = 
		{
			Permission = "portal.create",
			Handler = HandleMakeWarpCommand,
			HelpString = "Creates warp point with given name",
		},

		["/penter"] = 
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
	},
}