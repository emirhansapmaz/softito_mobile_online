// ============================================================================
// SoftITO Mobil App Developer - Ödev 2: SOLID & Clean Code Refactored
// ============================================================================

/*
 * ----------------------------------------------------------------------------
 * TESPİT EDİLEN SOLID İHLALLERİ VE ÇÖZÜMLERİ
 * ----------------------------------------------------------------------------
 * 1. LSP (Liskov Substitution Principle) İhlali:
 *    - Neden İhlal?: DijitalUrun alt sınıfı kargoUcretiHesapla() metodunda hata fırlatarak (throw Exception)
 *      üst sınıfı Urun'ün yerine geçemiyordu ve sepet döngüsünde programı çökertiyordu.
 *    - Nasıl Çözüldü?: DijitalUrun sınıfı kargo ücretini 0.0 döndürecek şekilde düzenlendi, böylece
 *      tüm ürünler döngüde hata vermeden polimorfik olarak çalışabildi.
 * 
 * 2. OCP (Open/Closed Principle) İhlali:
 *    - Neden İhlal?: odemeYap() metodu içinde if-else bloklarıyla ödeme tipleri kontrol ediliyordu;
 *      yeni bir ödeme tipi eklemek için var olan kodu değiştirmek gerekiyordu.
 *    - Nasıl Çözüldü?: IOdemeYontemi interface'i oluşturuldu ve her ödeme tipi (Kredi Kartı, Havale vb.)
 *      bu interface'i uygulayan bağımsız sınıflara dönüştürüldü.
 * 
 * 3. DIP (Dependency Inversion Principle) İhlali:
 *    - Neden İhlal?: SiparisYoneticisi somut sınıflara (SqliteVeritabani, SmtpMailServisi vb.) sıkı sıkıya bağlıydı
 *      ve bu nesneleri doğrudan kendi içinde 'new' anahtar kelimesiyle oluşturuyordu.
 *    - Nasıl Çözüldü?: Soyut arayüzler (IVeritabani, IBildirimServisi, IKargoServisi) tanımlandı ve
 *      SiparisYoneticisi'ne constructor injection yoluyla dışarıdan verildi.
 * 
 * 4. SRP (Single Responsibility Principle) İhlali:
 *    - Neden İhlal?: SiparisYoneticisi hem veritabanı, hem kargo, hem mail/sms, hem fatura kesme, hem de indirim
 *      hesaplama işlerini tek başına yapıyordu (çok fazla sorumluluk).
 *    - Nasıl Çözüldü?: Her sorumluluk kendi özel servis sınıfına devredildi; SiparisYoneticisi sadece orkestrasyonu sağlar.
 * 
 * 5. ISP (Interface Segregation Principle) İhlali:
 *    - Neden İhlal?: ISiparisIslemleri arayüzü tek başına sipariş, ödeme, kargo, mail, sms ve faturayı içeren devasa bir fat interface'ti.
 *    - Nasıl Çözüldü?: Arayüzler küçük, odaklanmış parçalara bölündü.
 * ----------------------------------------------------------------------------
 */

// ==================== 1. ÜRÜN MODELLERİ (LSP Çözümü) ====================

class Urun {
  final String id;
  final String ad;
  final double fiyat;
  int stok;
  final String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);

  double kargoUcretiHesapla() {
    return 29.90;
  }
}

// LSP'ye Uygun: Üst sınıfın kuralını bozmaz, dijital ürün için kargo ücreti 0 TL döner.
class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");

  @override
  double kargoUcretiHesapla() {
    return 0.0;
  }
}

// ==================== 2. ÖDEME YÖNTEMLERİ (OCP & SRP Çözümü) ====================

abstract class IOdemeYontemi {
  void ode(double tutar);
}

class KrediKartiOdeme implements IOdemeYontemi {
  @override
  void ode(double tutar) {
    print("$tutar TL Kredi kartindan POS ile cekildi.");
  }
}

class HavaleOdeme implements IOdemeYontemi {
  @override
  void ode(double tutar) {
    print("$tutar TL Havale kontrol edildi.");
  }
}

class KapidaOdeme implements IOdemeYontemi {
  @override
  void ode(double tutar) {
    print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
  }
}

class KriptoOdeme implements IOdemeYontemi {
  @override
  void ode(double tutar) {
    print("$tutar TL USDT transferi onaylandi.");
  }
}

// ==================== 3. SOYUT ARAYÜZLER (DIP & ISP Çözümü) ====================

