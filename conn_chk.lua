-- ### conn_chk.lua ###

--[[
 通常系ポートから予備系ポートへの切り替え、または予備系ポートから
通常系ポートへの切戻しを行う関数
]]--

function switch_port(port,link,ipaddr)
	local up_port,down_port

	if link == "down" then
		if port == "lan2"  then
			up_port, down_port = "lan3", "lan2"
		elseif port == "lan3" then
			up_port, down_port = "lan2", "lan3"
		end
	elseif link == "up" then
		if port == "lan2"  then
			up_port, down_port = "lan2", "lan3"
		elseif port == "lan3" then
			up_port, down_port = "lan3", "lan2"
		end
	end

	rtn, str = rt.command("no ip " .. down_port .. " address")
	rtn, str = rt.command("ip " .. up_port .. " address " .. ipaddr)
	rt.syslog("info", "WAN interface has been changed from " .. down_port .. " to " .. up_port)
end


--[[
 変数定義
]]--

ptn = "(LAN[23]): link ([ud][po]w?n?)"
port = nil

ipaddr = os.getenv("IPADDR")
if ipaddr == nil then
	rt.syslog("info", "Undefined variable 'IPADDR'")
	os.exit(0)
end

default_port = os.getenv("DEFAULT_PORT")
if default_port == nil then
	rt.syslog("info", "Undefined variable 'DEFAULT_PORT'")
	os.exit(0)
else
	default_port = string.lower(default_port)
end

auto_back = os.getenv("AUTO_BACK")
if auto_back == nil then
	auto_back = "off"
else
	auto_back = string.lower(auto_back)
end


--[[
 メイン処理
]]--

while (true) do
	rtn, str = rt.syslogwatch(ptn)
	if str ~= nil then
		port,link = string.match(str[1], ptn)
		port = string.lower(port)

		if default_port == port then				-- link状態が変わったポートが通常系かどうか
			if link == "down" then						-- ダウンの場合、予備系に切り替え
				switch_port(port,link,ipaddr)
			end
			if link == "up" and auto_back == "on" then	-- アップかつ自動切戻しが有効の場合、正常系に切り替え
				switch_port(port,link,ipaddr)
			end
		end
		str,port,link = nil,nil,nil
	end
	rt.sleep(1)
end
