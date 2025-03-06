extends Node

# Concatenates all parts of an array into a string
# Returns a string in the form of array[0] + array[1] + ... + array[n] etc.
func __array_to_string(arr: Array) -> String:
	var f = load("res://ModMenu/globals/array_to_string.gd").new()
	var s = f.array_to_string(arr)
	return s

# Lists all files in the zip by paths relative to the mod's name folder
# i.e. a zip only containing a folder and a text file return [folder/, file.txt]
# Returns an array of file paths in zip-relative form, stored alphabetically
# Strip_Parent_Folder removes the first folder item before the slash.
# To_Lower_Case converts all characters to lower
func __get_zip_content(path: String, Strip_Parent_Folder: bool = false, To_Lower_Case: bool = false) -> Array:
	var f = load("res://ModMenu/globals/get_zip_content.gd").new()
	var s = f.get_zip_content(path, Strip_Parent_Folder, To_Lower_Case)
	return s

# Loads a zip file and stores the requested files from paths relative to the root
# If you intend on taking data from a zip multiple times, this is a preferable method as it loads it to disk for future reference instead
# Does not work for fetching compressed data from within a zip (images, archives, .stex streams, etc)
# Defer to external programs for full unzip control
# Generates all folders in the zip file before handling the files to ensure they can save properly, but may cause clutter
# Outputs an array of all files saved to disk
# Handles case insensitivities
func __fetch_file_from_zip(path: String, Destination_Folder_Path: String, Desired_File_Paths: Array) -> Array:
	var f = load("res://ModMenu/globals/fetch_file_from_zip.gd").new()
	var s = f.fetch_file_from_zip(path, Destination_Folder_Path, Desired_File_Paths)
	return s

# Loads manifest data and returns it as a dictionary
func __load_manifest_from_file(manifest: String) -> Dictionary:
	var f = load("res://ModMenu/globals/load_manifest_from_file.gd").new()
	var s = f.load_manifest_from_file(manifest)
	return s

# Specific function for Mod Menu behaviour
# modDir is the mod main's directory (form of res://Mod_Folder/ModMain.gd)
# zipDor is the directory of the mod's zip (form of mod_folder/mod.zip)
# hasManifest determines whether the manifest should be used
# manifestDirectory is the directory of the mod.manifest file (form of res://Mod_Folder/mod.manifest)
# hasIcon determines whether the custom mod icon should be used
# iconDir is the directory of the icon.stex file (form of res://Mod_Folder/icon.stex
func __load_file(modDir: String, zipDir: String, hasManifest: bool, manifestDirectory: String, hasIcon: bool, iconDir: String) -> String:
	var f = load("res://ModMenu/globals/load_file.gd").new()
	var s = f.load_file(modDir, zipDir, hasManifest, manifestDirectory, hasIcon, iconDir)
	return s

# Returns 16 lines of text, split by a newline (\n), of mod data in a single string using the mod menu data standard
# Optional split_into_array bool converts the data into an array preemptively
func __get_mod_main(file: String, split_into_array: bool = false) -> String:
	var f = load("res://ModMenu/globals/get_mod_main.gd").new()
	var s = f.get_mod_main(file, split_into_array)
	return s

# Ensures the supplied folder exists
# If folder exists, returns true
# Otherwise, attempts to create it. If it succeeds, returns true, else returns false
func __check_folder_exists(folder: String) -> bool:
	var f = load("res://ModMenu/globals/check_folder_exists.gd")
	var s = f.check_folder_exists(folder)
	return s

# Returns the files in the supplied folder
# If showFolders is set to true, includes folders with the output
func __fetch_folder_files(folder: String, showFolders: bool = false) -> Array:
	var f = load("res://ModMenu/globals/fetch_folder_files.gd")
	var s = f.fetch_folder_files(folder, showFolders)
	return s

# Returns the content from a file as a string
func __get_file_content(file: String) -> String:
	var f = load("res://ModMenu/globals/get_file_content.gd")
	var s = f.get_file_content(file)
	return s

# Supplies the first file in a folder
# If no files exists, returns false
func __get_first_file(folder: String) -> String:
	var f = load("res://ModMenu/globals/get_first_file.gd")
	var s = f.get_first_file(folder)
	return s


