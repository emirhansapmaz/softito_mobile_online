# Ödev 2: SOLID İhlalleri ve Çözüm Açıklamaları

Aşağıda verilen orijinal kodda tespit edilen SOLID ihlalleri ve uygulanan Clean Code çözümleri özetlenmiştir:

### 1. LSP (Liskov Substitution Principle - Liskov Yerine Geçme Prensibi)
- **Neden İhlal?:** `DijitalUrun` alt sınıfı, üst sınıfı olan `Urun` içerisindeki `kargoUcretiHesapla()` metodunu geçersiz kılıp bir istisna (`throw Exception`) fırlatıyordu. Üst sınıf referansıyla çalışırken alt sınıfın programı kırması LSP'yi ihlal eder.
- **Nasıl Çözüldü?:** `DijitalUrun` sınıfında kargo ücreti `0.0` döndürülerek döngü içerisindeki polimorfik çağrının hatasız çalışması sağlandı.

### 2. OCP (Open/Closed Principle - Açık/Kapalı Prensibi)
- **Neden İhlal?:** `odemeYap()` fonksiyonu içinde ödeme yöntemleri `if-else` bloklarıyla kontrol ediliyordu. Yeni bir ödeme yöntemi eklemek var olan kodu değiştirmeyi gerektiriyordu.
- **Nasıl Çözüldü?:** `IOdemeYontemi` interface'i (Strategy Pattern) oluşturularak her ödeme türü kendi sınıfına ayrıldı; sistem yeni ödeme yöntemlerine açık fakat mevcut kodu değiştirmeye kapalı hale getirildi.

### 3. DIP (Dependency Inversion Principle - Bağımlılıkların Tersine Çevrilmesi Prensibi)
- **Neden İhlal?:** `SiparisYoneticisi`, somut veritabanı (`SqliteVeritabani`) ve bildirim sınıflarını (`SmtpMailServisi`, `NetgsmSmsServisi`) doğrudan `new` anahtar kelimesiyle kendi içinde üreterek somut implementasyonlara sıkı bağımlıydı.
- **Nasıl Çözüldü?:** Soyut arayüzler (`IVeritabani`, `IBildirimServisi`, `IKargoServisi`) tanımlandı ve `SiparisYoneticisi` sınıfına Constructor Injection ile dışarıdan verildi.

### 4. SRP (Single Responsibility Principle - Tek Sorumluluk Prensibi)
- **Neden İhlal?:** `SiparisYoneticisi` sınıfı; sepet tutarı hesaplama, stok yönetimi, ödeme alma, veri kaydetme, fatura kesme, e-posta ve SMS atma gibi birbiriyle alakasız birçok işi tek başına yapıyordu.
- **Nasıl Çözüldü?:** Fatura, bildirim ve veri saklama işleri kendi servis sınıflarına devredilerek `SiparisYoneticisi` sadece süreç koordinatörü (orkestrasyon) haline getirildi.

### 5. ISP (Interface Segregation Principle - Arayüzlerin Ayrılması Prensibi)
- **Neden İhlal?:** `ISiparisIslemleri` arayüzü, sipariş kaydından SMS ve kargo gönderimine kadar her şeyi zorunlu kılan şişkin ("fat interface") bir arayüzdü.
- **Nasıl Çözüldü?:** Arayüzler küçük ve amaca yönelik arayüzlere (`IVeritabani`, `IBildirimServisi`, `IKargoServisi`, `IFaturaServisi`) bölündü.
