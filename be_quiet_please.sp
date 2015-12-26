#include <voiceannounce_ex>
#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <warden>
#include <basecomm>

public Plugin:myinfo = {
	name = "JailBreak - Be quit, please!",
	author = "Fastmancz",
	description = "Be quit, please!",
	url = "cmgportal.cz"
};

bool hint = true;
 
//When speak Warden..
public bool OnClientSpeakingEx(client)
{
    if (warden_iswarden(client))
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if(IsClientInGame(i))
            {
                if (GetClientTeam(i) == CS_TEAM_T)
                {
                    SetClientListeningFlags(i, VOICE_MUTED);
                    if(GetUserAdmin(i) != INVALID_ADMIN_ID)
                    {
                        SetClientListeningFlags(i, VOICE_NORMAL);
                    }
                }
            }
        }
    }

    if (hint && GetClientListeningFlags(client) == VOICE_MUTED)
    {
        PrintCenterText(client, "Warden speaks, you have been muted.");
        hint = false;
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
    if (warden_iswarden(client))
    {
        hint = true;
    }
}
