/*
 * Anti-Ping Filterscript for SA-MP (San Andreas Multiplayer)
 * Copyright (c) Calasans
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#define FILTERSCRIPT

#include <a_samp>

#define MAX_PING                     (500)
#define PING_CHECK_INTERVAL          (2*1000)
#define PING_CHECK_START_DELAY       (4*1000)
#define KICK_DELAY                   (5*100)
#define DIALOG_ID_PING_WARNING       (999)

#define COLOR_RED                    0xEC3737FF
#define COLOR_GREY                   "{B4B5B7}"
#define COLOR_WHITE                  "{FFFFFF}"

enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];

stock Get_PlayerName(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    return name;
}

stock Show_PingWarning(playerid) {
    if(!IsPlayerConnected(playerid))
        return false;

    new player_ip[16],
        player_version[10],
        dialog_string[512];
        
    GetPlayerIp(playerid, player_ip, sizeof(player_ip));
    GetPlayerVersion(playerid, player_version, sizeof(player_version));
    
    format(dialog_string, sizeof(dialog_string), 
        "%sYou have been kicked from the server for exceeding the maximum\n"\
        "allowed ping (%s%d ms%s).\n\n"\
        "%sInformation:\n"\
        "Name: %s%s\n"\
        "%sIP: %s%s\n"\
        "%sVersion: %s%s\n"\
        "%sPing: %s%d\n\n"\
        "%sIf you are using a VPN/Proxy, we recommend disabling it\n"\
        "as you may be kicked again for high ping.",
        COLOR_GREY, COLOR_WHITE, MAX_PING, COLOR_GREY,
        COLOR_GREY, COLOR_WHITE, Get_PlayerName(playerid),
        COLOR_GREY, COLOR_WHITE, player_ip,
        COLOR_GREY, COLOR_WHITE, player_version,
        COLOR_GREY, COLOR_WHITE, GetPlayerPing(playerid),
        COLOR_GREY
    );
    
    return ShowPlayerDialog(playerid, DIALOG_ID_PING_WARNING, DIALOG_STYLE_MSGBOX, "High Ping Warning", dialog_string, "Understood", "");
}

forward Timer_CheckPlayerPing(playerid);
public Timer_CheckPlayerPing(playerid) {
    if(!IsPlayerConnected(playerid))
        return false;
    
    if(!APF_PlayerData[playerid][Player_HasExceededPing] && GetPlayerPing(playerid) >= MAX_PING) {
        new message[144];
        format(message, sizeof(message), "[Anti-Lag]: %s was kicked for exceeding maximum ping limit (%d ms).", Get_PlayerName(playerid), MAX_PING);
        SendClientMessageToAll(COLOR_RED, message);
        
        Show_PingWarning(playerid);
        APF_PlayerData[playerid][Player_HasExceededPing] = true;
        SetTimerEx("Timer_KickPlayer", KICK_DELAY, false, "i", playerid);
    }

    return true;
}

forward Timer_KickPlayer(playerid);
public Timer_KickPlayer(playerid)
    return Kick(playerid);

forward Timer_StartPingMonitor(playerid);
public Timer_StartPingMonitor(playerid) {
    APF_PlayerData[playerid][Timer_PingCheck] = SetTimerEx("Timer_CheckPlayerPing", PING_CHECK_INTERVAL, true, "i", playerid);
    return true;
}

public OnFilterScriptInit() {
    print(" ");
    print("__________________________________________________________________");
    print("||==============================================================||");
    print("||                                                              ||");
    print("||                    Anti-Ping Filterscript                    ||");
    print("||                                                              ||");
    print("|| Developer: Calasans                                          ||");
    print("|| Instagram: ocalasans                                         ||");
    print("|| Discord: ocalasans                                           ||");
    print("||                                                              ||");
    print("||==============================================================||");
    print("__________________________________________________________________");
    print(" ");

    return true;
}

public OnFilterScriptExit() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(APF_PlayerData[i][Timer_PingCheck])
            KillTimer(APF_PlayerData[i][Timer_PingCheck]);
    }

    return true;
}

public OnPlayerConnect(playerid) {
    APF_PlayerData[playerid][Player_HasExceededPing] = false;
    APF_PlayerData[playerid][Timer_PingCheck] = 0;

    return true;
}

public OnPlayerDisconnect(playerid, reason) {
    if(APF_PlayerData[playerid][Timer_PingCheck]) {
        KillTimer(APF_PlayerData[playerid][Timer_PingCheck]);
        APF_PlayerData[playerid][Timer_PingCheck] = 0;
    }

    return true;
}

public OnPlayerSpawn(playerid) {
    SetTimerEx("Timer_StartPingMonitor", PING_CHECK_START_DELAY, false, "i", playerid);

    return false;
}
