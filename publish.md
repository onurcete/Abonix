# ABONIX - Google Play Yayın Hazırlık Rehberi

Bu dosya ABONIX uygulamasını Google Play Store'a yayınlamaya hazırlanmak için uçtan uca kontrol listesidir. Amaç, işi küçük ve takip edilebilir adımlara bölmek: önce yerel Flutter/Android hazırlığı, sonra Play Console kurulumu, test kanalları ve en sonunda production release.

> Not: Bu proje Expo/EAS projesi değil, Flutter projesidir. Bu yüzden `app.json`, `eas.json`, `eas build`, `eas submit` gibi Expo adımları kullanılmaz. Bu projede karşılıkları `pubspec.yaml`, `android/app/build.gradle.kts`, Android signing ayarları ve `puro -e stable flutter ...` komutlarıdır.

## 0) Mevcut Durum Özeti

- [ ] Google Play Console hesabı aktivasyonu tamamlanacak.
  - Hesap aktivasyonu için Google gerçek bir Android cihaz doğrulaması istiyor.
  - Cihaz temin edilince Play Console mobil uygulaması / doğrulama akışı tamamlanmalı.
- [x] Proje Flutter ile geliştiriliyor.
  - Çalıştırma komutu:
    ```powershell
    cd c:\Projects\Abonix
    puro -e stable flutter run
    ```
- [x] Uygulama adı: `ABONIX`.
- [x] Mevcut `pubspec.yaml` sürümü: `1.0.0+1`.
  - `1.0.0`: kullanıcının gördüğü sürüm adı.
  - `+1`: Android `versionCode`; Google Play'e her yeni yüklemede artmalı.
- [x] Launcher icon ve splash için config var:
  - `flutter_launcher_icons`
  - `flutter_native_splash`
  - `assets/branding/app_icon.png`
  - `assets/branding/splash_logo.png`
  - `assets/branding/app_icon.png` ve `assets/branding/splash_logo.png` mevcut logodan oluşturuldu.
- [ ] Kritik teknik eksikler:
  - `android/app/build.gradle.kts` içinde `applicationId` ve `namespace` `com.onurc.abonix` olarak güncellendi.
  - Release build şu anda debug signing kullanıyor.
  - Production için upload keystore ve release signing ayarı yapılmalı.

## 1) Yayın Öncesi Ana Kararlar

### 1.1 Paket adı / Application ID

Google Play'de ilk upload yapılmadan önce paket adı kesinleşmelidir. Paket adı yayınlandıktan sonra aynı uygulama için değiştirilemez; değişirse Play Store bunu bambaşka uygulama sayar.

- [x] Production package name seç: `com.onurc.abonix`.

Öneriler:

- `com.onurc.abonix`
- `com.abonix.tracker`
- `com.onurc.abonixtracker`

Dikkat:

- `com.example.abonix_tracker` kesinlikle production için uygun değil.
- Paket adında alt çizgi kullanmamak daha temizdir.
- Paket adı küçük harf, nokta ayrımlı ve kalıcı olmalı.
- Eğer ileride şirket/domain alınacaksa domain ile uyumlu seçmek iyi olur.

Değiştirilecek yerler:

- [x] `android/app/build.gradle.kts`
  - `namespace = "..."`
  - `applicationId = "..."`
- [x] Android package klasörü gerekiyorsa taşınabilir:
  - `android/app/src/main/kotlin/...`
  - Mevcut Flutter projelerinde bazen Kotlin package yolu ile `applicationId` birebir aynı olmak zorunda değildir, ama düzenli olması için güncellenmesi tercih edilir.

### 1.2 Uygulama adı

- [ ] Store adı netleştir.
  - Öneri: `ABONIX`
  - Alternatif: `ABONIX - Subscription Tracker`
- [ ] Android label kontrolü:
  - `android/app/src/main/AndroidManifest.xml`
  - Şu an:
    ```xml
    android:label="ABONIX"
    ```

### 1.3 Ücretli / ücretsiz kararları

- [ ] İlk sürüm ücretsiz mi olacak?
  - Öneri: ücretsiz.
- [ ] Reklam olacak mı?
  - Şu an uygulamada reklam yok.
  - Play Console "Ads" beyanında "No ads" seçilebilir.
- [ ] Uygulama içi satın alma / abonelik olacak mı?
  - Şu an yok.
  - İleride premium özellik eklenirse Play Billing entegrasyonu gerekir.

