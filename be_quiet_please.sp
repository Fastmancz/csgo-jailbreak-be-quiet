#include <voiceannounce_ex>
#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <warden>
#include <basecomm>

Handle Type = INVALID_HANDLE;

bool hint = true;

public Plugin:myinfo = {
	name = "JailBreak - Be quiet, please!",
	author = "Fastmancz",
	description = "Be quiet, please!",
	url = "cmgportal.cz"
};

public void OnPluginStart();
{
	Type = CreateConVar("jbbqp_notify_type", "1", "Notification type: 1 = notifiy muted client when he tries speak, 2 = notifiy all clients when warden speaks");
}
 GetConVarInt(Type);
//When speak Warden..
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
					if (GetConVarInt(Type) == 2)
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
	if (GetConVarInt(Type) == 1)
	{
		if (hint && GetClientListeningFlags(client) == VOICE_MUTED)
		{
			PrintCenterText(client, "Warden speaks, you have been muted.");
			hint = false;
		}
	}
}
 
//When stop speak Warden..
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
	if (GetConVarInt(Type) == 1)
	{
		if (warden_iswarden(client))
		{
			hint = true;
		}
	}
}
