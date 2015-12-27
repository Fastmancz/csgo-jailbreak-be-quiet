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
	name = "JailBreak - Be quiet, please!",
	author = "Fastmancz",
	description = "Be quiet, please!",
	url = "cmgportal.cz"
};

public OnPluginStart()
{
	h_Type = CreateConVar("notify_type", "1", "Notification type: 1 = notifiy muted client when he tries speak, 2 = notifiy all clients when warden speaks");
	LoadTranslations("be_quiet_please.phrases");
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
					PrintCenterText(i, "%t", "notification");
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
			PrintCenterText(client, "%t", "notification");
			hint = false;
		}
	}
}

// When client stops talk
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
