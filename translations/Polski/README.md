# Anti-Ping

System Anti-Ping to wyspecjalizowany filterscript zaprojektowany do monitorowania i zarządzania opóźnieniem graczy na serwerach SA-MP. Automatycznie wykrywa i usuwa graczy z nadmiernym pingiem, aby utrzymać wydajność serwera i jakość rozgrywki, co jest szczególnie ważne dla serwerów roleplay (RP/RPG).

## Języki

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Spis treści

- [Anti-Ping](#anti-ping)
  - [Języki](#języki)
  - [Spis treści](#spis-treści)
  - [Funkcje](#funkcje)
  - [Instalacja](#instalacja)
  - [Konfiguracja](#konfiguracja)
  - [Jak to działa](#jak-to-działa)
  - [Struktura kodu](#struktura-kodu)
    - [Zarządzanie danymi graczy](#zarządzanie-danymi-graczy)
    - [System timerów](#system-timerów)
  - [Szczegóły techniczne](#szczegóły-techniczne)
    - [Aspekty wydajnościowe](#aspekty-wydajnościowe)
  - [Przewodnik dostosowywania](#przewodnik-dostosowywania)
    - [Modyfikowanie komunikatów ostrzeżeń](#modyfikowanie-komunikatów-ostrzeżeń)
    - [Dostosowywanie wartości czasowych](#dostosowywanie-wartości-czasowych)
  - [Często zadawane pytania](#często-zadawane-pytania)
    - [Dlaczego warto używać tego systemu?](#dlaczego-warto-używać-tego-systemu)
    - [Kiedy należy dostosować wartość MAX\_PING?](#kiedy-należy-dostosować-wartość-max_ping)
  - [Licencja](#licencja)
    - [Warunki:](#warunki)

## Funkcje

- Monitorowanie pingu w czasie rzeczywistym
- Automatyczne usuwanie graczy z wysokim opóźnieniem
- Szczegółowe powiadomienia o wyrzuceniu
- Konfigurowalne limity pingu
- Śledzenie informacji o graczach
- Ostrzeżenia o używaniu VPN/Proxy
- Przejrzysta i zoptymalizowana struktura kodu

## Instalacja

1. Pobierz plik [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx)
2. Skopiuj plik do folderu `filterscripts` na swoim serwerze
3. Edytuj plik `server.cfg`
4. Dodaj `Anti-Ping` do linii `filterscripts`

**Przykładowa konfiguracja w server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Jeśli inne filterscripts są już załadowane, dodaj Anti-Ping po nich.

## Konfiguracja

System wykorzystuje kilka konfigurowalnych stałych, które można dostosować do swoich potrzeb:

```pawn
// Główne ustawienia
#define MAX_PING                     (500)      // Maksymalny dozwolony ping
#define PING_CHECK_INTERVAL          (2*1000)   // Interwał sprawdzania w ms
#define PING_CHECK_START_DELAY       (4*1000)   // Początkowe opóźnienie sprawdzania
#define KICK_DELAY                   (5*100)    // Opóźnienie wyrzucenia po ostrzeżeniu
```

> [!WARNING]
> Ustawienie `MAX_PING` na bardzo niską wartość może skutkować niepotrzebnymi wyrzuceniami graczy ze stabilnym, ale nieco wolniejszym połączeniem.

## Jak to działa

1. **Połączenie gracza**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Monitorowanie pingu**
   
   System regularnie sprawdza ping każdego gracza:
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

3. **System ostrzeżeń**
   
   Przed wyrzuceniem gracz otrzymuje szczegółową wiadomość:
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

## Struktura kodu

System wykorzystuje modularną i zorganizowaną strukturę:

### Zarządzanie danymi graczy

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### System timerów

- `Timer_CheckPlayerPing`: Regularne monitorowanie pingu
- `Timer_KickPlayer`: Opóźnione wykonanie wyrzucenia
- `Timer_StartPingMonitor`: Rozpoczyna monitorowanie po spawnie

## Szczegóły techniczne

### Aspekty wydajnościowe

- Efektywne wykorzystanie pamięci poprzez zorganizowaną strukturę danych
- Zoptymalizowane wykorzystanie timerów w celu zminimalizowania obciążenia serwera
- Prawidłowe czyszczenie timerów przy rozłączeniu gracza

> [!NOTE]
> System został zaprojektowany tak, aby miał minimalny wpływ na wydajność serwera, nawet przy wielu połączonych graczach.

## Przewodnik dostosowywania

### Modyfikowanie komunikatów ostrzeżeń

Możesz dostosować dialog ostrzegawczy, edytując funkcję `Show_PingWarning`:
```pawn
stock Show_PingWarning(playerid) {
    // Dostosuj swoją wiadomość tutaj
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Dostosowywanie wartości czasowych

Zmodyfikuj stałe na początku pliku:
```pawn
#define MAX_PING                     (twoja_wartość)
#define PING_CHECK_INTERVAL          (twoja_wartość)
```

## Często zadawane pytania

### Dlaczego warto używać tego systemu?

- Utrzymuje wydajność serwera
- Zapewnia uczciwą rozgrywkę
- Szczególnie ważne dla scenariuszy roleplay
- Zapobiega exploitom związanym z lagami

### Kiedy należy dostosować wartość MAX_PING?

- Niższą dla serwerów konkurencyjnych (300-400ms)
- Wyższą dla serwerów międzynarodowych (500-600ms)
- Weź pod uwagę lokalizację docelowej grupy graczy

> [!IMPORTANT]
> Zaleca się przetestowanie różnych wartości `MAX_PING` w kontrolowanym środowisku przed wdrożeniem na produkcji, aby znaleźć najlepszy balans dla twojego serwera.

## Licencja

Ten Filterscript jest chroniony licencją Apache License 2.0, która pozwala na:

- ✔️ Użytek komercyjny i prywatny
- ✔️ Modyfikację kodu źródłowego
- ✔️ Dystrybucję kodu
- ✔️ Udzielenie patentu

### Warunki:

- Zachowanie informacji o prawach autorskich
- Dokumentowanie znaczących zmian
- Dołączenie kopii licencji Apache License 2.0

Więcej szczegółów licencji: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Wszelkie prawa zastrzeżone**