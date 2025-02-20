# GTNH Item Tracking + Dashboard
A Lua script for Open Computers that get the amount of items you have in your Applied Energistics Storage over time, and save it into a file (txt), which can be uploaded to Supabase and generate some charts (using Streamlit).

## Pre-requisites

- Open Computers Mod
- Applied Energistics 2
- Access to the server files (if in Multiplayer)

## Setup

OpenComputers components:
- EEPROM (Lua Bios)
- Graphics Card (Tier 3)
- Internet Card
- Central Processing Unit (CPU) (Tier 3)
- Hard Disk Drive (Tier 3) (4MB)
- 2x Memory (Tier 3)
- OpenOS (Operating System)

![alt text](media/computer.png)

Other Components
- Screen
- Charger
- Keyboard
- Adapter


Download it on your OpenComputer:
```bash
wget GitHubLink && installer
```

Run it
```bash
TrackItems
```

TrackItems.lua is gonna get every item that you have in your Applied Energistics 2 Network and write it into a .txt file named "Items.txt" inside your **MinecraftWorld** folder

## Singleplayer
If you are running the World in Singleplayer the Items.txt files is gonna be:

%appdata% -> **YourModpack**\saves\\**YourWorld**\opencomputers\\**HardDriveID**\home\

**HardDriveID**
![Hard Drive ID](media/computer_driveid.png)

## Server
On a Server it's gonna be the same, but you need to have access to the server files.

## Config
You can change the items that you wanna track via Subnet with a Storage Bus linked to a Interface (Main Net) and filter the items that you want it.

## Uploading the Items.txt file to Supabase

### Create the Database
Create your project on https://supabase.com/

Create a Supabase table with the columns:
- item (text)
- quantity (numeric)
- datetime (timestamp)

![alt text](media/supabase_table.png)


After creating the table, go to **API Docs**

![alt text](media/supabase_apidocs.png)


Then clik on **Show Keys** and change the language to **Bash**

![alt text](media/supabase_bash.png)


That will show you your **URL of the Database** and your **APIKEY** to insert and read your table:

![alt text](media/supabase_keys.png)


### Upload Items.txt file
After creating the database and having access to the file, I've created a Bash Script (Linux Script) that gets the Items.txt and send a HTTP Post to my Supabase to insert the items:

Bash Linux (change to your location file, APIKEY and Table URL)
```bash
value=1
for (( ; ; ))
do
    # Location of your Items.txt file
	varname=$(</home/opc/minecraft_server/World/opencomputers/298c8f42-5061-41d3-a6f9-5c42666a3047/home/Items.txt)

	new="[${varname:1}]"
	
    # Change to your APIKEY and Table URL
	curl -X POST 'https://poalrybihpiakfbmjhmn.supabase.co/rest/v1/gtnh-items' \
	-H "apikey: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvYWxyeWJpaHBpYWtmYm1qaG1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAwMTU5MDEsImV4cCI6MjA1NTU5MTkwMX0.5eS8avEC6WMuFb1obzeJr_HUKflKRi8hq91vG82iLuc" \
	-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvYWxyeWJpaHBpYWtmYm1qaG1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAwMTU5MDEsImV4cCI6MjA1NTU5MTkwMX0.5eS8avEC6WMuFb1obzeJr_HUKflKRi8hq91vG82iLuc" \
	-H "Content-Type: application/json" \
	-H "Prefer: return=minimal" \
	-d "$new"
	
	echo "Number of updates: $value"
	
    # Location of your Items.txt file
	truncate -s 0 "/home/opc/minecraft_server/World/opencomputers/298c8f42-5061-41d3-a6f9-5c42666a3047/home/Items.txt"
	
	value=$((value+1))
	sleep 10
done
```

## Creating a Dashboard (with Streamlit)

### Create an App on [streamlit.io ](https://streamlit.io/)

You can build your Dashboard, or you can copy mine from this Repo: https://github.com/ArthurTakita/gtnh_server

**Obs:** You need to have a requirement.txt and **change the python script (.py) to your supabase table name**

![alt text](media/streamlit_github.png)


Then you can choose your repository, and App URL:

![alt text](media/streamlit_repo.png)


Then on Advanced settings you're gonna put your Supabase **URL** and **APIKEY** and deploy:

![alt text](media/streamlit_settings.png)


After that you should be able to get a Dashboard showing all your items like this: https://gtnh-takita.streamlit.app/