abstract class IVeritabani {
  void siparisKaydet(String orderId, double tutar);
}

abstract class IBildirimServisi {
  void bildirimGonder(String alici, String mesaj);
}

abstract class IKargoServisi {
  void kargoGonder(String orderId, String adres);
}

abstract class IFaturaServisi {
  void faturaKes(String orderId);
}

// ==================== 4. SOMUT SERVİSLER (SRP Çözümü) ====================

class SqliteVeritabani implements IVeritabani {
  @override
  void siparisKaydet(String orderId, double tutar) {
    print("DB calistirildi: INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }
}

class MailBildirimServisi implements IBildirimServisi {
  @override
  void bildirimGonder(String alici, String mesaj) {
    print("SMTP Mail gonderildi ($alici): $mesaj");
  }
}

class SmsBildirimServisi implements IBildirimServisi {
  @override
  void bildirimGonder(String alici, String mesaj) {
    print("SMS iletildi ($alici): $mesaj");
  }
}

class MngKargoServisi implements IKargoServisi {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres (Sipariş: $orderId)");
  }
}

class PdfFaturaServisi implements IFaturaServisi {
  @override
  void faturaKes(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }
}

// ==================== 5. SİPARİŞ YÖNETİCİSİ (DIP & Clean Code) ====================

class SiparisYoneticisi {
  final IVeritabani veritabani;
  final IKargoServisi kargoServisi;
  final IFaturaServisi faturaServisi;
  final IBildirimServisi mailServisi;
  final IBildirimServisi smsServisi;

  // Dependency Injection: Bağımlılıklar dışarıdan enjekte edilir.
  SiparisYoneticisi({
    required this.veritabani,
    required this.kargoServisi,
    required this.faturaServisi,
    required this.mailServisi,
    required this.smsServisi,
  });

  double _kuponIndirimiUygula(double toplam, String kuponKodu) {
    if (kuponKodu == "INDIRIM10") return toplam * 0.90;
    if (kuponKodu == "YAZ20") return toplam * 0.80;
    if (kuponKodu == "SEPETTE50") return toplam - 50;
    return toplam;
  }

  void siparisTamamla({
    required String orderId,
    required List<Urun> sepet,
    required IOdemeYontemi odemeYontemi,
    required String musteriAdi,
    required String email,
    required String tel,
    required String adres,
    String kuponKodu = "",
  }) {
    // 1. Stok kontrolü
    for (var urun in sepet) {
      if (urun.stok <= 0) {
        print("Hata: ${urun.ad} tukenmis!");
        return;
      }
    }

    // 2. Fiyat ve Kargo hesaplama (LSP sayesinde dijital ürün patlamaz)
    double araToplam = 0;
    for (var urun in sepet) {
      araToplam += urun.fiyat;
      araToplam += urun.kargoUcretiHesapla();
      urun.stok--;
    }

    // 3. Kupon ve KDV
    double indirimliTutar = _kuponIndirimiUygula(araToplam, kuponKodu);
    double kdv = indirimliTutar * 0.20;
    double sonTutar = indirimliTutar + kdv;

    // 4. İlgili servislere yetki devri
    odemeYontemi.ode(sonTutar);
    veritabani.siparisKaydet(orderId, sonTutar);
    faturaServisi.faturaKes(orderId);
    mailServisi.bildirimGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsServisi.bildirimGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoServisi.kargoGonder(orderId, adres);

    print(">>> Sipariş (#$orderId) başarıyla tamamlandı! <<<\n");
  }
}

// ==================== 6. MAIN (TEST) ====================

void main() {
  print("=== SOLID & Clean Code Sipariş Sistemi Başlatılıyor ===\n");

  // Servisler oluşturuluyor (Dependency Injection hazırlığı)
  var siparisci = SiparisYoneticisi(
    veritabani: SqliteVeritabani(),
    kargoServisi: MngKargoServisi(),
    faturaServisi: PdfFaturaServisi(),
    mailServisi: MailBildirimServisi(),
    smsServisi: SmsBildirimServisi(),
  );

  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  // Kredi kartı ödeme yöntemi stratejisi ile sipariş tamamlanıyor
  siparisci.siparisTamamla(
    orderId: "SP-9921",
    sepet: sepet,
    odemeYontemi: KrediKartiOdeme(),
    musteriAdi: "Selahaddin",
    email: "selahaddin@kodvance.com",
    tel: "05551112233",
    adres: "Kadikoy / Istanbul",
    kuponKodu: "INDIRIM10",
  );
}
