# Anti-Ping

O sistema Anti-Ping é um filterscript especializado projetado para monitorar e gerenciar a latência dos jogadores em servidores SA-MP. Ele detecta e remove automaticamente jogadores com ping excessivo para manter o desempenho do servidor e a qualidade do gameplay, particularmente importante para servidores de roleplay (RP/RPG).

## Idiomas

- Deutsch: [README](translations/Deutsch/README.md)
- English: [README](translations/English/README.md)
- Español: [README](translations/Espanol/README.md)
- Français: [README](translations/Francais/README.md)
- Italiano: [README](translations/Italiano/README.md)
- Polski: [README](translations/Polski/README.md)
- Русский: [README](translations/Русский/README.md)
- Svenska: [README](translations/Svenska/README.md)
- Türkçe: [README](translations/Turkce/README.md)

## Índice

- [Anti-Ping](#anti-ping)
  - [Idiomas](#idiomas)
  - [Índice](#índice)
  - [Funcionalidades](#funcionalidades)
  - [Instalação](#instalação)
  - [Configuração](#configuração)
  - [Como Funciona](#como-funciona)
  - [Estrutura do Código](#estrutura-do-código)
    - [Gerenciamento de Dados dos Jogadores](#gerenciamento-de-dados-dos-jogadores)
    - [Sistema de Timers](#sistema-de-timers)
  - [Detalhes Técnicos](#detalhes-técnicos)
    - [Considerações de Performance](#considerações-de-performance)
  - [Guia de Personalização](#guia-de-personalização)
    - [Modificando as Mensagens de Aviso](#modificando-as-mensagens-de-aviso)
    - [Ajustando Valores de Tempo](#ajustando-valores-de-tempo)
  - [Perguntas Frequentes](#perguntas-frequentes)
    - [Por que usar este sistema?](#por-que-usar-este-sistema)
    - [Quando devo ajustar o valor MAX\_PING?](#quando-devo-ajustar-o-valor-max_ping)
  - [Licença](#licença)
    - [Condições:](#condições)

## Funcionalidades

- Monitoramento de ping em tempo real
- Remoção automática de jogadores com latência
- Notificações detalhadas de kick
- Limites de ping personalizáveis
- Rastreamento de informações do jogador
- Avisos sobre uso de VPN/Proxy
- Estrutura de código limpa e otimizada

## Instalação

1. Baixe o arquivo [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx)
2. Copie o arquivo para a pasta `filterscripts` do seu servidor
3. Edite o arquivo `server.cfg`
4. Adicione `Anti-Ping` na linha `filterscripts`

**Exemplo de configuração no server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Se já existirem outros filterscripts carregados, adicione o Anti-Ping após eles.

## Configuração

O sistema utiliza várias constantes configuráveis que podem ser ajustadas conforme suas necessidades:

```pawn
// Configurações principais
#define MAX_PING                     (500)      // Ping máximo permitido
#define PING_CHECK_INTERVAL          (2*1000)   // Intervalo de verificação em ms
#define PING_CHECK_START_DELAY       (4*1000)   // Atraso inicial da verificação
#define KICK_DELAY                   (5*100)    // Atraso do kick após o aviso
```

> [!WARNING]
> Alterar o `MAX_PING` para um valor muito baixo pode resultar em kicks desnecessários de jogadores com conexões estáveis mas levemente mais lentas.

## Como Funciona

1. **Conexão do Jogador**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Resetar dados do jogador
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Monitoramento de Ping**
   
   O sistema verifica regularmente o ping de cada jogador:
   ```pawn
   public Timer_CheckPlayerPing(playerid) {
       if(!IsPlayerConnected(playerid))
           return false;
       
       if(!APF_PlayerData[playerid][Player_HasExceededPing] && 
          GetPlayerPing(playerid) >= MAX_PING) {
           // Exibe aviso e agenda o kick
           Show_PingWarning(playerid);
           SetTimerEx("Timer_KickPlayer", KICK_DELAY, false, "i", playerid);
       }

       return true;
   }
   ```

3. **Sistema de Aviso**
   
   Antes do kick, o jogador recebe uma mensagem detalhada:
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

## Estrutura do Código

O sistema utiliza uma estrutura modular e organizada:

### Gerenciamento de Dados dos Jogadores

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Sistema de Timers

- `Timer_CheckPlayerPing`: Monitoramento regular do ping
- `Timer_KickPlayer`: Execução do kick com atraso
- `Timer_StartPingMonitor`: Inicia o monitoramento após o spawn

## Detalhes Técnicos

### Considerações de Performance

- Uso eficiente de memória através de estrutura de dados organizada
- Uso otimizado de timers para minimizar a carga do servidor
- Limpeza adequada dos timers na desconexão do jogador

> [!NOTE]
> O sistema foi projetado para ter um impacto mínimo no desempenho do servidor, mesmo com muitos jogadores conectados.

## Guia de Personalização

### Modificando as Mensagens de Aviso

Você pode personalizar o diálogo de aviso editando a função `Show_PingWarning`:
```pawn
stock Show_PingWarning(playerid) {
    // Personalize sua mensagem aqui
    format(dialog_string, sizeof(dialog_string), 
        "Sua mensagem personalizada aqui..."
    );
}
```

### Ajustando Valores de Tempo

Modifique as constantes no início do arquivo:
```pawn
#define MAX_PING                     (seu_valor)
#define PING_CHECK_INTERVAL          (seu_valor)
```

## Perguntas Frequentes

### Por que usar este sistema?

- Mantém o desempenho do servidor
- Garante um gameplay justo
- Particularmente importante para cenários de roleplay
- Previne exploits relacionados ao lag

### Quando devo ajustar o valor MAX_PING?

- Mais baixo para servidores competitivos (300-400ms)
- Mais alto para servidores internacionais (500-600ms)
- Considere a localização do seu público-alvo

> [!IMPORTANT]
> Recomenda-se testar diferentes valores de `MAX_PING` em um ambiente controlado antes de implementar em produção para encontrar o melhor equilíbrio para seu servidor.

## Licença

Este Filterscript está protegido sob a Licença Apache 2.0, que permite:

- ✔️ Uso comercial e privado
- ✔️ Modificação do código fonte
- ✔️ Distribuição do código
- ✔️ Concessão de patentes

### Condições:

- Manter o aviso de direitos autorais
- Documentar alterações significativas
- Incluir cópia da licença Apache 2.0

Para mais detalhes sobre a licença: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Todos os direitos reservados**