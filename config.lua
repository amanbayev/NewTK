application =
{

	content =
	{
		width = 985,
		height = 1280, 
		scale = "zoomEven",
		fps = 30,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	
	-- Push notifications
	notification =
	{
		google = { projectNumber = "558014537240", },
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	    
}
