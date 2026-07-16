# Roadmap

> 🇹🇷 Türkçe için aşağıya kaydırın.

## ✅ Done

- Per-minute background measurement of hotspot / Wi-Fi / Ethernet, counted separately
- Only hotspot counts against quota; VPN-resilient physical-interface counting
- "Real remaining quota" via manual entry from the carrier app
- Menu-bar live usage + auto mini window on hotspot connect
- Modern, dark-mode-aware detailed report (clickable colored network cells, per-app breakdown)
- Stepped daily alerts (every 500 MB) + 60% / 80% quota warnings
- **Emergency protection:** red alarm when traffic shifts to the phone while Ethernet is connected
- Hotspot Window (route one browser window via the phone without unplugging Ethernet)
- Hourly usage chart with anomaly markers
- Help / Feedback button (email + GitHub Issues)
- Bilingual UI (English / Turkish) — app and report
- Android support: broad IP ranges + "Mark This Network as Hotspot" (brand-independent)
- Single-instance protection, start-at-login toggle, installer wizard
- Published on GitHub with CI + pre-commit checks

## 🔜 Planned

**Next up**
- Notification Center widget (glance at usage without opening the menu)
- End-of-period forecast ("at this rate you'll reach ~X GB") with a nice graph

**Idea pool**
- App-based limit ("warn me when Chrome passes 1 GB today")
- End-of-day summary graph
- Low-data-mode suggestion when quota is critical
- TripMode-style per-app blocking on hotspot
- iCloud sync to combine multiple Macs
- Even more polished report visuals

**Optional / later**
- Apple Developer signing + notarization ($99/yr) → removes the "right-click → Open" step

---

# Yol Haritası (Türkçe)

## ✅ Yapılanlar

- Hotspot / Wi-Fi / Ethernet trafiğini dakikada bir ayrı ayrı ölçen arka plan servisi
- Yalnızca hotspot kotadan sayılır; VPN'e dayanıklı fiziksel-arayüz sayımı
- Operatör uygulamasından elle girişle "gerçek kalan kota"
- Menü çubuğunda anlık kullanım + hotspot'a bağlanınca otomatik mini pencere
- Modern, karanlık tema destekli detaylı rapor (tıklanabilir renkli ağ hücreleri, uygulama dökümü)
- Kademeli günlük uyarılar (her 500 MB) + %60 / %80 kota uyarıları
- **Acil koruma:** Ethernet bağlıyken trafik telefona kayarsa kırmızı alarm
- Hotspot Penceresi (Ethernet'i çekmeden bir tarayıcı penceresini telefondan geçir)
- Anomali işaretli saatlik kullanım grafiği
- Yardım / Geri Bildirim butonu (e-posta + GitHub Issues)
- Çift dilli arayüz (İngilizce / Türkçe) — uygulama ve rapor
- Android desteği: geniş IP aralığı + "Bu Ağı Hotspot Olarak İşaretle" (marka bağımsız)
- Tek kopya koruması, açılışta başlat seçeneği, kurulum sihirbazı
- CI + pre-commit denetimleriyle GitHub'da yayında

## 🔜 Planlananlar

**Sıradaki**
- Bildirim Merkezi widget'ı (menüyü açmadan kullanıma göz atma)
- Dönem sonu tahmini ("bu hızla ~X GB'a ulaşırsın") + güzel grafik

**Fikir havuzu**
- Uygulama bazlı limit ("Chrome bugün 1 GB'ı geçince uyar")
- Gün sonu özet grafiği
- Kota kritikken düşük veri modu önerisi
- TripMode tarzı hotspot'ta uygulama engelleme
- iCloud ile birden fazla Mac'i birleştirme
- Daha da gösterişli rapor görselleri

**İsteğe bağlı / ileride**
- Apple Developer imzası + notarizasyon (99 $/yıl) → "sağ tık → Aç" adımını kaldırır
