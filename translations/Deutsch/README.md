# Anti-Ping

Das Anti-Ping System ist ein spezialisiertes Filterscript, das die Spielerlatenz auf SA-MP-Servern überwacht und verwaltet. Es erkennt und entfernt automatisch Spieler mit übermäßigem Ping, um die Serverleistung und Spielqualität aufrechtzuerhalten, was besonders wichtig für Rollenspiel-Server (RP/RPG) ist.

## Sprachen

- Português: [README](../../)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Inhaltsverzeichnis

- [Anti-Ping](#anti-ping)
  - [Sprachen](#sprachen)
  - [Inhaltsverzeichnis](#inhaltsverzeichnis)
  - [Funktionen](#funktionen)
  - [Installation](#installation)
  - [Konfiguration](#konfiguration)
  - [Funktionsweise](#funktionsweise)
  - [Code-Struktur](#code-struktur)
    - [Spielerdatenverwaltung](#spielerdatenverwaltung)
    - [Timer-System](#timer-system)
  - [Technische Details](#technische-details)
    - [Leistungsüberlegungen](#leistungsüberlegungen)
  - [Anpassungsleitfaden](#anpassungsleitfaden)
    - [Warnmeldungen anpassen](#warnmeldungen-anpassen)
    - [Zeitwerte anpassen](#zeitwerte-anpassen)
  - [Häufig gestellte Fragen](#häufig-gestellte-fragen)
    - [Warum dieses System verwenden?](#warum-dieses-system-verwenden)
    - [Wann sollte ich den MAX\_PING-Wert anpassen?](#wann-sollte-ich-den-max_ping-wert-anpassen)
  - [Lizenz](#lizenz)
    - [Bedingungen:](#bedingungen)

## Funktionen

- Echtzeit-Ping-Überwachung
- Automatische Entfernung von Spielern mit hoher Latenz
- Detaillierte Kick-Benachrichtigungen
- Anpassbare Ping-Limits
- Spielerinformationsverfolgung
- VPN/Proxy-Nutzungswarnungen
- Saubere und optimierte Code-Struktur

## Installation

1. Laden Sie die [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx) Datei herunter
2. Kopieren Sie die Datei in Ihren Server-`filterscripts` Ordner
3. Bearbeiten Sie die `server.cfg` Datei
4. Fügen Sie `Anti-Ping` zur `filterscripts` Zeile hinzu

**Beispielkonfiguration in server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Wenn andere Filterscripts bereits geladen sind, fügen Sie Real-Time nach diesen hinzu.

## Konfiguration

Das System verwendet mehrere konfigurierbare Konstanten, die nach Ihren Bedürfnissen angepasst werden können:

```pawn
// Haupteinstellungen
#define MAX_PING                     (500)      // Maximal erlaubter Ping
#define PING_CHECK_INTERVAL          (2*1000)   // Prüfintervall in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Anfängliche Prüfverzögerung
#define KICK_DELAY                   (5*100)    // Kick-Verzögerung nach Warnung
```

> [!WARNING]
> Wenn Sie `MAX_PING` auf einen sehr niedrigen Wert setzen, kann dies zu unnötigen Kicks von Spielern mit stabilen, aber etwas langsameren Verbindungen führen.

## Funktionsweise

1. **Spielerverbindung**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Spielerdaten zurücksetzen
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Ping-Überwachung**
   
   Das System überprüft regelmäßig den Ping jedes Spielers:
   ```pawn
   public Timer_CheckPlayerPing(playerid) {
       if(!IsPlayerConnected(playerid))
           return false;
       
       if(!APF_PlayerData[playerid][Player_HasExceededPing] && 
          GetPlayerPing(playerid) >= MAX_PING) {
           // Warnung anzeigen und Kick planen
           Show_PingWarning(playerid);
           SetTimerEx("Timer_KickPlayer", KICK_DELAY, false, "i", playerid);
       }

       return true;
   }
   ```

3. **Warnsystem**
   
   Vor dem Kick erhält der Spieler eine detaillierte Nachricht:
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

## Code-Struktur

Das System verwendet eine modulare und organisierte Struktur:

### Spielerdatenverwaltung

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Timer-System

- `Timer_CheckPlayerPing`: Regelmäßige Ping-Überwachung
- `Timer_KickPlayer`: Verzögerte Kick-Ausführung
- `Timer_StartPingMonitor`: Startet die Überwachung nach dem Spawn

## Technische Details

### Leistungsüberlegungen

- Effiziente Speichernutzung durch organisierte Datenstruktur
- Optimierte Verwendung von Timern zur Minimierung der Serverlast
- Ordnungsgemäße Bereinigung von Timern bei Spieler-Disconnect

> [!NOTE]
> Das System ist darauf ausgelegt, minimale Auswirkungen auf die Serverleistung zu haben, auch bei vielen verbundenen Spielern.

## Anpassungsleitfaden

### Warnmeldungen anpassen

Sie können den Warnungsdialog anpassen, indem Sie die `Show_PingWarning` Funktion bearbeiten:
```pawn
stock Show_PingWarning(playerid) {
    // Passen Sie Ihre Nachricht hier an
    format(dialog_string, sizeof(dialog_string), 
        "Ihre benutzerdefinierte Nachricht hier..."
    );
}
```

### Zeitwerte anpassen

Ändern Sie die Konstanten am Anfang der Datei:
```pawn
#define MAX_PING                     (ihr_wert)
#define PING_CHECK_INTERVAL          (ihr_wert)
```

## Häufig gestellte Fragen

### Warum dieses System verwenden?

- Erhält die Serverleistung
- Gewährleistet faires Gameplay
- Besonders wichtig für Rollenspiel-Szenarien
- Verhindert Lag-bezogene Exploits

### Wann sollte ich den MAX_PING-Wert anpassen?

- Niedriger für Wettbewerbsserver (300-400ms)
- Höher für internationale Server (500-600ms)
- Berücksichtigen Sie den Standort Ihrer Zielgruppe

> [!IMPORTANT]
> Es wird empfohlen, verschiedene `MAX_PING`-Werte in einer kontrollierten Umgebung zu testen, bevor Sie sie in der Produktion implementieren, um die beste Balance für Ihren Server zu finden.

## Lizenz

Dieses Filterscript ist unter der Apache License 2.0 geschützt, die Folgendes erlaubt:

- ✔️ Kommerzielle und private Nutzung
- ✔️ Quellcode-Modifikation
- ✔️ Code-Verteilung
- ✔️ Patentgewährung

### Bedingungen:

- Copyright-Hinweis beibehalten
- Signifikante Änderungen dokumentieren
- Apache License 2.0 Kopie beifügen

Weitere Lizenzdetails: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Alle Rechte vorbehalten**