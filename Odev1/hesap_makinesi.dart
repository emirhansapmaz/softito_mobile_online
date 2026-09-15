// Öğrenci Projesi - Basit Hesap Makinesi

// [feature/toplama-gelistirme]: Toplama işlemi özelleştirildi
int islemYap(int a, int b) {
  print("Toplama işlemi yapılıyor...");
  return a + b;
}

void main() {
  print("Hesap Makinesi Uygulaması Başlatıldı");
  print("Sonuç: ${islemYap(10, 5)}");
}
