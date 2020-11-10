
my_OS = "windows"
--my_OS = "Linux"


subtitles_uri = nil -- "file:///D:/films/subtitles.srt"
output_dialogbox = false -- true or false
output_osd = true
osd_position = "top" -- "top-left", "top-right", "left", ...
charset = "Windows-1250" -- nil or "UTF-8", "ISO-8859-2", ...
filename_extension = "srt" -- "eng.srt", "srt-vlc", ...
execute_commands = true -- true/false; [SKIP], [MUTE]
s = nil
data = nil
reader = nil
dlg = nil
list = nil

xml = {}

srt_pattern = "(%d%d):(%d%d):(%d%d),(%d%d%d) %-%-> (%d%d):(%d%d):(%d%d),(%d%d%d).-\n(.-)\n\n"

file_alpha = { a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10, k = 11, l = 12, m = 13, n = 14, o = 15, p = 16, q = 17,
		r = 18, s = 19, t = 20, u = 21, v = 22, w = 23, x = 24, y = 25, z = 26 }

is_dic_loaded = false
dic_root = nil

is_search_complt = true
found = false;
readActive = false
i = 1
reachedElement = false
usage_tb = {}
finished_look = false

words = {}
lwords = {}
stopList = nil

PROPER_SIZE = 33

function descriptor()
    return { title = "SubDics" ;
             version = "1.0" ;
             author = "Aditya Sathe" ;
             capabilities = {"playing-listener"} }
end

function activate()
    	
	if not vlc.input.is_playing() then
		deactivate()
	end
	
	dlg = vlc.dialog("Sample")

	button_search = dlg:add_button("Search", search_button, 1, 4, 4, 1)
	list = dlg:add_dropdown(1, 1, 4, 1)
	meaning = dlg:add_list(1, 2, 4, 2)
	
	dlg:hide()

	
	Load_subtitles()
	
	load_dics()
	is_dic_loaded = true
	vlc.msg.info("[**] Extension Has been Started")
	vlc.osd.message("SubDics is ready", 1,"top-right", 2500000)

	stopList = Set {"a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"}

	
end


function search_dict(el)
	if finished_look then return end
	if not el then usage_tb[i] = "_NIL" return end
  for _,n in ipairs(el.kids) do
	
	if n.type=='element' then
		if found then
			if n.attr['column'] == '1' then
				found = false;
				readActive = true
			end
		elseif n.name == 'value' then
			if n.attr['column'] == '0' then
				reachedElement = true;
			end
		end
		search_dict(n)
		if finished_look then --print('returning from for')
		return end
	elseif n.type=='text' then 
		if reachedElement then
			
			ch = strcmp(n.value)
			if ch == 0 then
				
				found = true;
				--print('[*****]'..n.value)
			else
				
			end
		
			reachedElement = false

		elseif readActive then
			
			usage_tb[i] = n.value;
			readActive = false
			
			finished_look = true
			--print('[$] '..n.value)

			return		
		end
	end
  end
end


function strcmp(val)
	if val==nil then return -1 end
	
	if val == "#NAME?" then return -1 end
	if lwords[i] == val:lower() then 
		return 0 
	end
	--print(val:lower()..", "..lwords[i])
	
end
	


function playing_changed()
	if(vlc.playlist.status() == 'playing') then
		--vlc.msg.info("[--] Playing");
		dlg:hide()	
		clear_ds()
	elseif(vlc.playlist.status() == 'paused') then
		--vlc.msg.info("[--] Paused");
		pause_action();
		
	end
end

function pause_action()

	local input = vlc.object.input();
   	if input then
      		local curtime=vlc.var.get(input, "time");     
		
		search_line(curtime);
   	end
end


