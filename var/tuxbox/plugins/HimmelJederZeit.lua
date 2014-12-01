--- configure HimmelJederzeit
 
config="/var/tuxbox/config/jederzeit/himmelJederzeit.cfg"
cfgtemplate="/var/tuxbox/config/jederzeit/himmelJederzeit.cfg"


on="ein"
off="aus"
short="kurz"
middle="mittel"
long="lang"

C={}
C["StoragePeriod"]=0
C["timeSpan"]=""
C["Adventure"]=1
C["Action"]=1
C["Drama"]=1
C["Family"]=1
C["Horror"]=0
C["Comedy"]=1
C["SciFi"]=1
C["Thriller"]=1
C["Western"]=1

function num2value(a)
	if (tonumber(a) == 0) then return short end
	if (tonumber(a) == 1) then return middle end
	return long
end

function value2num(a)
	if (a == short) then return 0 end
	if (a == middle) then return 1 end
	return 2
end

function num2onoff(a)
	if (tonumber(a) == 0) then return off end
	return on
end

function onoff2num(a)
	if (a == on) then return 1 end
	return 0
end

changed=0

function set_string(k, v) C[k]=v changed=1 end
function set_bool(k, v) C[k]=onoff2num(v) changed=1 end
function set_choice(k, v) C[k]=value2num(v) changed=1 end

function load()
	local f = io.open(config, "r")
	if f then
		for line in f:lines() do
			local key, val = line:match("^([^=#]+)=([^\n]*)")
			if (key) then
				if (val == nil) then
					val=""
				end
				C[key]=val
			end
		end
		f:close()
	end
end

function save()
	local h = hintbox.new{caption="Einstellungen werden gespeichert", text="Bitte warten ..."}
	h:paint()
	if (changed) then
		local f = io.open(config, "w")
		if f then
			local key, val
			for key, val in pairs(C) do
				f:write(key .. "=" .. val .. "\n")
			end
			f:close()
		end
		changed = 0
	end
	h:hide()
end

function init_hj()
	os.execute("cd /var/tuxbox/plugins;./himmelJederzeit.sh initGUI");
	os.execute("cd /var/tuxbox/plugins;./himmelJederzeit.sh full");
end

function act_hj()
	os.execute("cd /var/tuxbox/plugins;./himmelJederzeit.sh full")
end

function rem_hj()
	messagebox.exec{title="HimmelJederzeit", text="to be done....", buttons={ "ok" } }
	---os.execute("cd /var/tuxbox/plugins;./himmelJederzeit.sh deleteFiles")
end

function pr_auto()
	os.execute("/var/tuxbox/plugins/pr-auto-timer &")
end

function handle_key(a)
	if (changed == 0) then return MENU_RETURN["EXIT"] end
	local res = messagebox.exec{title="Änderungen verwerfen?", text="Sollen die Änderungen verworfen werden?", buttons={ "yes", "no" } }
	if (res == "yes") then return MENU_RETURN["EXIT"] end
	return MENU_RETURN["REPAINT"]
end

load()

local m = menu.new{name="HimmelJederzeit", icon="settings"}
m:addKey{directkey=RC["home"], id="home", action="handle_key"}
m:addItem{type="back"}
m:addItem{type="separator"}
m:addItem{type="forwarder", name="HimmelJederzeit initialisieren", action="init_hj", icon="blau", directkey=RC["blue"]}
m:addItem{type="forwarder", name="HimmelJederzeit aktualisieren", action="act_hj", icon="gruen", directkey=RC["green"]}
m:addItem{type="forwarder", name="HimmelJederzeit aufräumen", action="rem_hj", icon="gelb", directkey=RC["yellow"]}
m:addItem{type="forwarder", name="HimmelJederzeit Timer setzen", action="pr_auto", icon="epg", directkey=RC["epg"]}
m:addItem{type="separator"}
m:addItem{type="forwarder", name="Einstellungen Speichern", action="save", icon="rot", directkey=RC["red"]}
m:addItem{type="separator"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Adventure", value=num2onoff(C["Adventure"]), directkey=RC["1"], name="Adventure"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Action",    value=num2onoff(C["Action"]),    directkey=RC["2"], name="Action"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Drama",     value=num2onoff(C["Drama"]),     directkey=RC["3"], name="Drama"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Family",    value=num2onoff(C["Family"]),    directkey=RC["4"], name="Family"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Horror",    value=num2onoff(C["Horror"]),    directkey=RC["5"], name="Horror"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Comedy",    value=num2onoff(C["Comedy"]),    directkey=RC["6"], name="Comedy"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="SciFi",     value=num2onoff(C["SciFi"]),     directkey=RC["7"], name="SciFi"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Thriller",  value=num2onoff(C["Thriller"]),  directkey=RC["8"], name="Thriller"}
m:addItem{type="chooser", action="set_bool", options={ on, off }, id="Western",   value=num2onoff(C["Western"]),   directkey=RC["9"], name="Western"}
m:addItem{type="separator"}
m:addItem{type="chooser", action="set_choice", options={ short, middle, long }, id="StoragePeriod", value=num2value(C["StoragePeriod"]), directkey=RC["0"], name="Speicherdauer"}
m:addItem{type="stringinput", action="set_string", id="timeSpan",      name="Zeitraum (von-bis)",      value=C["timeSpan"],      valid_chars="0123456789:-"}
m:addItem{type="separator"}
m:exec()

