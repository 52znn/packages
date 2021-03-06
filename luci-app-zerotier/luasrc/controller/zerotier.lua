module("luci.controller.zerotier",package.seeall)
function index()
	if not nixio.fs.access("/etc/config/zerotier") then
		return
	end
	entry({"admin","vpn"},firstchild(),"VPN",45).dependent=false
	local e=entry({"admin","vpn","zerotier"},firstchild(),_("ZeroTier"),9)
	e.dependent=false
	e.acl_depends={"luci-app-zerotier"}
	entry({"admin","vpn","zerotier","base"},cbi("zerotier/settings"),_("Base Setting"),1)
	entry({"admin","vpn","zerotier","log"},form("zerotier/info"),_("Interface Info"),2)
	entry({"admin","vpn","zerotier","status"},call("act_status"))
end

function act_status()
	local e={}
	e.running=luci.sys.call("pgrep /usr/bin/zerotier-one >/dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