function search_button()
	if is_search_complt == false or is_dic_loaded == false then return end

	selection = list:get_text()
    	if (not selection) then return 1 end
	
	meaning:clear()

	for index,w in ipairs(lwords)do
		if w == selection then	
        		--vlc.msg.info("Asked to Search "..w.." "..index)
			if usage_tb[index] == nil or usage_tb[index] == "_NIL" or usage_tb[index] == "" then 
				meaning:add_value("Oops! No results found!!", 1)
				return 
			end
			--vlc.msg.info("Asked to Search "..w.." "..index.." "..usage_tb[index])
			--[[local nl = round(#usage_tb[index]/PROPER_SIZE)+1
			for m_in= 0,nl,1 do
				meaning:add_value(usage_tb[index]:sub(m_in*PROPER_SIZE+1, (m_in+1)*PROPER_SIZE), m_in)
			end]]

			--print(usage_tb[index])
			sentence = ""
			m_in = 0
			for x in string.gmatch(usage_tb[index], '([^%s]+)') do
				
				if (#sentence + #x) > PROPER_SIZE then
					meaning:add_value(sentence, m_in)
					sentence = ""
					m_in = m_in + 1
				end
				sentence = sentence..x.." "
			end
			meaning:add_value(sentence, m_in)
			dlg:update()
			break
		end
	end
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end



function media_path(extension)
	local media_uri = vlc.input.item():uri()
	media_uri = string.gsub(media_uri, "^(.*)%..-$","%1") .. "." .. extension
	vlc.msg.info(media_uri)
	return media_uri
end


function Load_subtitles()
	if subtitles_uri==nil then subtitles_uri=media_path(filename_extension) end
-- read file
	
	s = vlc.stream(subtitles_uri)
	if s==nil then return false end
	data = s:read(500000)
	data = string.gsub( data, "\r", "")
	-- UTF-8 BOM detection
	if string.char(0xEF,0xBB,0xBF)==string.sub(data,1,3) then charset=nil end
end



function search_line(curtime)
-- parse data
	
	for h1, m1, s1, ms1, h2, m2, s2, ms2, text in string.gmatch(data, srt_pattern) do
		if text=="" then text=" " end
		if charset~=nil then text=vlc.strings.from_charset(charset, text) end
		--table.insert(subtitles,{format_time(h1, m1, s1, ms1), format_time(h2, m2, s2, ms2), text})
		--vlc.msg.info(format_time(h1, m1, s1, ms1)..format_time(h2, m2, s2, ms2)..text.."");
		if (format_time(h1, m1, s1, ms1) <= curtime) and (format_time(h2, m2, s2, ms2) >= curtime) then	
			vlc.msg.info(format_time(h1, m1, s1, ms1).." "..format_time(h2, m2, s2, ms2).." "..text)
			control_search_n_dlg(text)
			break
		end
	end
end


function control_search_n_dlg(text)
	
	local indx = 0
	for x in string.gmatch(text, '([^,^!^?^(^)^%.^%s]+)') do
		x = string.gsub(x, '<i>','')
		x = string.gsub(x, '</i>','')
		
		if not(x == "" or x ==nil) then 
			local temp = x:lower()
			if not stopList[temp] and not x:find("%d") and x:find("%w") then
				words[indx+1] = temp--string.upper(x:sub(1,1))..x:sub(2, #x)
				lwords[indx+1] = temp--string.lower(x:sub(1,1))..x:sub(2, #x)
				vlc.msg.info(indx.."] "..string.upper(x:sub(1,1))..x:sub(2, #x))
		
				indx = indx + 1
			end
		end
	end

	table.sort(words)
	table.sort(lwords)
	
	for index,w in ipairs(words) do
		list:add_value(w, index)
	end

	dlg:update()
	dlg:show()
	i = 1
	for indx, w in ipairs(lwords) do
		--print("checking "..w..".")
		local file_i = file_alpha[w:sub(1,1)]
		search_dict(xml[file_i])
		--print("searched completed for "..w.." with "..file_i.." and i= "..i)
		i = i+1
		finished_look = false
	end
	--search_dict(dic_root)

	is_search_complt = true
	--print('search complete')
	
end


function format_time(h,m,s,ms) -- time to seconds
	return tonumber(h)*3600+tonumber(m)*60+tonumber(s)+tonumber("."..ms)
end

function clear_ds()
	for k in pairs (words) do
    		words[k] = ""
	end
	for k in pairs (lwords) do
    		lwords[k] = ""
	end
	for k in pairs (usage_tb) do
    		usage_tb[k] = ""
	end
	i = 1
	meaning:clear()
	list:clear()
	is_search_complt = false
	finished_look = false
end
	

function deactivate()
end

function close()
	
    	dlg:hide()	
	clear_ds()

end

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end



function load_dics()
	local SLAXML = require 'slaxdom'
	
	
	for key,value in pairs(file_alpha) do 
		vlc.osd.message("SubDics: Please wait", 1,"top-right", 800000)
		local tempf = nil
		--print(key.." = "..value)
		if my_OS == "windows" then
			tempf = vlc.stream("file:///C:/Program%20Files%20(x86)/VideoLAN/VLC/lua/extensions/db/dic_"..key..".xml"):read(50000000)
		elseif my_OS == "Linux" then
			tempf = vlc.stream("file:///usr/share/vlc/lua/extensions/db/dic_"..key..".xml"):read(50000000)
		end
		xml[value] = SLAXML:dom(tempf).root
		--if not xml[value] then print("////////////////Root uninitialised"..value) end
	end
end