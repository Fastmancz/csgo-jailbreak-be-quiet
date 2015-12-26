#include <voiceannounce_ex>
#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <warden>
#include <basecomm>

Handle h_Type = INVALID_HANDLE;

bool hint = true;

public Plugin:myinfo = {
	name = "JailBreak - Be quit, please!",
	author = "Fastmancz",
	description = "Be quit, please!",
	url = "cmgportal.cz"
};

public void OnPluginStart()
{
	h_Type = CreateConVar("jbbqp_notify_type", "1", "Notification type: 1 = notifiy muted client when he tries speak, 2 = notifiy all clients when warden speaks");
}

//When Warden speaks or muted client wants to speak
public bool OnClientSpeakingEx(client)
{
    if (warden_iswarden(client))
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if (IsClientInGame(i))
            {
                if (GetClientTeam(i) == CS_TEAM_T)
                {
					if (GetConVarInt(h_Type) == 2)
						PrintCenterText(i, "Warden speaks, you have been muted.");
				
                    SetClientListeningFlags(i, VOICE_MUTED);
                    if (GetUserAdmin(i) != INVALID_ADMIN_ID)
                    {
                        SetClientListeningFlags(i, VOICE_NORMAL);
                    }
                }
            }
        }
    }
	if (GetConVarInt(h_Type) == 1)
	{
		if (hint && GetClientListeningFlags(client) == VOICE_MUTED)
		{
			PrintCenterText(client, "Warden speaks, you have been muted.");
			hint = false;
		}
	}
}
 
// When client stops ta
public OnClientSpeakingEnd(client)
{  
    for (int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i))
        {
            if (GetClientTeam(i) == CS_TEAM_T && !BaseComm_IsClientMuted(client))
            {
                SetClientListeningFlags(i, VOICE_NORMAL);
            }
        }
    }
	if (GetConVarInt(h_Type) == 1)
	{
		if (warden_iswarden(client))
		{
			hint = true;
		}
	}
}
