# Anti-Ping

Il sistema Anti-Ping è un filterscript specializzato progettato per monitorare e gestire la latenza dei giocatori sui server SA-MP. Rileva e rimuove automaticamente i giocatori con ping eccessivo per mantenere le prestazioni del server e la qualità del gameplay, particolarmente importante per i server roleplay (RP/RPG).

## Lingue

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Indice

- [Anti-Ping](#anti-ping)
  - [Lingue](#lingue)
  - [Indice](#indice)
  - [Caratteristiche](#caratteristiche)
  - [Installazione](#installazione)
  - [Configurazione](#configurazione)
  - [Come Funziona](#come-funziona)
  - [Struttura del Codice](#struttura-del-codice)
    - [Gestione Dati Giocatore](#gestione-dati-giocatore)
    - [Sistema Timer](#sistema-timer)
  - [Dettagli Tecnici](#dettagli-tecnici)
    - [Considerazioni sulle Prestazioni](#considerazioni-sulle-prestazioni)
  - [Guida alla Personalizzazione](#guida-alla-personalizzazione)
    - [Modifica dei Messaggi di Avviso](#modifica-dei-messaggi-di-avviso)
    - [Regolazione dei Valori Temporali](#regolazione-dei-valori-temporali)
  - [Domande Frequenti](#domande-frequenti)
    - [Perché usare questo sistema?](#perché-usare-questo-sistema)
    - [Quando dovrei regolare il valore MAX\_PING?](#quando-dovrei-regolare-il-valore-max_ping)
  - [Licenza](#licenza)
    - [Condizioni:](#condizioni)

## Caratteristiche

- Monitoraggio del ping in tempo reale
- Rimozione automatica dei giocatori con alta latenza
- Notifiche dettagliate di espulsione
- Limiti di ping personalizzabili
- Monitoraggio delle informazioni dei giocatori
- Avvisi sull'uso di VPN/Proxy
- Struttura del codice pulita e ottimizzata

## Installazione

1. Scarica il file [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx)
2. Copia il file nella cartella `filterscripts` del tuo server
3. Modifica il file `server.cfg`
4. Aggiungi `Anti-Ping` alla riga `filterscripts`

**Esempio di configurazione in server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Se altri filterscripts sono già caricati, aggiungi Real-Time dopo di essi.

## Configurazione

Il sistema utilizza diverse costanti configurabili che possono essere regolate in base alle tue esigenze:

```pawn
// Main settings
#define MAX_PING                     (500)      // Maximum allowed ping
#define PING_CHECK_INTERVAL          (2*1000)   // Check interval in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Initial check delay
#define KICK_DELAY                   (5*100)    // Kick delay after warning
```

> [!WARNING]
> Impostare `MAX_PING` su un valore molto basso potrebbe causare l'espulsione non necessaria di giocatori con connessioni stabili ma leggermente più lente.

## Come Funziona

1. **Connessione del Giocatore**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Monitoraggio del Ping**
   
   Il sistema controlla regolarmente il ping di ogni giocatore:
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

3. **Sistema di Avviso**
   
   Prima dell'espulsione, il giocatore riceve un messaggio dettagliato:
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

## Struttura del Codice

Il sistema utilizza una struttura modulare e organizzata:

### Gestione Dati Giocatore

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Sistema Timer

- `Timer_CheckPlayerPing`: Monitoraggio regolare del ping
- `Timer_KickPlayer`: Esecuzione ritardata dell'espulsione
- `Timer_StartPingMonitor`: Avvia il monitoraggio dopo lo spawn

## Dettagli Tecnici

### Considerazioni sulle Prestazioni

- Utilizzo efficiente della memoria attraverso una struttura dati organizzata
- Uso ottimizzato dei timer per minimizzare il carico del server
- Corretta pulizia dei timer alla disconnessione del giocatore

> [!NOTE]
> Il sistema è progettato per avere un impatto minimo sulle prestazioni del server, anche con molti giocatori connessi.

## Guida alla Personalizzazione

### Modifica dei Messaggi di Avviso

Puoi personalizzare il dialogo di avviso modificando la funzione `Show_PingWarning`:
```pawn
stock Show_PingWarning(playerid) {
    // Customize your message here
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Regolazione dei Valori Temporali

Modifica le costanti all'inizio del file:
```pawn
#define MAX_PING                     (il_tuo_valore)
#define PING_CHECK_INTERVAL          (il_tuo_valore)
```

## Domande Frequenti

### Perché usare questo sistema?

- Mantiene le prestazioni del server
- Assicura un gameplay equo
- Particolarmente importante per scenari roleplay
- Previene exploit legati al lag

### Quando dovrei regolare il valore MAX_PING?

- Più basso per server competitivi (300-400ms)
- Più alto per server internazionali (500-600ms)
- Considera la posizione del tuo pubblico target

> [!IMPORTANT]
> Si consiglia di testare diversi valori di `MAX_PING` in un ambiente controllato prima dell'implementazione in produzione per trovare il miglior equilibrio per il tuo server.

## Licenza

Questo Filterscript è protetto sotto la Licenza Apache 2.0, che permette:

- ✔️ Uso commerciale e privato
- ✔️ Modifica del codice sorgente
- ✔️ Distribuzione del codice
- ✔️ Concessione di brevetto

### Condizioni:

- Mantenere l'avviso di copyright
- Documentare le modifiche significative
- Includere una copia della Licenza Apache 2.0

Per maggiori dettagli sulla licenza: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Tutti i diritti riservati**