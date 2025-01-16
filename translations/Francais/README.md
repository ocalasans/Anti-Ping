# Anti-Ping

Le système Anti-Ping est un filterscript spécialisé conçu pour surveiller et gérer la latence des joueurs sur les serveurs SA-MP. Il détecte et supprime automatiquement les joueurs ayant un ping excessif pour maintenir les performances du serveur et la qualité du gameplay, particulièrement important pour les serveurs de roleplay (RP/RPG).

## Langues

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Index

- [Anti-Ping](#anti-ping)
  - [Langues](#langues)
  - [Index](#index)
  - [Fonctionnalités](#fonctionnalités)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Fonctionnement](#fonctionnement)
  - [Structure du Code](#structure-du-code)
    - [Gestion des Données des Joueurs](#gestion-des-données-des-joueurs)
    - [Système de Minuterie](#système-de-minuterie)
  - [Détails Techniques](#détails-techniques)
    - [Considérations de Performance](#considérations-de-performance)
  - [Guide de Personnalisation](#guide-de-personnalisation)
    - [Modification des Messages d'Avertissement](#modification-des-messages-davertissement)
    - [Ajustement des Valeurs de Temps](#ajustement-des-valeurs-de-temps)
  - [Questions Fréquemment Posées](#questions-fréquemment-posées)
    - [Pourquoi utiliser ce système ?](#pourquoi-utiliser-ce-système-)
    - [Quand dois-je ajuster la valeur MAX\_PING ?](#quand-dois-je-ajuster-la-valeur-max_ping-)
  - [Licence](#licence)
    - [Conditions:](#conditions)

## Fonctionnalités

- Surveillance du ping en temps réel
- Suppression automatique des joueurs à haute latence
- Notifications détaillées d'expulsion
- Limites de ping personnalisables
- Suivi des informations des joueurs
- Avertissements d'utilisation de VPN/Proxy
- Structure de code propre et optimisée

## Installation

1. Téléchargez le fichier [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx)
2. Copiez le fichier dans le dossier `filterscripts` de votre serveur
3. Modifiez le fichier `server.cfg`
4. Ajoutez `Anti-Ping` à la ligne `filterscripts`

**Exemple de configuration dans server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Si d'autres filterscripts sont déjà chargés, ajoutez Real-Time après eux.

## Configuration

Le système utilise plusieurs constantes configurables qui peuvent être ajustées selon vos besoins:

```pawn
// Main settings
#define MAX_PING                     (500)      // Maximum allowed ping
#define PING_CHECK_INTERVAL          (2*1000)   // Check interval in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Initial check delay
#define KICK_DELAY                   (5*100)    // Kick delay after warning
```

> [!WARNING]
> Définir `MAX_PING` à une valeur très basse peut entraîner des expulsions inutiles de joueurs ayant des connexions stables mais légèrement plus lentes.

## Fonctionnement

1. **Connexion du Joueur**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Surveillance du Ping**
   
   Le système vérifie régulièrement le ping de chaque joueur:
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

3. **Système d'Avertissement**
   
   Avant l'expulsion, le joueur reçoit un message détaillé:
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

## Structure du Code

Le système utilise une structure modulaire et organisée:

### Gestion des Données des Joueurs

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Système de Minuterie

- `Timer_CheckPlayerPing`: Surveillance régulière du ping
- `Timer_KickPlayer`: Exécution différée de l'expulsion
- `Timer_StartPingMonitor`: Démarre la surveillance après le spawn

## Détails Techniques

### Considérations de Performance

- Utilisation efficace de la mémoire grâce à une structure de données organisée
- Utilisation optimisée des minuteries pour minimiser la charge du serveur
- Nettoyage approprié des minuteries lors de la déconnexion des joueurs

> [!NOTE]
> Le système est conçu pour avoir un impact minimal sur les performances du serveur, même avec de nombreux joueurs connectés.

## Guide de Personnalisation

### Modification des Messages d'Avertissement

Vous pouvez personnaliser la boîte de dialogue d'avertissement en modifiant la fonction `Show_PingWarning`:
```pawn
stock Show_PingWarning(playerid) {
    // Customize your message here
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Ajustement des Valeurs de Temps

Modifiez les constantes au début du fichier:
```pawn
#define MAX_PING                     (votre_valeur)
#define PING_CHECK_INTERVAL          (votre_valeur)
```

## Questions Fréquemment Posées

### Pourquoi utiliser ce système ?

- Maintient les performances du serveur
- Assure un gameplay équitable
- Particulièrement important pour les scénarios de roleplay
- Prévient les exploits liés au lag

### Quand dois-je ajuster la valeur MAX_PING ?

- Plus basse pour les serveurs compétitifs (300-400ms)
- Plus élevée pour les serveurs internationaux (500-600ms)
- Prenez en compte la localisation de votre public cible

> [!IMPORTANT]
> Il est recommandé de tester différentes valeurs de `MAX_PING` dans un environnement contrôlé avant de les implémenter en production pour trouver le meilleur équilibre pour votre serveur.

## Licence

Ce Filterscript est protégé par la licence Apache License 2.0, qui permet:

- ✔️ Utilisation commerciale et privée
- ✔️ Modification du code source
- ✔️ Distribution du code
- ✔️ Octroi de brevet

### Conditions:

- Maintenir l'avis de droit d'auteur
- Documenter les changements significatifs
- Inclure une copie de la licence Apache License 2.0

Pour plus de détails sur la licence: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Tous droits réservés**