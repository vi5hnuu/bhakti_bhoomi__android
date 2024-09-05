class Route{
  Route({required this.name,required this.path});
  String name;
  String path;
}

class Routing {
  static final Route aboutUs = Route(name:"aboutUs",path:"/about-us");

  static final Route profile = Route(name:"profile",path:"profile");
  static final Route verify = Route(name:"verify",path:"verify");

  static final Route home = Route(name:"home",path:"/home");
  static final Route login = Route(name:"login",path:"login");

  static final Route forgotPassword = Route(name:"forgot-password",path:"forgot-password");
  static final Route otp = Route(name:"otp",path:"otp/:usernameEmail");

  static final Route splash = Route(name:"splash",path:"/splash");
  static final Route register = Route(name:"register",path:"register");
  static final Route updatePassword = Route(name:"update-password",path:"update-password");

  static final Route aartiInfo = Route(name:"aarti-info",path:"all/info");
  static final Route aarti = Route(name:"aarti",path:":id");

  static final Route brahmasutraChaptersInfo = Route(name:"brahmasutra-chapters-info",path:"chapters-info");
  static final Route brahmasutraQuatersInfo = Route(name:"brahmasutra-quaters-info",path:"chapter/:chapterNo/quaters/info");
  static final Route brahmasutra = Route(name:"brahmasutra",path:"chapter/:chapterNo/quater/:quaterNo/sutras");

  static final Route chalisaInfo = Route(name:"chalisa-info",path:"all/info");
  static final Route chalisa = Route(name:"chalisa",path:":chalisaId");

  static final Route chanakyaNitiChapters = Route(name:"chanakya-niti-chapters",path:"chapters/info");
  static final Route chanakyaNitiChapterShlok = Route(name:"chanakya-niti-chapter-shlok",path:"chapter/:chapterNo/shloks");

  static final Route mahabharatBookInfos = Route(name:"mahabharat-book-info",path:"all/books/info");
  static final Route mahabharatBookChaptersInfos = Route(name:"mahabharat-book-chapters-info",path:"book/:bookNo/chapters");
  static final Route mahabharatBookChapterShloks = Route(name:"mahabharat-book-chapter-shloks",path:"book/:bookNo/chapter/:chapterNo/shloks");

  static final Route mantraInfo = Route(name:"mantra-info",path:"mantra-info");
  static final Route mantra = Route(name:"mantra",path:"mantra/:mantraId");

  static final Route ramcharitmanasInfo = Route(name:"ramcharitmanas-info",path:"info");
  static final Route ramcharitmanasMangalaCharan = Route(name:"ramcharitmanas-mangalacharan",path:"kand/:kand/mangalacharan");
  static final Route ramcharitmanasKandVerses = Route(name:"ramcharitmanas-kand-verses",path:"kand/:kand/verses");

  static final Route rigvedaMandalasInfo = Route(name:"rigveda-mandalas-info",path:"mandalas-info");
  static final Route rigvedaMandalaSuktas = Route(name:"rigveda-mandala-suktas",path:"mandala/:mandala/suktas");

  static final Route valmikiRamayanKandsInfo = Route(name:"valmiki-ramayan-info",path:"info");
  static final Route valmikiRamayanSargasInfo = Route(name:"valmiki-ramayan-kand-sargas-info",path:"kand/:kand/sargas");
  static final Route valmikiRamayanShlok = Route(name:"valmiki-ramayan-kand-sarga-shlok",path:"kand/:kand/sarga/:sargaNo");

  static final Route bhagvadGeetaChapters = Route(name:"bhagvad-geeta-chapters",path:"chapters");
  static final Route bhagvadGeetaChapterShloks = Route(name:"bhagvad-geeta-Shlok",path:"chapter/:chapterNo/shloks");

  static final Route yogaSutraChapters = Route(name:"yoga-sutra-chapters",path:"all/info");
  static final Route yogaSutra = Route(name:"yoga-sutra-sutras",path:"chapter/:chapterNo");

  static final Route vratKathaInfo = Route(name:"vrat-katha-infos",path:"all/info");
  static final Route vratKatha = Route(name:"vrat-katha",path:":kathaId");

  static final Route guruGranthSahibInfo = Route(name:"guru-granth-sahib_info",path:"info");
  static final Route guruGranthSahibRagaParts= Route(name:"guru-granth-sahib_raga_parts",path:"raga_parts/raga-no/:ragaNo");
}
