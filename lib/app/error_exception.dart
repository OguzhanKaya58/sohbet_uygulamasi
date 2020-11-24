class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "Email Adresi zaten kullanılıyor. Lütfen farklı bir email giriniz";
        break;
      case "invalid-email":
        return "E-posta adresiniz yanlış biçimlendirilmiş görünüyor.";
        break;
      case "wrong-password":
        return "Şifreniz yanlış.";
        break;
      case "email-already-exists":
        return "Sağlanan e-posta zaten mevcut bir kullanıcı tarafından kullanılıyor. Her kullanıcının benzersiz bir e-postası olmalıdır.";
        break;
      case "user-not-found":
        return "Bu kullanıcı sistemde bulunamadı. Lütfen önce kullanıcı oluşturunuz.";
        break;
      case "account-exists-with-different-credential":
        return "Facebook adresinizdeki mail adersi daha önce gmail yada email adresi ile sisteme giriş yapmıştır. Lütfen bu mail adresi ile siteme giriş yapınız";
        break;
      case "claims-too-large":
        return "SetCustomUserClaims () için sağlanan talep yükü, izin verilen maksimum 1000 baytı aşıyor.";
        break;
      case "id-token-expired":
        return "Sağlanan Firebase ID jetonunun süresi doldu.";
        break;
      case "id-token-revoked":
        return "Firebase ID jetonu iptal edildi.";
        break;
      case "insufficient-permission":
        return "Admin SDK'yı başlatmak için kullanılan kimlik bilgilerinin, istenen Kimlik Doğrulama kaynağına erişim için yeterli izni yok. Uygun izinlere sahip bir kimlik bilgisinin nasıl oluşturulacağına ve Yönetici SDK'larının kimlik doğrulamasında nasıl kullanılacağına ilişkin belgeler için Firebase projesi kurma bölümüne bakın.";
        break;
      case "internal-error":
        return "Kimlik Doğrulama sunucusu, isteği işlemeye çalışırken beklenmeyen bir hatayla karşılaştı. Hata mesajı, ek bilgiler içeren Kimlik Doğrulama sunucusundan gelen yanıtı içermelidir. Hata devam ederse, lütfen sorunu Hata Raporu destek kanalımıza bildirin.";
        break;
      case "invalid-argument":
        return "Geçersiz argüman.";
        break;
      case "invalid-argument":
        return "Bir Kimlik Doğrulama yöntemine geçersiz bir bağımsız değişken sağlandı.";
        break;
      case "invalid-claims":
        return "SetCustomUserClaims () için sağlanan özel talep öznitelikleri geçersiz.";
        break;
      case "invalid-continue-uri":
        return "Devam URL'si geçerli bir URL dizesi olmalıdır.";
        break;
      default:
        return "Hata!!";
    }
  }
}
