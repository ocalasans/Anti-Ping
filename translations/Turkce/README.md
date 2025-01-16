# Anti-Ping

Anti-Ping sistemi, SA-MP sunucularında oyuncu gecikmesini izlemek ve yönetmek için tasarlanmış özel bir filterscript'tir. Sunucu performansını ve oyun kalitesini korumak için aşırı ping değerine sahip oyuncuları otomatik olarak tespit eder ve kaldırır, özellikle roleplay sunucuları (RP/RPG) için önemlidir.

## Diller

- Português: [README](../../)
- Deutsch: [README](../Deutsch/README.md)
- English: [README](../English/README.md)
- Español: [README](../Espanol/README.md)
- Français: [README](../Francais/README.md)
- Italiano: [README](../Italiano/README.md)
- Polski: [README](../Polski/README.md)
- Русский: [README](../Русский/README.md)
- Svenska: [README](../Svenska/README.md)

## İçindekiler

- [Anti-Ping](#anti-ping)
  - [Diller](#diller)
  - [İçindekiler](#i̇çindekiler)
  - [Özellikler](#özellikler)
  - [Kurulum](#kurulum)
  - [Yapılandırma](#yapılandırma)
  - [Nasıl Çalışır](#nasıl-çalışır)
  - [Kod Yapısı](#kod-yapısı)
    - [Oyuncu Veri Yönetimi](#oyuncu-veri-yönetimi)
    - [Zamanlayıcı Sistemi](#zamanlayıcı-sistemi)
  - [Teknik Detaylar](#teknik-detaylar)
    - [Performans Değerlendirmeleri](#performans-değerlendirmeleri)
  - [Özelleştirme Kılavuzu](#özelleştirme-kılavuzu)
    - [Uyarı Mesajlarını Düzenleme](#uyarı-mesajlarını-düzenleme)
    - [Zaman Değerlerini Ayarlama](#zaman-değerlerini-ayarlama)
  - [Sık Sorulan Sorular](#sık-sorulan-sorular)
    - [Bu sistemi neden kullanmalıyım?](#bu-sistemi-neden-kullanmalıyım)
    - [MAX\_PING değerini ne zaman ayarlamalıyım?](#max_ping-değerini-ne-zaman-ayarlamalıyım)
  - [Lisans](#lisans)
    - [Koşullar:](#koşullar)

## Özellikler

- Gerçek zamanlı ping izleme
- Yüksek gecikmeli oyuncuların otomatik kaldırılması
- Detaylı atılma bildirimleri
- Özelleştirilebilir ping limitleri
- Oyuncu bilgi takibi
- VPN/Proxy kullanım uyarıları
- Temiz ve optimize edilmiş kod yapısı

## Kurulum

1. [Anti-Ping.amx](https://github.com/ocalasans/Anti-Ping/raw/refs/heads/main/src/Anti-Ping.amx) dosyasını indirin
2. Dosyayı sunucunuzun `filterscripts` klasörüne kopyalayın
3. `server.cfg` dosyasını düzenleyin
4. `filterscripts` satırına `Anti-Ping` ekleyin

**server.cfg'de örnek yapılandırma:**
```
filterscripts Anti-Ping
```

> [!WARNING]
> Eğer başka filterscript'ler zaten yüklüyse, Anti-Ping'ı onlardan sonra ekleyin.

## Yapılandırma

Sistem, ihtiyaçlarınıza göre ayarlanabilen çeşitli yapılandırılabilir sabitler kullanır:

```pawn
// Ana ayarlar
#define MAX_PING                     (500)      // İzin verilen maksimum ping
#define PING_CHECK_INTERVAL          (2*1000)   // Kontrol aralığı (ms)
#define PING_CHECK_START_DELAY       (4*1000)   // Başlangıç kontrol gecikmesi
#define KICK_DELAY                   (5*100)    // Uyarıdan sonra atılma gecikmesi
```

> [!WARNING]
> `MAX_PING` değerini çok düşük bir değere ayarlamak, stabil ancak biraz daha yavaş bağlantılara sahip oyuncuların gereksiz yere atılmasına neden olabilir.

## Nasıl Çalışır

1. **Oyuncu Bağlantısı**
   
   ```pawn
   public OnPlayerConnect(playerid) {
       // Reset player data
       APF_PlayerData[playerid][Player_HasExceededPing] = false;
       APF_PlayerData[playerid][Timer_PingCheck] = 0;

       return true;
   }
   ```

2. **Ping İzleme**
   
   Sistem düzenli olarak her oyuncunun pingini kontrol eder:
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

3. **Uyarı Sistemi**
   
   Vuruştan önce oyuncuya detaylı bir mesaj gönderilir:
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

## Kod Yapısı

Sistem modüler ve organize bir yapı kullanır:

### Oyuncu Veri Yönetimi

```pawn
enum Player_Data {
    bool:Player_HasExceededPing,
    Timer_PingCheck
}
static APF_PlayerData[MAX_PLAYERS][Player_Data];
```

### Zamanlayıcı Sistemi

- `Timer_CheckPlayerPing`: Düzenli ping izleme
- `Timer_KickPlayer`: Gecikmeli atılma işlemi
- `Timer_StartPingMonitor`: Doğumdan sonra izlemeyi başlatır

## Teknik Detaylar

### Performans Değerlendirmeleri

- Organize veri yapısı sayesinde verimli bellek kullanımı
- Sunucu yükünü en aza indirmek için optimize edilmiş zamanlayıcı kullanımı
- Oyuncu bağlantısı kesildiğinde zamanlayıcıların düzgün temizlenmesi

> [!NOTE]
> Sistem, çok sayıda bağlı oyuncu olsa bile sunucu performansı üzerinde minimum etki yaratacak şekilde tasarlanmıştır.

## Özelleştirme Kılavuzu

### Uyarı Mesajlarını Düzenleme

`Show_PingWarning` fonksiyonunu düzenleyerek uyarı iletişim kutusunu özelleştirebilirsiniz:
```pawn
stock Show_PingWarning(playerid) {
    // Mesajınızı burada özelleştirin
    format(dialog_string, sizeof(dialog_string), 
        "Your custom message here..."
    );
}
```

### Zaman Değerlerini Ayarlama

Dosyanın başındaki sabitleri değiştirin:
```pawn
#define MAX_PING                     (sizin_değeriniz)
#define PING_CHECK_INTERVAL          (sizin_değeriniz)
```

## Sık Sorulan Sorular

### Bu sistemi neden kullanmalıyım?

- Sunucu performansını korur
- Adil oyun deneyimi sağlar
- Özellikle roleplay senaryoları için önemlidir
- Gecikme kaynaklı istismarları önler

### MAX_PING değerini ne zaman ayarlamalıyım?

- Rekabetçi sunucular için daha düşük (300-400ms)
- Uluslararası sunucular için daha yüksek (500-600ms)
- Hedef kitlenizin konumunu göz önünde bulundurun

> [!IMPORTANT]
> Sunucunuz için en iyi dengeyi bulmak amacıyla, üretim ortamında uygulamadan önce farklı `MAX_PING` değerlerini kontrollü bir ortamda test etmeniz önerilir.

## Lisans

Bu Filterscript, Apache License 2.0 kapsamında korunmaktadır ve şunlara izin verir:

- ✔️ Ticari ve özel kullanım
- ✔️ Kaynak kodu değişikliği
- ✔️ Kod dağıtımı
- ✔️ Patent hakkı

### Koşullar:

- Telif hakkı bildirimini koruyun
- Önemli değişiklikleri belgeleyin
- Apache License 2.0 kopyasını ekleyin

Daha fazla lisans detayı için: http://www.apache.org/licenses/LICENSE-2.0

**Copyright (c) Calasans - Tüm hakları saklıdır**