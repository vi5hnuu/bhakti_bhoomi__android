class Route{
  Route({required this.name,required this.path});
  String name;
  String path;
}

class Routing {
  static final Route aboutUs = Route(name:"aboutUs",path:"/about-us");

  static final Route profile = Route(name:"profile",path:"/profile");
  static final Route verify = Route(name:"verify",path:"/verify");

  static final Route home = Route(name:"home",path:"/home");
  static final Route login = Route(name:"login",path:"/login");

  static final Route forgotPassword = Route(name:"forgot-password",path:"/forgot-password");
  static final Route otp = Route(name:"otp",path:"/otp/:usernameEmail");

  static final Route splash = Route(name:"splash",path:"/splash");
  static final Route register = Route(name:"register",path:"/register");
  static final Route updatePassword = Route(name:"update-password",path:"/update-password");

  static final Route aartiInfo = Route(name:"aarti-info",path:"/aarti-info");
  static final Route aarti = Route(name:"aarti",path:"/aarti/:id");

  static final Route brahmasutraChaptersInfo = Route(name:"brahmasutra-chapters-info",path:"/brahmasutra-chapters-info");
  static final Route brahmasutraQuatersInfo = Route(name:"brahmasutra-quaters-info",path:"/brahmasutra/chapter/:chapterNo/quaters/info");
  static final Route brahmasutra = Route(name:"brahmasutra",path:"/brahmasutra/chapter/:chapterNo/quater/:quaterNo/sutras");

  static final Route chalisaInfo = Route(name:"chalisa-info",path:"/chalisa-info");
  static final Route chalisa = Route(name:"chalisa",path:"/chalisa/:chalisaId");

  static final Route chanakyaNitiChapters = Route(name:"chanakya-niti-chapters",path:"/chanakya-niti-chapters");
  static final Route chanakyaNitiChapterShlok = Route(name:"chanakya-niti-chapter-shlok",path:"/chanakya-niti/chapter/:chapterNo/shloks");

  static final Route mahabharatBookInfos = Route(name:"mahabharat-book-info",path:"/mahabharat-book-info");
  static final Route mahabharatBookChaptersInfos = Route(name:"mahabharat-book-chapters-info",path:"/mahabharat/book/:bookNo/chapters");
  static final Route mahabharatBookChapterShloks = Route(name:"mahabharat-book-chapter-shloks",path:"/mahabharat/book/:bookNo/chapter/:chapterNo/shloks");

  static final Route mantraInfo = Route(name:"mantra-info",path:"/mantra-info");
  static final Route mantra = Route(name:"mantra",path:"/mantra/:mantraId");

  static final Route ramcharitmanasInfo = Route(name:"ramcharitmanas-info",path:"/ramcharitmanas-info");
  static final Route ramcharitmanasMangalaCharan = Route(name:"ramcharitmanas-mangalacharan",path:"/ramcharitmanas/kand/:kand/mangalacharan");
  static final Route ramcharitmanasKandVerses = Route(name:"ramcharitmanas-kand-verses",path:"/ramcharitmanas/kand/:kand/verses");

  static final Route rigvedaMandalasInfo = Route(name:"rigveda-mandalas-info",path:"/rigveda-mandalas-info");
  static final Route rigvedaMandalaSuktas = Route(name:"rigveda-mandala-suktas",path:"/rigveda/mandala/:mandala/suktas");

  static final Route valmikiRamayanKandsInfo = Route(name:"valmiki-ramayan-info",path:"/valmiki-ramayan-info");
  static final Route valmikiRamayanSargasInfo = Route(name:"valmiki-ramayan-kand-sargas-info",path:"/valmiki-ramayan/kand/:kand/sargas");
  static final Route valmikiRamayanShlok = Route(name:"valmiki-ramayan-kand-sarga-shlok",path:"/valmiki-ramayan/kand/:kand/sarga/:sargaNo");

  static final Route bhagvadGeetaChapters = Route(name:"bhagvad-geeta-chapters",path:"/bhagvad-geeta-chapters");
  static final Route bhagvadGeetaChapterShloks = Route(name:"bhagvad-geeta-Shlok",path:"/bhagvad-geeta/chapter/:chapterNo/shloks");

  static final Route yogaSutraChapters = Route(name:"yoga-sutra-chapters",path:"/yoga-sutra-chapters");
  static final Route yogaSutra = Route(name:"yoga-sutra-sutras",path:"/yoga-sutra/chapter/:chapterNo");

  static final Route guruGranthSahibInfo = Route(name:"guru-granth-sahib_info",path:"/guru-granth-sahib_info");
  static final Route guruGranthSahibRagaParts= Route(name:"guru-granth-sahib_raga_parts",path:"/guru-granth-sahib_raga_parts/raga-no/:ragaNo");
}
