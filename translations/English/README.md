# Anti-Ping

The Anti-Ping system is a specialized filterscript designed to monitor and manage player latency on SA-MP servers. It automatically detects and removes players with excessive ping to maintain server performance and gameplay quality, particularly important for roleplay servers (RP/RPG).

## Languages

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Index

- [Anti-Ping](#anti-ping)
  - [Languages](#languages)
  - [Index](#index)
  - [Features](#features)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [How It Works](#how-it-works)
  - [Code Structure](#code-structure)
    - [Player Data Management](#player-data-management)
    - [Timer System](#timer-system)
  - [Technical Details](#technical-details)
    - [Performance Considerations](#performance-considerations)
  - [Customization Guide](#customization-guide)
    - [Modifying Warning Messages](#modifying-warning-messages)
    - [Adjusting Time Values](#adjusting-time-values)
  - [Frequently Asked Questions](#frequently-asked-questions)
    - [Why use this system?](#why-use-this-system)
    - [When should I adjust the MAX\_PING value?](#when-should-i-adjust-the-max_ping-value)
  - [License](#license)
    - [Conditions:](#conditions)

## Features

- Anti-Ping ping monitoring
- Automatic removal of high-latency players
- Detailed kick notifications
- Customizable ping limits
- Player information tracking
- VPN/Proxy usage warnings
- Clean and optimized code structure

## Installation

1. Download the [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx) file
2. Copy the file to your server's `filterscripts` folder
3. Edit the `server.cfg` file
4. Add `Anti-Ping` to the `filterscripts` line

**Example configuration in server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> If other filterscripts are already loaded, add Anti-Ping after them.

## Configuration

The system uses several configurable constants that can be adjusted according to your needs:

```pawn
// Main settings
#define MAX_PING                     (500)      // Maximum allowed ping
#define PING_CHECK_INTERVAL          (2*1000)   // Check interval in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Initial check delay
#define KICK_DELAY                   (5*100)    // Kick delay after warning
```

> [!WARNING]
> Setting `MAX_PING` to a very low value may result in unnecessary kicks of players with stable but slightly slower connections.

## How It Works

1. **Player Connection**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Ping Monitoring**
   
   The system regularly checks each player's ping:
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

3. **Warning System**
   
   Before the kick, the player receives a detailed message:
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

## Code Structure

The system uses a modular and organized structure:

### Player Data Management

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Timer System

- `Timer_CheckPlayerPing`: Regular ping monitoring
- `Timer_KickPlayer`: Delayed kick execution
- `Timer_StartPingMonitor`: Starts monitoring after spawn

## Technical Details

### Performance Considerations

- Efficient memory usage through organized data structure
- Optimized use of timers to minimize server load
- Proper cleanup of timers on player disconnect

> [!NOTE]
> The system is designed to have minimal impact on server performance, even with many connected players.

## Customization Guide

### Modifying Warning Messages

You can customize the warning dialog by editing the `Show_PingWarning` function:
```pawn
stock Show_PingWarning(playerid) {
    // Customize your message here
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Adjusting Time Values

Modify the constants at the beginning of the file:
```pawn
#define MAX_PING                     (your_value)
#define PING_CHECK_INTERVAL          (your_value)
```

## Frequently Asked Questions

### Why use this system?

- Maintains server performance
- Ensures fair gameplay
- Particularly important for roleplay scenarios
- Prevents lag-related exploits

### When should I adjust the MAX_PING value?

- Lower for competitive servers (300-400ms)
- Higher for international servers (500-600ms)
- Consider your target audience's location

> [!IMPORTANT]
> It is recommended to test different `MAX_PING` values in a controlled environment before implementing in production to find the best balance for your server.

## License

This Filterscript is protected under the Apache License 2.0, which allows:

- ✔️ Commercial and private use
- ✔️ Source code modification
- ✔️ Code distribution
- ✔️ Patent grant

### Conditions:

- Maintain copyright notice
- Document significant changes
- Include Apache License 2.0 copy

For more license details: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - All rights reserved**