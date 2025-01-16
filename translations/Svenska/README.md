# Anti-Ping

Anti-Ping-systemet är ett specialiserat filterscript utformat för att övervaka och hantera spelares latens på SA-MP-servrar. Det upptäcker och tar automatiskt bort spelare med överdriven ping för att upprätthålla serverprestanda och spelkvalitet, särskilt viktigt för rollspelsservrar (RP/RPG).

## Språk

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Türkçe: [README](../Turkce/README.md)

## Index

- [Anti-Ping](#anti-ping)
  - [Språk](#språk)
  - [Index](#index)
  - [Funktioner](#funktioner)
  - [Installation](#installation)
  - [Konfiguration](#konfiguration)
  - [Hur det fungerar](#hur-det-fungerar)
  - [Kodstruktur](#kodstruktur)
    - [Spelardata hantering](#spelardata-hantering)
    - [Timer system](#timer-system)
  - [Tekniska detaljer](#tekniska-detaljer)
    - [Prestandaöverväganden](#prestandaöverväganden)
  - [Anpassningsguide](#anpassningsguide)
    - [Ändra varningsmeddelanden](#ändra-varningsmeddelanden)
    - [Justera tidsvärden](#justera-tidsvärden)
  - [Vanliga frågor](#vanliga-frågor)
    - [Varför använda detta system?](#varför-använda-detta-system)
    - [När bör jag justera MAX\_PING-värdet?](#när-bör-jag-justera-max_ping-värdet)
  - [Licens](#licens)
    - [Villkor:](#villkor)

## Funktioner

- Realtidsövervakning av ping
- Automatisk borttagning av spelare med hög latens
- Detaljerade uteslutningsmeddelanden
- Anpassningsbara pinggränser
- Spåring av spelarinformation
- VPN/Proxy användningsvarningar
- Ren och optimerad kodstruktur

## Installation

1. Ladda ner [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx) filen
2. Kopiera filen till din servers `filterscripts` mapp
3. Redigera `server.cfg` filen
4. Lägg till `Anti-Ping` på `filterscripts` raden

**Exempel på konfiguration i server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Om andra filterscripts redan är laddade, lägg till Real-Time efter dem.

## Konfiguration

Systemet använder flera konfigurerbara konstanter som kan justeras efter dina behov:

```pawn
// Main settings
#define MAX_PING                     (500)      // Maximum allowed ping
#define PING_CHECK_INTERVAL          (2*1000)   // Check interval in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Initial check delay
#define KICK_DELAY                   (5*100)    // Kick delay after warning
```

> [!WARNING]
> Att ställa in `MAX_PING` på ett mycket lågt värde kan resultera i onödiga uteslutningar av spelare med stabila men något långsammare anslutningar.

## Hur det fungerar

1. **Spelaranslutning**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Pingövervakning**
   
   Systemet kontrollerar regelbundet varje spelares ping:
   ```pawn
   public Timer_CheckPlayerPing(playerid) {
       if(!IsPlayerConnected(playerid))
           return false;
       
       if(!APF_PlayerData[playerid][Player_HasExceededPing] && 
          GetPlayerPing(playerid) >= MAX_PING) {
           // Display warning and schedule kick
           Show_PingWarning(playerid);
           SetTimerEx("Timer_KickPlayer", KICK_DELAY, false, "i", playerid);
       }

       return true;
   }
   ```

3. **Varningssystem**
   
   Innan sparken får spelaren ett detaljerat meddelande:
   ```pawn
   stock Show_PingWarning(playerid) {
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
   }
   ```

## Kodstruktur

Systemet använder en modulär och organiserad struktur:

### Spelardata hantering

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Timer system

- `Timer_CheckPlayerPing`: Regelbunden pingövervakning
- `Timer_KickPlayer`: Fördröjd uteslutning
- `Timer_StartPingMonitor`: Startar övervakning efter spawn

## Tekniska detaljer

### Prestandaöverväganden

- Effektiv minnesanvändning genom organiserad datastruktur
- Optimerad användning av timers för att minimera serverbelastning
- Korrekt rensning av timers vid spelardisconnect

> [!NOTE]
> Systemet är utformat för att ha minimal påverkan på serverprestandan, även med många anslutna spelare.

## Anpassningsguide

### Ändra varningsmeddelanden

Du kan anpassa varningsdialogen genom att redigera `Show_PingWarning` funktionen:
```pawn
stock Show_PingWarning(playerid) {
    // Customize your message here
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Justera tidsvärden

Modifiera konstanterna i början av filen:
```pawn
#define MAX_PING                     (ditt_värde)
#define PING_CHECK_INTERVAL          (ditt_värde)
```

## Vanliga frågor

### Varför använda detta system?

- Upprätthåller serverprestanda
- Säkerställer rättvist gameplay
- Särskilt viktigt för rollspelsscenarier
- Förhindrar lag-relaterade exploits

### När bör jag justera MAX_PING-värdet?

- Lägre för tävlingsinriktade servrar (300-400ms)
- Högre för internationella servrar (500-600ms)
- Överväg din målgrupps geografiska placering

> [!IMPORTANT]
> Det rekommenderas att testa olika `MAX_PING`-värden i en kontrollerad miljö innan implementering i produktion för att hitta den bästa balansen för din server.

## Licens

Detta Filterscript är skyddat under Apache License 2.0, som tillåter:

- ✔️ Kommersiell och privat användning
- ✔️ Källkodsmodifiering
- ✔️ Koddistribution
- ✔️ Patentbeviljande

### Villkor:

- Behåll upphovsrättsmeddelande
- Dokumentera betydande ändringar
- Inkludera Apache License 2.0 kopia

För mer licensinformation: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - All rights reserved**