// 1. Enumları (derleme zamanı güvenliği; yazım hatalarını engellemek için)
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }

enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }

enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }

// Danışan (müşteri) Modeli
class Danisan {
  final String id;
  final String adSoyad;
  final String telefon;
  final bool vipUyeMi;
  final List<String> alerjiler; // boş olabilir ama null olamaz!
  final String? ozelCiltNotu; // opsiyonel null olabilir

  const Danisan({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    this.vipUyeMi = false,
    this.alerjiler = const [],
    this.ozelCiltNotu,
  });

  bool get hassasCiltMi =>
      alerjiler.isNotEmpty; // boş değilse true olacak, boşsa false olacak.

  // Bilgi Özet Kartı
  String get bilgiOzeti {
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı alerji yok"
        : "Alerjiler: ${alerjiler.join(", ")}";
    final String notBilgisi = ozelCiltNotu ?? "Özel Medikal Not girilmemiş";
    final String vipRozeti = vipUyeMi ? "VIP" : "Standart";
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (Randevu) Modeli
class SeansKaydi {
  final String seansKodu;
  final Danisan danisan;
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani; // örn 10.0
  final String? sorumluUzman;
  SeansDurumu durum;
  OdemeYontemi? odemeTipi;

  SeansKaydi({
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1,
    this.indirimOrani = 0.0,
    this.sorumluUzman,
    this.durum = SeansDurumu.bekliyor,
    this.odemeTipi,
  });

  double get brutTutar => birimFiyat * seansSayisi;

  double get indirimTutari {
    double toplamOran = indirimOrani;
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }
    return brutTutar * (toplamOran / 100.0);
  }

  double get netTutar => brutTutar - indirimTutari;
}

// Yönetim Servisi

class KlinikYoneticisi {
  final String subeAdi;
  final List<SeansKaydi> _seanslar = [];
  final Map<String, Danisan> _danisanRehberi = {};

  KlinikYoneticisi({required this.subeAdi});

  // Danışan kaydetme
  void danisanKaydet(Danisan danisan) {
    _danisanRehberi[danisan.id] = danisan;
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VIP" : "Standart"})",
    );
  }

  void randevuOlustur(SeansKaydi seans) {
    _seanslar.add(seans);
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.tamamlandi;
        seans.odemeTipi = odeme;
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
      }
    }
    print("Hata [$seansKodu] kodlu seans bulunamadı");
  }

  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.iptalEdildi;
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        return;
      }
    }
  }

  // Finansal Rapor Metotları (fonksiyonel dart)
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi)
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  double get beklenenPotansiyelCiro => _seanslar
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Kategori Bazlı Seans Sayıları
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};
    for (var kat in HizmetKategorisi.values) {
      dagilim[kat] = 0;
    }
    for (var s in _seanslar) {
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    return dagilim;
  }

  Set<String> gorevliUzmanKadrosu() {
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  // Uzmansız Kalan Seanslar
  List<SeansKaydi> uzmansizSeanslar() {
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  // Gün Sonu Raporu

  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi");
    print("----------------------------------------------------------------");
    print(
      "${'Kod'.padRight(10)} | "
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    print("----------------------------------------------------------------");

    for (var s in _seanslar) {
      final String uzman = s.sorumluUzman ?? "Nöbetçi Bekliyor";
      final String durumRozet = switch (s.durum) {
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }

    print("----------------------------------------------------------------");
    print("Finansal Özet:");
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    print(
      " * Bekleyen Potansiyel Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    print(" * Toplam Seans : ${_seanslar.length} Randevu");
    print("----------------------------------------------------------------");
    print("Aktif Uzmanlar");
    final uzmanlar = gorevliUzmanKadrosu();
    if (uzmanlar.isEmpty) {
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      print(" ${uzmanlar.join(', ')}");
    }
    final uzmansizlar = uzmansizSeanslar();
    if (uzmansizlar.isNotEmpty) {
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      for (var u in uzmansizlar) {
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("----------------------------------------------------------------");

  }

}

 void main() {
    print("Klinik yönetim sistemi başlatılıyor...");
  }

