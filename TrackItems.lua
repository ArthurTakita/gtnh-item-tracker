local internet = require("internet")
local component = require("component")


local me
if component.isAvailable("me_controller") then
    me = component.me_controller
elseif component.isAvailable("me_interface") then
    me = component.me_interface
else
    print("You need to connect the adapter to either a me controller or a me interface")
    os.exit()
end

-- Function to get Real World time
function webclock()

	local handle = internet.request("http://www.rootdir.org/webclock.php?tz=America/Bahia&locale=pt_BR.UTF-8")
	local result = ""
    
	for chunk in handle do result = chunk end

	local datetime = os.time({year=result:sub(1,4), month=result:sub(6,7), day=result:sub(9,10), hour=result:sub(12,13), min=result:sub(15,16), sec=result:sub(18,19)})
	
	return datetime

end


function time_format(datetime)
    local time_format = os.date("%Y-%m-%d %H:%M:%S", datetime)
    return time_format
end


-- Function to get the items from AE2
-- Got this function from PoroCoco: https://github.com/PoroCoco/myaenetwork/blob/main/web.lua
function AE_get_items(datetime)
    local string = ""
    local isModpackGTNH, storedItems = pcall(me.allItems) --tries the allItems method only available on the GTNH modpack.

    local time_format = time_format(datetime)

    local count = 1

    if isModpackGTNH then
        for item in storedItems do
            if type(item) == 'table' then
                string = string .. "," .. '{"item":"' .. item['label'] .. '","quantity":"' .. item["size"] .. '","datetime":"'.. time_format .. '"}' .. "\n"
		        count = count + 1
            end
        end
        return string
    else
        for k,v in pairs(me.getItemsInNetwork()) do
            if type(v) == 'table' then
		        string = string .. "," .. '{"item":"' .. item['label'] .. '","quantity":"' .. item["size"] .. '","datetime":"'.. time_format .. '"}' .. "\n"
		count = count + 1
            end
        end
        return string
    end
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end


i = 1
check_time = 1

datetime = webclock()

repeat
	
    -- Update the internal timer with the Webclock time after some runs
	if check_time >= 5 then 
		print("Updating Web Time")
		datetime = webclock()
		check_time = 1
	end

	local file = io.open("Items.txt", "a")
	
	local items = AE_get_items(datetime)
	
	file:write(items)

	file:close()

	print("Getting Items! "..time_format(datetime))

    -- Wait 15 minutes for another update
	sleep(900)

	datetime = datetime + 900

	check_time = check_time + 1

until i > 5





