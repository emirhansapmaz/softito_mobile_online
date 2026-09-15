// Öğrenci Projesi - Basit Hesap Makinesi (Ödev 1)

/*
 * ============================================================================
 * MERGE CONFLICT (ÇAKIŞMA) OLUŞUMU VE ÇÖZÜMÜ AÇIKLAMASI:
 * ============================================================================
 * 
 * 1. ÇAKIŞMA NASIL OLUŞTU?
 * - 'feature/toplama-gelistirme' ve 'feature/carpma-ekleme' adında iki ayrı feature branch'i açıldı.
 * - Her iki branch üzerinde de aynı dosyanın (hesap_makinesi.dart) aynı satırları farklı işlevlerle değiştirildi.
 * - 'feature/toplama-gelistirme' branch'i main branch'ine sorunsuz birleştirildi (merge).
 * - Hemen ardından 'feature/carpma-ekleme' branch'i merge edilmeye çalışıldığında Git aynı satırlardaki
 *   farklı değişiklikleri otomatik birleştiremedi ve Merge Conflict (çakışma) meydana geldi.
 * 
 * 2. VS CODE VE GITHUB DESKTOP İLE NASIL ÇÖZÜLDÜ?
 * - VS Code üzerinde çakışan dosya açıldığında çakışma blokları (<<<<<<< HEAD, =======, >>>>>>>) görüldü.
 * - VS Code'un sunduğu "Accept Both Changes" (Her İki Değişikliği Kabul Et) seçeneği seçilerek
 *   her iki branch'ten gelen özelliklerin korunması sağlandı.
 * - Kod temizlenerek her iki işlem için ayrı fonksiyonlar (topla ve carp) oluşturuldu ve çakışma etiketleri temizlendi.
 * - Dosya kaydedildikten sonra 'git add Odev1/hesap_makinesi.dart' ve 'git commit' adımlarıyla merge işlemi başarıyla tamamlandı.
 * ============================================================================
 */

// [feature/toplama-gelistirme] branch'inden gelen fonksiyon
int topla(int a, int b) {
  print("Toplama işlemi yapılıyor...");
  return a + b;
}

// [feature/carpma-ekleme] branch'inden gelen fonksiyon
int carp(int a, int b) {
  print("Çarpma işlemi yapılıyor...");
  return a * b;
}

void main() {
  print("=== Hesap Makinesi Uygulaması (Conflict Çözüldü) ===");
  print("Toplama Sonucu (10 + 5): ${topla(10, 5)}");
  print("Çarpma Sonucu (10 * 5): ${carp(10, 5)}");
}
