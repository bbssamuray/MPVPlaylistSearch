local mp = require "mp"
local utils = require "mp.utils"

package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"})..package.path
local input = require "user-input-module"


local function compare(str, keyword)
	return str:lower():find(keyword:lower())
end


local function searchPlaylist(userstr,err)

    if err then
        return
    end

    print("Searching "..userstr.."...")
    playlist = mp.get_property("playlist")
    local counter = 1
    local files = {}
    for x,i in ipairs(utils.parse_json(playlist)) do
	    if compare(i["filename"],userstr)
	    then
	    	print(counter, " - " ,i["filename"],i["id"]," ",x)
		files[counter] = i
		counter = counter + 1
	    end
    end

    if counter < 2 then
	    print("No files were found!")
    elseif counter == 2 then
	    --mp.commandv("playlist-play-index",files[1]["id"]-2)
        mp.set_property("playlist-pos",files[1]["id"]-2)
    else
	    print("Enter the id of the song you want:")
    	    input.get_user_input(function(userstr,err)
		    if userstr then
                number = tonumber(userstr)
                if number and number < counter and 0 < number then
                    print("Selected "..number)
                    --mp.commandv("playlist-play-index",files[number]["id"])
			        mp.set_property("playlist-pos",files[number]["id"]-2)
                else
                    print("Not a valid number!")
                end
            end
	    end,{
		request_text = "Enter the id of the song you want:",
		replace = true
    		})
    end 
end


mp.add_key_binding("Ctrl+f", "search-playlist", function()
    print("Enter file name to search in the playlist for:")
    input.get_user_input(searchPlaylist, {
	request_text = "File to search for:",
	replace = true
    })
end)

