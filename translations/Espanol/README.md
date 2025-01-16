# Anti-Ping

El sistema Anti-Ping es un filterscript especializado diseñado para monitorear y gestionar la latencia de los jugadores en servidores SA-MP. Detecta y elimina automáticamente a los jugadores con ping excesivo para mantener el rendimiento del servidor y la calidad del juego, particularmente importante para servidores de roleplay (RP/RPG).

## Idiomas

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Índice

- [Anti-Ping](#anti-ping)
  - [Idiomas](#idiomas)
  - [Índice](#índice)
  - [Características](#características)
  - [Instalación](#instalación)
  - [Configuración](#configuración)
  - [Cómo Funciona](#cómo-funciona)
  - [Estructura del Código](#estructura-del-código)
    - [Gestión de Datos del Jugador](#gestión-de-datos-del-jugador)
    - [Sistema de Temporizadores](#sistema-de-temporizadores)
  - [Detalles Técnicos](#detalles-técnicos)
    - [Consideraciones de Rendimiento](#consideraciones-de-rendimiento)
  - [Guía de Personalización](#guía-de-personalización)
    - [Modificación de Mensajes de Advertencia](#modificación-de-mensajes-de-advertencia)
    - [Ajuste de Valores de Tiempo](#ajuste-de-valores-de-tiempo)
  - [Preguntas Frecuentes](#preguntas-frecuentes)
    - [¿Por qué usar este sistema?](#por-qué-usar-este-sistema)
    - [¿Cuándo debo ajustar el valor MAX\_PING?](#cuándo-debo-ajustar-el-valor-max_ping)
  - [Licencia](#licencia)
    - [Condiciones:](#condiciones)

## Características

- Monitoreo de ping en tiempo real
- Eliminación automática de jugadores con alta latencia
- Notificaciones detalladas de expulsión
- Límites de ping personalizables
- Seguimiento de información del jugador
- Advertencias de uso de VPN/Proxy
- Estructura de código limpia y optimizada

## Instalación

1. Descarga el archivo [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx)
2. Copia el archivo a la carpeta `filterscripts` de tu servidor
3. Edita el archivo `server.cfg`
4. Añade `Anti-Ping` a la línea `filterscripts`

**Ejemplo de configuración en server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Si ya hay otros filterscripts cargados, añade Real-Time después de ellos.

## Configuración

El sistema utiliza varias constantes configurables que se pueden ajustar según tus necesidades:

```pawn
// Main settings
#define MAX_PING                     (500)      // Maximum allowed ping
#define PING_CHECK_INTERVAL          (2*1000)   // Check interval in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Initial check delay
#define KICK_DELAY                   (5*100)    // Kick delay after warning
```

> [!WARNING]
> Establecer `MAX_PING` en un valor muy bajo puede resultar en expulsiones innecesarias de jugadores con conexiones estables pero ligeramente más lentas.

## Cómo Funciona

1. **Conexión del Jugador**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Monitoreo de Ping**
   
   El sistema verifica regularmente el ping de cada jugador:
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

3. **Sistema de Advertencia**
   
   Antes de la expulsión, el jugador recibe un mensaje detallado:
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

## Estructura del Código

El sistema utiliza una estructura modular y organizada:

### Gestión de Datos del Jugador

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Sistema de Temporizadores

- `Timer_CheckPlayerPing`: Monitoreo regular del ping
- `Timer_KickPlayer`: Ejecución retrasada de expulsión
- `Timer_StartPingMonitor`: Inicia el monitoreo después del spawn

## Detalles Técnicos

### Consideraciones de Rendimiento

- Uso eficiente de memoria a través de una estructura de datos organizada
- Uso optimizado de temporizadores para minimizar la carga del servidor
- Limpieza adecuada de temporizadores al desconectarse el jugador

> [!NOTE]
> El sistema está diseñado para tener un impacto mínimo en el rendimiento del servidor, incluso con muchos jugadores conectados.

## Guía de Personalización

### Modificación de Mensajes de Advertencia

Puedes personalizar el diálogo de advertencia editando la función `Show_PingWarning`:
```pawn
stock Show_PingWarning(playerid) {
    // Customize your message here
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Ajuste de Valores de Tiempo

Modifica las constantes al inicio del archivo:
```pawn
#define MAX_PING                     (tu_valor)
#define PING_CHECK_INTERVAL          (tu_valor)
```

## Preguntas Frecuentes

### ¿Por qué usar este sistema?

- Mantiene el rendimiento del servidor
- Asegura un juego justo
- Particularmente importante para escenarios de roleplay
- Previene exploits relacionados con el lag

### ¿Cuándo debo ajustar el valor MAX_PING?

- Más bajo para servidores competitivos (300-400ms)
- Más alto para servidores internacionales (500-600ms)
- Considera la ubicación de tu audiencia objetivo

> [!IMPORTANT]
> Se recomienda probar diferentes valores de `MAX_PING` en un entorno controlado antes de implementarlos en producción para encontrar el mejor equilibrio para tu servidor.

## Licencia

Este Filterscript está protegido bajo la Licencia Apache 2.0, que permite:

- ✔️ Uso comercial y privado
- ✔️ Modificación del código fuente
- ✔️ Distribución del código
- ✔️ Concesión de patentes

### Condiciones:

- Mantener el aviso de copyright
- Documentar cambios significativos
- Incluir copia de la Licencia Apache 2.0

Para más detalles de la licencia: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Todos los derechos reservados**