## 2) Asset ve Görsel Hazırlık

### 2.1 Uygulama icon ve splash

Mevcut config:

- `pubspec.yaml`
  - `flutter_launcher_icons`
  - `flutter_native_splash`

Kontrol listesi:

- [x] `assets/branding/app_icon.png` dosyasının yüksek çözünürlüklü ve net olduğunu kontrol et.
- [x] `assets/branding/splash_logo.png` dosyasının açık/koyu zeminde okunabilir olduğunu kontrol et.
- [x] Android adaptive icon için arka plan rengi uygun mu kontrol et:
  - Şu an `#F7F7F5`.
- [x] Icon üret:
  ```powershell
  cd c:\Projects\Abonix
  puro -e stable flutter pub run flutter_launcher_icons
  ```
- [x] Splash üret:
  ```powershell
  cd c:\Projects\Abonix
  puro -e stable flutter pub run flutter_native_splash:create
  ```
- [x] Uygulamayı temiz kurulumla açıp icon ve splash'i kontrol et.
  - 2026-04-25: Uygulama `com.onurc.abonix` paketiyle emülatörden kaldırılıp temiz kurulumla yeniden açıldı. Icon/splash kullanıcı tarafından görsel olarak onaylandı.

### 2.2 Play Store görselleri

Google Play Store listing için hazırlanacak görseller:

- [ ] App icon: 512 x 512 PNG.
  - Alpha kabul edilmezse düz arka planlı sürüm hazırlamak gerekebilir.
- [ ] Feature graphic: 1024 x 500 PNG/JPG.
  - ABONIX logosu, sade arka plan, kısa mesaj.
  - Üzerinde çok küçük yazı olmamalı.
- [ ] Telefon screenshots.
  - En az 2 gerekir, pratikte 5-8 adet önerilir.
  - Önerilen ekranlar:
    - Ana sayfa, toplam harcama ve abonelik listesi.
    - Abonelik ekleme ekranı.
    - Para birimi seçimi / ayarlar.
    - Dark mode ana sayfa.
    - Abonelik detay ekranı.
- [ ] Screenshotlarda kişisel veri görünmemeli.
- [ ] Screenshotlarda test verileri doğal görünmeli:
  - Netflix, YouTube, Spotify gibi marka isimleri kullanılacaksa telif/marka görünürlüğü düşünülmeli.
  - Store listing screenshotlarında gerçek marka logoları kullanmak riskli olabilir; gerekirse generic örnekler tercih edilir.

### 2.3 Marka/telif kontrolü

Uygulamada marka logoları var. Bu, kullanıcı deneyimi için iyi ama yayın öncesi gözden geçirilmeli.

- [ ] Kullanılan tüm marka logo assetlerinin kaynağı ve lisansı kontrol edilecek.
- [ ] Google Play açıklamasında markalarla resmi bir ilişki varmış gibi ifade kullanılmayacak.
- [ ] Gerekirse disclaimer hazırlanacak:
  - "All trademarks are property of their respective owners. ABONIX is not affiliated with these services."
- [ ] Store görsellerinde marka logolarını kullanmak yerine uygulama içi generic örneklerle screenshot almak değerlendirilecek.

## 3) Sürümleme ve Release Notları

### 3.1 `pubspec.yaml` version mantığı

Flutter'da:

```yaml
version: 1.0.0+1
```

- `1.0.0`: `versionName`.
- `1`: `versionCode`.

Kurallar:

- [ ] Google Play'e her yeni AAB upload'ında `+buildNumber` artmalı.
  - İlk release: `1.0.0+1`
  - İkinci upload: `1.0.0+2` veya `1.0.1+2`
- [ ] Reddedilen / taslakta kalan build yerine yeni build upload edilecekse build number yine artmalı.
- [ ] Geriye dönük düşük `versionCode` upload edilemez.

### 3.2 Release notes formatı

- [ ] İlk release için kısa release note yaz.

Öneri:

```text
ABONIX ile aboneliklerinizi, yenileme tarihlerini ve harcamalarınızı tek yerden takip edin.
İlk sürüm: abonelik ekleme/düzenleme, para birimi seçimi, tema ve dil ayarları.
```

- [ ] İlerisi için `CHANGELOG.md` oluşturma kararı ver.
  - Şimdilik şart değil.
  - İlk production sonrası düzenli sürüm takibi için iyi olur.

## 4) Android Teknik Hazırlık

### 4.1 Package name değişikliği

