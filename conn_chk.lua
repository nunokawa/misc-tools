-- ### conn_chk.lua ###

--[[
 �ʏ�n�|�[�g����\���n�|�[�g�ւ̐؂�ւ��A�܂��͗\���n�|�[�g����
�ʏ�n�|�[�g�ւ̐ؖ߂����s���֐�
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
 �ϐ���`
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
 ���C������
]]--

while (true) do
	rtn, str = rt.syslogwatch(ptn)
	if str ~= nil then
		port,link = string.match(str[1], ptn)
		port = string.lower(port)

		if default_port == port then				-- link��Ԃ��ς�����|�[�g���ʏ�n���ǂ���
			if link == "down" then						-- �_�E���̏ꍇ�A�\���n�ɐ؂�ւ�
				switch_port(port,link,ipaddr)
			end
			if link == "up" and auto_back == "on" then	-- �A�b�v�������ؖ߂����L���̏ꍇ�A����n�ɐ؂�ւ�
				switch_port(port,link,ipaddr)
			end
		end
		str,port,link = nil,nil,nil
	end
	rt.sleep(1)
end
