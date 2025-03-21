const structures = { 
	# variables from ListMods.gd
	"manifestDict":{ # current mods in the mods folder
		"manifestID for mod (recursive for all mods installed)":[
			"0 - mod name",
			"1 - zip name",
			"2 - mod folder relative to res://",
			"3 - mod version",
			"4 - github page",
			"5 - github releases page",
			"6 - current timestamp"
		]
	},
	"compiledData":[ # data for the given mod
		"0 - mod name",
		"1 - zip file name",
		"2 - mod priority",
		"3 - res:// folder name",
		"4 - mod version",
		"5 - mod description string from manifest",
		"6 - github page",
		"7 - github releases page",
		"8 - discord thread",
		"9 - nexusmods page",
		"10 - donation link",
		"11 - wiki link",
		"12 - custom link URL",
		"13 - custom link tooltip string",
		"14 - mod icon path",
		"15 - mod id from manifest",
	],
	"conflictData accepted any version identifiers":[
		"",
		"null",
		"unknown",
		"any",
		"0",
		"x",
		"*"
	]
}