Dosya:

- `android/app/build.gradle.kts`

Mevcut:

```kotlin
namespace = "com.example.abonix_tracker"
applicationId = "com.example.abonix_tracker"
```

Yapılacak:

- [x] Yeni paket adı seçilecek.
- [x] `namespace` güncellenecek.
- [x] `applicationId` güncellenecek.
- [x] Uygulama temiz build edilecek.

Komut:

```powershell
cd c:\Projects\Abonix
puro -e stable flutter clean
puro -e stable flutter pub get
puro -e stable flutter run
```

### 4.2 Target SDK / compile SDK

Google Play gereksinimi:

- Yeni app ve app update upload için hedef Android 15 / API 35 veya üzeri gerekir.
- Proje şu an Flutter'ın sağladığı `flutter.compileSdkVersion` ve `flutter.targetSdkVersion` değerlerini kullanıyor.

Kontrol listesi:

- [ ] Puro stable Flutter sürümünün target/compile SDK değerleri kontrol edilecek:
  ```powershell
  cd c:\Projects\Abonix
  puro -e stable flutter doctor -v
  ```
- [ ] Gerekirse Android SDK 35 kurulacak.
- [ ] Gerekirse `android/app/build.gradle.kts` içinde açıkça ayarlanacak:
  ```kotlin
  compileSdk = 35
  targetSdk = 35
  ```
- [ ] Değişiklik sonrası debug ve release build test edilecek.

Not:

- Flutter sürümü eskiyse API 35 hedeflemek için Flutter/Puro stable güncellemesi gerekebilir.
- SDK değişikliği sonrası plugin uyumluluğu kontrol edilmeli.

### 4.3 Minimum SDK

Şu an:

```kotlin
minSdk = flutter.minSdkVersion
```

Kontrol listesi:

- [ ] `flutter.minSdkVersion` mevcut pluginler için yeterli mi kontrol et.
- [ ] Eğer Google Play veya plugin uyarısı çıkarsa `minSdk` manuel güncellenebilir.
- [ ] Minimum SDK yükseltilirse eski cihaz desteği azalır.

## 5) Release Signing / Keystore

Debug key ile production release yapılmamalı. Google Play için upload key oluşturulmalı.

### 5.1 Upload keystore oluşturma

Örnek komut:

```powershell
keytool -genkey -v `
  -keystore "$env:USERPROFILE\upload-keystore-abonix.jks" `
  -storetype JKS `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias upload
