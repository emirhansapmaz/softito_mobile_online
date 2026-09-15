GÖREV 1:
BAŞLA
Kullanıcı uygulamayı açar

EĞER kullanıcı giriş yapmamış İSE
    Kullanıcıyı "Giriş Ekranı"na yönlendir
    DÖNGÜYÜ BİTİR
DEĞİLSE
    Kullanıcı ürünleri seçer ve sepete ekler
    Kullanıcı "Siparişi Onayla" butonuna tıklar
    
    EĞER cüzdan bakiyesi < sepet tutarı İSE
        Kullanıcıya "Bakiye Yükle" uyarısı ver
    DEĞİLSE
        Cüzdan bakiyesinden sepet tutarını düş
        Arka planda sunucuya sipariş paketini gönder
        Kullanıcıya "Sipariş Başarılı" mesajı göster
BİTİR

GÖREV2:
Sipariş Oluşturma Endpoint'i
HTTP Metodu: POST
URL / Endpoint: /api/v1/siparisler
Header:
Authorization: Bearer <token>
Content-Type: application/json
Örnek Request Body:
{
  "kahve_adi": "Filtre Kahve",
  "boyut": "Venti",
  "adet": 2,
  "toplam_tutar": 180.00
}
Sunucuda Beklenmeyen Hata Çıkarsa Dönecek Durum Kodu: 500 Internal Server Error

GÖREV3:
Single Responsibility Principle (SRP) İhlali:
Bu sınıf tek bir iş yapmak yerine; fiyat hesaplama, tahsilat yapma, veritabanına bağlanma ve SMS gönderme gibi birbirinden tamamen bağımsız 4 farklı sorumluluğu aynı anda üstlenerek SRP'yi ihlal etmiştir. Bu yapıyı SiparisHesaplamaServisi, OdemeServisi, VeritabaniServisi ve BildirimServisi olmak üzere 4 küçük ve bağımsız sınıfa bölmeliyiz.
Open/Closed Principle (OCP) İhlali:
Yeni bir müşteri tipi ("DOKTOR") eklendiğinde, var olan indirimHesapla fonksiyonunun içindeki if-else bloklarını açıp kodu değiştirmek zorunda kalmak, sınıfın "gelişime açık, değişime kapalı" (Open/Closed) olma kuralına doğrudan aykırıdır.
