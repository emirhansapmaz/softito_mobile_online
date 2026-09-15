// Öğrenci Projesi - Basit Hesap Makinesi

// [feature/carpma-ekleme]: Çarpma işlemi olarak değiştirildi
int islemYap(int a, int b) {
  print("Çarpma işlemi yapılıyor...");
  return a * b;
}

void main() {
  print("Hesap Makinesi Uygulaması Başlatıldı");
  print("Sonuç: ${islemYap(10, 5)}");
}