```

Sorulacak bilgiler:

- Keystore password.
- Key password.
- Ad/soyad veya şirket.
- Organizational unit.
- Organization.
- City.
- State.
- Country code: `TR`.

Kontrol listesi:

- [x] Keystore oluştur.
- [ ] Şifreleri güvenli bir parola yöneticisine kaydet.
- [ ] `upload-keystore-abonix.jks` dosyasını yedekle.
- [x] Keystore dosyasını Git'e commit etme.
- [x] `key.properties` dosyasını Git'e commit etme.

### 5.2 `key.properties`

Örnek dosya:

```properties
storePassword=BURAYA_STORE_PASSWORD
keyPassword=BURAYA_KEY_PASSWORD
keyAlias=upload
storeFile=C:\\Users\\onurc\\upload-keystore-abonix.jks
```

Kontrol listesi:

- [x] `android/key.properties` oluştur.
  - Taslak dosya oluşturuldu ve `CHANGE_ME_STORE_PASSWORD` / `CHANGE_ME_KEY_PASSWORD` değerleri gerçek şifrelerle değiştirildi.
- [x] `.gitignore` içinde `android/key.properties` ignore ediliyor mu kontrol et.
- [x] Keystore dosyası repo dışında tutulacak.

### 5.3 Gradle signing config

Dosya:

- `android/app/build.gradle.kts`

Yapılacaklar:

- [x] `key.properties` okunacak.
- [x] `signingConfigs.release` tanımlanacak.
- [x] `buildTypes.release.signingConfig` debug yerine release config'e bağlanacak.

Eski riskli durum:

```kotlin
release {
    signingConfig = signingConfigs.getByName("debug")
}
```

Bu production öncesi değiştirildi. Release build artık `signingConfigs.release` kullanıyor; gerçek imza için `android/key.properties` ve upload keystore oluşturulmalı.

### 5.4 Play App Signing

Play Console ilk release yüklemesinde Play App Signing zorunlu/standart akıştır.

- [ ] Play App Signing etkinleştirilecek.
- [ ] Upload key ile AAB yüklenecek.
- [ ] Google app signing key'i yönetecek.
- [ ] Upload key güvenli saklanacak.

## 6) Yerel Kalite Kontrolleri

### 6.1 Kod analizi

```powershell
cd c:\Projects\Abonix
puro -e stable flutter analyze
```

- [x] Analyze temiz.
- [x] Kritik warning yok.

### 6.2 Testler

```powershell
cd c:\Projects\Abonix
puro -e stable flutter test
```

- [x] Unit/widget testler geçiyor.
- [x] Varsa kırılan testler düzeltiliyor.

### 6.3 Manuel smoke test

Debug veya release modda test edilecek temel akışlar:

- [x] Uygulama temiz kurulumda açılıyor.
- [x] Splash ve icon doğru.
- [x] Ana sayfa boş state doğru.
- [x] Abonelik ekleme çalışıyor.
- [x] Abonelik adı öneri listesinden seçilebiliyor.
- [x] Fiyat girişi çalışıyor.
- [x] Para birimi seçimi çalışıyor.
- [x] Tercih edilen para birimi ayarlardan değişiyor.
- [x] Yeni abonelikte varsayılan para birimi ayardan geliyor.
- [x] Abonelik düzenleme çalışıyor.
- [x] Abonelik silme çalışıyor.
- [x] SQLite kalıcılık: uygulama kapanıp açılınca kayıtlar duruyor.
- [x] Tema değişimi: açık/koyu/sistem.
- [x] Dil değişimi: TR/EN.
- [x] Ana sayfa animasyonları takılmadan çalışıyor.
- [x] Yaklaşan ödemeler ve tüm abonelikler kartları düzgün görünüyor.
- [x] Dar ekran ve farklı cihaz boyutlarında taşma yok.
- [x] Android geri tuşu davranışı normal.

### 6.4 Release mod smoke test

```powershell
cd c:\Projects\Abonix
puro -e stable flutter run --release
```

- [x] Release modda uygulama açılıyor.
- [x] Debug modda görünmeyen crash yok.
- [x] Performans kabul edilebilir.
- [x] Animasyonlarda belirgin jank yok.

## 7) Release AAB Üretimi

Google Play için APK değil AAB kullanılacak.

Komut:

```powershell
cd c:\Projects\Abonix
puro -e stable flutter build appbundle --release
```

Beklenen çıktı:

```text
build/app/outputs/bundle/release/app-release.aab
```

Kontrol listesi:

- [x] Build başarılı.
  - 2026-04-25 denemesi: `bundleRelease` çalıştı, ancak `Release app bundle failed to strip debug symbols from native libraries` hatasıyla durdu. `flutter doctor -v` ayrıca Android `cmdline-tools` eksik ve Android license status unknown uyarısı verdi. AAB oluşmadı.
- [x] AAB dosyası oluştu.
- [x] Dosya boyutu makul.
  - 2026-04-25 başarılı build: `build/app/outputs/bundle/release/app-release.aab` oluşturuldu, boyut `45.2MB`.
- [x] Play Console upload öncesi `versionCode` doğru.
- [x] Release signing doğru.

Opsiyonel kontrol:

- [ ] Play Console'a upload edince "App bundle explorer" üzerinden generated APK'lar kontrol edilecek.
- [ ] Uygun cihazlarda destekleniyor mu bakılacak.

## 8) Privacy Policy ve Veri Envanteri

ABONIX verileri ağırlıklı olarak yerelde tutar. Yine de Play Console Data Safety ve privacy policy için açık beyan gerekir.

### 8.1 Uygulamada işlenen veriler

Muhtemel yerel veriler:

- Abonelik adı.
- Fiyat.
- Para birimi.
- Yenileme tarihi.
- Kategori.
- Hatırlatıcı açık/kapalı bilgisi.
- Dil ve tema tercihi.
- Tercih edilen para birimi.

Şu anki teknik durum:

- [x] Kullanıcı hesabı yok.
- [x] Sunucuya veri gönderimi yok.
- [x] Analytics yok.
- [x] Reklam SDK'sı yok.
- [x] Abonelik verileri cihazdaki SQLite / SharedPreferences içinde saklanıyor.

Data Safety yaklaşımı:

- Eğer hiçbir veri cihaz dışına çıkmıyorsa:
  - "Data collected": No.
  - "Data shared": No.
- Eğer ileride analytics, crash reporting, ads, cloud backup eklenirse bu beyan güncellenmeli.

### 8.2 Privacy policy URL

Play Console çoğu durumda privacy policy ister; özellikle kişisel/veri beyanları için hazır olması iyi olur.

- [x] Privacy policy metni hazırlanacak.
- [x] Online ve herkese açık URL'ye koyulacak.
  - Taslak dosya: `PRIVACY.md`. İletişim e-postası eklendi.
  - GitHub Pages için yayın dosyaları hazırlandı: `docs/index.html` ve `docs/privacy.html`.
  - Proje GitHub'a aktarıldı: `https://github.com/onurcete/Abonix`.
  - Canlı GitHub Pages URL'si: `https://onurcete.github.io/Abonix/privacy.html`.

