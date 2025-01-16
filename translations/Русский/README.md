# Anti-Ping

Anti-Ping - это специализированный filterscript, разработанный для мониторинга и управления задержкой игроков на серверах SA-MP. Он автоматически обнаруживает и удаляет игроков с чрезмерной задержкой для поддержания производительности сервера и качества игрового процесса, что особенно важно для ролевых серверов (RP/RPG).

## Языки

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Svenska: [README](../Svenska/README.md)
- Türkçe: [README](../Turkce/README.md)

## Содержание

- [Anti-Ping](#anti-ping)
  - [Языки](#языки)
  - [Содержание](#содержание)
  - [Функции](#функции)
  - [Установка](#установка)
  - [Конфигурация](#конфигурация)
  - [Как это работает](#как-это-работает)
  - [Структура кода](#структура-кода)
    - [Управление данными игрока](#управление-данными-игрока)
    - [Система таймеров](#система-таймеров)
  - [Технические детали](#технические-детали)
    - [Соображения производительности](#соображения-производительности)
  - [Руководство по настройке](#руководство-по-настройке)
    - [Изменение предупреждающих сообщений](#изменение-предупреждающих-сообщений)
    - [Настройка временных значений](#настройка-временных-значений)
  - [Часто задаваемые вопросы](#часто-задаваемые-вопросы)
    - [Почему стоит использовать эту систему?](#почему-стоит-использовать-эту-систему)
    - [Когда следует настраивать значение MAX\_PING?](#когда-следует-настраивать-значение-max_ping)
  - [Лицензия](#лицензия)
    - [Условия:](#условия)

## Функции

- Мониторинг пинга в реальном времени
- Автоматическое удаление игроков с высокой задержкой
- Подробные уведомления о кике
- Настраиваемые лимиты пинга
- Отслеживание информации об игроках
- Предупреждения об использовании VPN/Proxy
- Чистая и оптимизированная структура кода

## Установка

1. Скачайте файл [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx)
2. Скопируйте файл в папку `filterscripts` вашего сервера
3. Отредактируйте файл `server.cfg`
4. Добавьте `Anti-Ping` в строку `filterscripts`

**Пример конфигурации в server.cfg:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Если другие filterscripts уже загружены, добавьте Real-Time после них.

## Конфигурация

Система использует несколько настраиваемых констант, которые можно отрегулировать в соответствии с вашими потребностями:

```pawn
// Main settings
#define MAX_PING                     (500)      // Maximum allowed ping
#define PING_CHECK_INTERVAL          (2*1000)   // Check interval in ms
#define PING_CHECK_START_DELAY       (4*1000)   // Initial check delay
#define KICK_DELAY                   (5*100)    // Kick delay after warning
```

> [!WARNING]
> Установка `MAX_PING` на очень низкое значение может привести к ненужным кикам игроков со стабильным, но немного медленным соединением.

## Как это работает

1. **Подключение игрока**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Мониторинг пинга**
   
   Система регулярно проверяет пинг каждого игрока:
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

3. **Система предупреждений**
   
   Перед киком игрок получает подробное сообщение:
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

## Структура кода

Система использует модульную и организованную структуру:

### Управление данными игрока

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Система таймеров

- `Timer_CheckPlayerPing`: Регулярный мониторинг пинга
- `Timer_KickPlayer`: Отложенное выполнение кика
- `Timer_StartPingMonitor`: Запускает мониторинг после спавна

## Технические детали

### Соображения производительности

- Эффективное использование памяти благодаря организованной структуре данных
- Оптимизированное использование таймеров для минимизации нагрузки на сервер
- Правильная очистка таймеров при отключении игрока

> [!NOTE]
> Система разработана так, чтобы оказывать минимальное влияние на производительность сервера, даже при большом количестве подключенных игроков.

## Руководство по настройке

### Изменение предупреждающих сообщений

Вы можете настроить диалог предупреждения, отредактировав функцию `Show_PingWarning`:
```pawn
stock Show_PingWarning(playerid) {
    // Customize your message here
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Настройка временных значений

Измените константы в начале файла:
```pawn
#define MAX_PING                     (ваше_значение)
#define PING_CHECK_INTERVAL          (ваше_значение)
```

## Часто задаваемые вопросы

### Почему стоит использовать эту систему?

- Поддерживает производительность сервера
- Обеспечивает честную игру
- Особенно важно для ролевых сценариев
- Предотвращает эксплойты, связанные с лагами

### Когда следует настраивать значение MAX_PING?

- Ниже для соревновательных серверов (300-400мс)
- Выше для международных серверов (500-600мс)
- Учитывайте местоположение вашей целевой аудитории

> [!IMPORTANT]
> Рекомендуется протестировать различные значения `MAX_PING` в контролируемой среде перед внедрением в продакшн, чтобы найти наилучший баланс для вашего сервера.

## Лицензия

Этот Filterscript защищен лицензией Apache License 2.0, которая разрешает:

- ✔️ Коммерческое и частное использование
- ✔️ Модификацию исходного кода
- ✔️ Распространение кода
- ✔️ Патентную защиту

### Условия:

- Сохранение уведомления об авторских правах
- Документирование значительных изменений
- Включение копии лицензии Apache License 2.0

Для получения дополнительной информации о лицензии: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Все права защищены**