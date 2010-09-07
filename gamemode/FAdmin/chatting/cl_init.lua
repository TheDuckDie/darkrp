usermessage.Hook("FAdmin_ReceivePM", function(um)
	local FromPly = um:ReadEntity()
	local Text = um:ReadString()
	
	chat.AddText(Color(255,0,0,255), "PM ", team.GetColor(FromPly:Team()), FromPly:Nick()..": ", Color(255, 255, 255, 255), Text)
end)

usermessage.Hook("FAdmin_ReceiveAdminMessage", function(um)
	local FromPly = um:ReadEntity()
	local Text = um:ReadString()
	
	chat.AddText(Color(255,0,0,255), "Admin help! ", team.GetColor(FromPly:Team()), FromPly:Nick()..": ", Color(255, 255, 255, 255), Text)
end)

hook.Add("FAdmin_PluginsLoaded", "Chatting", function()
	FAdmin.Commands.AddCommand("PM", nil, "<Player>", "<text>")
	FAdmin.Commands.AddCommand("adminhelp", nil, "<text>")
	
end)