Yayınlama seçenekleri:

- GitHub Pages.
- Kişisel web sitesi.
- Basit statik sayfa.

Privacy policy içinde yazılacak başlıklar:

- Uygulama adı ve geliştirici.
- Hangi verilerin cihazda saklandığı.
- Verilerin üçüncü taraflarla paylaşılmadığı.
- Analytics/reklam kullanılmadığı.
- Kullanıcının veriyi uygulama içinden silebileceği veya uygulamayı kaldırarak yerel veriyi kaldırabileceği.
- İletişim e-postası.
- Son güncelleme tarihi.

### 8.3 Finansal veri notu

ABONIX harcama/abonelik takip uygulamasıdır. Bankacılık, kredi, yatırım veya ödeme hizmeti sunmaz.

- [x] Store açıklamasında finansal tavsiye / bankacılık hizmeti izlenimi verilmemeli.
- [x] Privacy policy içinde finansal hesaplara erişilmediği net yazılabilir.
- [ ] Play Console category seçimi yapılırken "Finance" seçilirse finansal uygulama gibi daha hassas incelenebilir; "Productivity" de değerlendirilebilir.

## 9) Store Listing Hazırlığı

### 9.1 Temel bilgiler

- [ ] App name:
  - `ABONIX`
- [ ] Short description:
  - Öneri TR: `Aboneliklerini, yenileme tarihlerini ve harcamalarını kolayca takip et.`
  - Öneri EN: `Track subscriptions, renewal dates, and recurring spending with ease.`
- [ ] Full description hazırlanacak.

TR açıklama taslağı:

```text
ABONIX, aboneliklerini ve tekrar eden ödemelerini sade bir arayüzle takip etmene yardımcı olur.

Netflix, YouTube, Spotify, bulut servisleri veya diğer düzenli ödemelerini tek yerde görebilir; yenileme tarihlerini, fiyatları, para birimlerini ve kategorileri düzenleyebilirsin.

Öne çıkanlar:
- Abonelik ekleme, düzenleme ve silme
- Aylık ve yıllık toplam harcama görünümü
- Yenileme tarihlerini takip etme
- TRY, EUR ve USD para birimi desteği
- Açık/koyu tema
- Türkçe ve İngilizce dil desteği
- Verilerin cihazında yerel olarak saklanması

ABONIX bir bankacılık veya ödeme uygulaması değildir. Finansal hesaplarına bağlanmaz ve ödeme işlemi yapmaz.
```

EN açıklama taslağı:

```text
ABONIX helps you track subscriptions and recurring payments with a clean, simple interface.

Keep Netflix, YouTube, Spotify, cloud services, and other recurring expenses in one place. Manage renewal dates, prices, currencies, and categories with ease.

Highlights:
- Add, edit, and delete subscriptions
- Monthly and yearly spending overview
- Renewal date tracking
- TRY, EUR, and USD currency support
- Light and dark theme
- Turkish and English language support
- Data stored locally on your device

ABONIX is not a banking or payment app. It does not connect to financial accounts or process payments.
```

### 9.2 Kategori ve etiketler

Seçenekler:

- [ ] Finance
  - Artı: Harcama/abonelik takibiyle uyumlu.
  - Eksi: Finansal uygulama gibi daha hassas algılanabilir.
- [ ] Productivity
  - Artı: Takip/organizasyon uygulaması olarak daha sade.
  - Eksi: Harcama yönü daha az görünür.

Öneri:

- İlk değerlendirme: `Finance` veya `Productivity` arasında karar ver.
- Eğer açıklamada "bankacılık/ödeme değil" net yazılırsa Finance kabul edilebilir.

### 9.3 İletişim bilgileri

- [ ] Geliştirici e-postası.
- [ ] Privacy policy URL.
- [ ] Web sitesi varsa ekle.
- [ ] Telefon/adres gerekirse Play Console hesabı ayarlarında tamamla.

### 9.4 Store listing kalite kontrol

- [ ] Anahtar kelime doldurma yapılmayacak.
- [ ] Açıklama yanıltıcı olmayacak.
- [ ] Uygulamada olmayan özellikler yazılmayacak.
- [ ] Screenshotlar gerçek uygulamayı gösterecek.
- [ ] Marka ilişkisi ima edilmeyecek.

## 10) Play Console Uygulama Oluşturma

Play Console aktivasyonu tamamlandıktan sonra:

- [ ] Play Console'a gir.
- [ ] "Create app" seç.
- [ ] App name: `ABONIX`.
- [ ] Default language: Türkçe veya İngilizce seç.
  - Eğer hedef ilk pazar Türkiye ise Türkçe seçilebilir.
  - Global görünüm istenirse İngilizce seçilebilir.
- [ ] App or game: App.
- [ ] Free or paid: Free.
- [ ] Declarations onaylanır.

Sonra Dashboard'daki zorunlu bölümler sırayla tamamlanır.

## 11) Play Console - App Content

Bu bölüm review için kritiktir.

### 11.1 Privacy policy

- [ ] Privacy policy URL girilecek.
- [ ] URL herkese açık ve erişilebilir olmalı.
- [ ] PDF yerine normal web sayfası tercih edilmeli.

### 11.2 Ads

- [ ] Uygulamada reklam yoksa "No, my app does not contain ads" seç.
- [ ] İleride reklam SDK eklenirse bu beyan güncellenmeli.

### 11.3 App access

- [ ] Login yoksa "All functionality is available without special access" seç.
- [ ] Eğer ileride login/özel erişim eklenirse reviewer için test hesabı sağlanmalı.

### 11.4 Content rating

- [ ] Content rating questionnaire doldur.
- [ ] Finansal işlem, kumar, şiddet, kullanıcı içerikleri yoksa düşük yaş derecesi beklenir.
- [ ] Sonuç kaydedilir ve store listing'e uygulanır.

### 11.5 Target audience and content

- [ ] Hedef yaş grubu seç.
- [ ] Öneri: çocukları hedefleme.
  - Örneğin 18+ veya 13+ değerlendirilir.
- [ ] Çocuklara yönelik değilse Families Policy kapsamından kaçınılır.

### 11.6 Data Safety

Şu anki uygulama varsayımı:

- Kullanıcı verisi sunucuya gönderilmiyor.
- Veri cihazda yerel saklanıyor.
- Reklam/analytics yok.

Doldururken dikkat:

- [ ] "Does your app collect or share any of the required user data types?" sorusuna mevcut teknik duruma göre cevap ver.
- [ ] Eğer "collect" Google tanımında cihaz dışına aktarma ise ve uygulama hiçbir veri göndermiyorsa "No" seçilebilir.
- [ ] Eğer crash reporting veya analytics eklenirse:
  - Device identifiers.
  - Diagnostics.
  - App activity.
  - Crash logs.
  - Bunlar ayrıca beyan edilir.
- [ ] Data deletion soruları yerel-only uygulamalarda dikkatle cevaplanır.

### 11.7 Government apps / News apps / Financial features

- [ ] Government app: No.
- [ ] News app: No.
- [ ] Finansal özellik beyanları çıkarsa uygulamanın ödeme/bankacılık yapmadığı net belirtilir.

## 12) Test Kanalları

### 12.1 Internal testing

Amaç: Play Console üzerinden ilk AAB yüklemesini yapıp hızlı smoke test almak.

Adımlar:

- [ ] Test and release > Testing > Internal testing.
- [ ] Tester listesi oluştur.
  - En fazla 100 internal tester.
  - Kendi Google hesabın ve 1-2 güvendiğin kişi eklenebilir.
- [ ] İlk release oluştur.
- [ ] `app-release.aab` yükle.
- [ ] Release notes gir.
- [ ] Review uyarılarını kontrol et.
- [ ] Roll out to internal testing.
- [ ] Opt-in link ile gerçek cihazda yükle.

Kontrol:

- [ ] Play'den gelen build açılıyor.
- [ ] App signing sonrası paket çalışıyor.
- [ ] SQLite ve SharedPreferences normal.
- [ ] Release build crash atmıyor.

### 12.2 Closed testing

Yeni kişisel Play Developer hesapları için production erişiminden önce kapalı test gerekir.

Google'ın resmi şartı:

- En az 12 tester.
- Testerlar opt-in olmuş olmalı.
- En az son 14 gün kesintisiz opt-in kalmış olmalı.
- Production access başvurusu sırasında 12 tester hâlâ opt-in durumda olmalı.

Adımlar:

- [ ] Closed testing track oluştur.
- [ ] Tester listesi oluştur.
  - Email listesi veya Google Group kullanılabilir.
- [ ] 12 yerine güvenlik payı için 15-20 tester hedefle.
- [ ] AAB upload et.
- [ ] Release notes ekle.
- [ ] Review'den sonra opt-in linkini paylaş.
- [ ] Testerların linke tıklayıp opt-in yaptığını doğrula.
- [ ] Testerların uygulamayı gerçek Android cihaza kurduğunu doğrula.
- [ ] 14 gün boyunca opt-in sayısını her gün kontrol et.
- [ ] Tester düşerse yenisini ekle; ama 14 gün şartı kesintisiz sayıldığı için takvim etkilenebilir.

Tester talimatı:

```text
1. Opt-in linkine Google hesabınla gir.
2. Teste katılmayı kabul et.
3. Uygulamayı Play Store üzerinden kur.
4. 14 gün boyunca uygulamayı kaldırma ve testten çıkma.
5. İlk gün birkaç abonelik ekle.
6. Birkaç gün sonra uygulamayı tekrar aç ve kayıtların durduğunu kontrol et.
7. Gördüğün hata veya önerileri geliştiriciye ilet.
```

Test sürecinde toplanacak geri bildirimler:

- [ ] Kurulum sorunu var mı?
- [ ] Uygulama açılışında crash var mı?
- [ ] Abonelik ekleme/düzenleme anlaşılır mı?
- [ ] Para birimi seçimi anlaşılır mı?
- [ ] Tasarım açık/koyu modda okunabilir mi?
- [ ] Performans sorunu var mı?
- [ ] Eksik görülen özellik var mı?

### 12.3 Production access questionnaire

14 gün şartı tamamlandıktan sonra Play Console production access başvurusu yapılır.

Hazırlanacak cevaplar:

- [ ] Uygulama ne yapıyor?
- [ ] Testi nasıl yaptın?
- [ ] Kaç tester katıldı?
- [ ] Testçiler hangi cihazlarda test etti?
- [ ] Hangi feedbackler geldi?
- [ ] Bu feedbacklerden sonra ne düzelttin?
- [ ] Neden production için hazır?

Örnek cevap yaklaşımı:

```text
ABONIX is a subscription tracking app that helps users manage recurring payments, renewal dates, categories, and preferred currencies. During closed testing, testers installed the app from Google Play, added sample subscriptions, edited renewal dates and currencies, tested light/dark themes, and verified that local data persisted after restarting the app. Feedback was used to improve visual contrast, selection behavior, and release readiness. No server-side account or payment functionality is included.
```

## 13) Production Release

Production access açıldıktan sonra:

- [ ] Production track'e git.
- [ ] Yeni release oluştur.
- [ ] Son AAB upload et veya closed test build'ini promote et.
- [ ] Release notes gir.
- [ ] Play Console warnings kontrol et.
- [ ] Countries/regions seç.
  - İlk yayın için Türkiye + seçilen hedef ülkeler.
- [ ] Managed publishing açık mı karar ver.
  - Öneri: ilk yayında managed publishing açık olsun; Google onayladıktan sonra sen manuel yayınlarsın.
- [ ] Staged rollout oranı seç.
  - İlk küçük uygulamada doğrudan %100 olabilir.
  - Daha kontrollü istenirse %10 > %50 > %100.
- [ ] Review'e gönder.

Review süresi:

- Genelde birkaç saat - birkaç gün.
- Yeni hesap/ilk app/policy belirsizliği varsa daha uzun sürebilir.

## 14) Yayın Sonrası Operasyon

### 14.1 Play Console takibi

- [ ] Android vitals kontrol et.
  - Crash rate.
  - ANR rate.
  - Slow startup.
- [ ] User reviews takip et.
- [ ] Store listing conversion metriklerini izle.
- [ ] Device catalog uyarılarını kontrol et.

### 14.2 Crash reporting kararı

Şu an ekstra crash reporting yoksa Google Play Vitals başlangıç için yeterli olabilir.

Seçenekler:

- [ ] Sadece Play Console Vitals ile başla.
- [ ] Firebase Crashlytics ekle.
  - Eklenirse Data Safety ve privacy policy güncellenmeli.
- [ ] Sentry ekle.
  - Eklenirse Data Safety ve privacy policy güncellenmeli.

Öneri:

- İlk yayın için Play Console Vitals yeterli.
- Kullanıcı sayısı artınca Crashlytics/Sentry değerlendir.

### 14.3 Hotfix süreci

Her hotfix için:

- [ ] Hata doğrulanır.
- [ ] Kod düzeltilir.
- [ ] Test edilir.
- [ ] `pubspec.yaml` build number artırılır.
- [ ] Yeni AAB üretilir.
- [ ] Internal testing'e yüklenir.
- [ ] Kritikse production'a hızlı gönderilir.

Örnek:

- Mevcut: `1.0.0+1`
- Hotfix: `1.0.1+2`

## 15) Komut Referansı

### 15.1 Proje çalıştırma

```powershell
cd c:\Projects\Abonix
puro -e stable flutter run
```

### 15.2 Cihazları listeleme

```powershell
cd c:\Projects\Abonix
puro -e stable flutter devices
```

### 15.3 Paketleri alma

```powershell
cd c:\Projects\Abonix
puro -e stable flutter pub get
```

### 15.4 Analyze

```powershell
cd c:\Projects\Abonix
puro -e stable flutter analyze
```

### 15.5 Test

```powershell
cd c:\Projects\Abonix
puro -e stable flutter test
```

### 15.6 Icon üretme

```powershell
cd c:\Projects\Abonix
puro -e stable flutter pub run flutter_launcher_icons
```

### 15.7 Splash üretme

```powershell
cd c:\Projects\Abonix
puro -e stable flutter pub run flutter_native_splash:create
```

### 15.8 Release çalıştırma

```powershell
cd c:\Projects\Abonix
puro -e stable flutter run --release
```

### 15.9 AAB üretme

```powershell
cd c:\Projects\Abonix
puro -e stable flutter build appbundle --release
```

### 15.10 Clean build

```powershell
cd c:\Projects\Abonix
puro -e stable flutter clean
puro -e stable flutter pub get
puro -e stable flutter build appbundle --release
```

## 16) İlk İlerleme Sırası

Önerilen sıra:

- [ ] 1. Play Console aktivasyonu tamamlanana kadar yerel hazırlıkları bitir.
- [x] 2. Package name kararını ver.
- [x] 3. `applicationId` / `namespace` düzelt.
- [x] 4. Release signing kur.
- [x] 5. Icon/splash üretimini tekrar çalıştır.
- [x] 6. Analyze/test/smoke test yap.
- [x] 7. Privacy policy taslağını yaz ve URL'ye koy.
- [ ] 8. Store listing metinlerini ve screenshotları hazırla.
- [x] 9. AAB üret.
- [ ] 10. Play Console'da app oluştur.
- [ ] 11. App Content formlarını doldur.
- [ ] 12. Internal testing'e ilk AAB yükle.
- [ ] 13. Closed testing için testerları organize et.
- [ ] 14. 12 tester / 14 gün şartını tamamla.
- [ ] 15. Production access başvurusu yap.
- [ ] 16. Production release gönder.

## 17) Şu Anda Bekleyen Kritik Kararlar

- [ ] Production package name ne olacak?
  - Öneri: `com.onurc.abonix`
- [ ] İlk kategori ne olacak?
  - Öneri: `Productivity` veya `Finance`.
- [x] Privacy policy nerede yayınlanacak?
  - Seçim: GitHub Pages.
- [ ] Store listing dili önce Türkçe mi İngilizce mi olacak?
  - Öneri: Türkçe + İngilizce çeviri.
- [ ] Crash reporting ilk sürümde eklenecek mi?
  - Öneri: İlk sürümde ekleme; Play Console Vitals ile başla.

## 18) İlk Teknik Adım

İlk uygulanacak teknik adım için öneri:

1. Package name kararını ver.
2. `android/app/build.gradle.kts` içinde `namespace` ve `applicationId` güncelle.
3. Uygulamayı debug modda çalıştır.
4. Sonra release signing kurulumuna geç.

Bu sırayı izlemek iyi olur çünkü package name Play Store tarafında en geri dönüşü zor kararlardan biridir.
