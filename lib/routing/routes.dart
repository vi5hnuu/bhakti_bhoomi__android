class Route{
  Route({required this.name, required this.path, this.baseUrl="",String? fullPath}):fullPath=fullPath ?? "$baseUrl${path.startsWith("/") ? "":"/"}$path";

  String name;
  String path;
  String baseUrl;
  String fullPath;
}

class Routing {
  static final Route aboutUs = Route(name:"aboutUs",path:"/about-us");
  static final Route createPost = Route(name:"createPost",path:"/admin/create-post");

  static final Route profile = Route(name:"profile",path:"profile",baseUrl: "/auth");
  static final Route verify = Route(name:"verify",path:"verify",baseUrl: "/auth");

  static final Route home = Route(name:"home",path:"/home");
  static final Route login = Route(name:"login",path:"login",baseUrl: "/auth");

  static final Route forgotPassword = Route(name:"forgot-password",path:"forgot-password",baseUrl: "/auth");
  static final Route otp = Route(name:"otp",path:"otp/:usernameEmail",baseUrl: "/auth");

  static final Route splash = Route(name:"splash",path:"/splash");
  static final Route register = Route(name:"register",path:"register",baseUrl: "/auth");
  static final Route updatePassword = Route(name:"update-password",path:"update-password",baseUrl: "/auth");

  static final Route aartiInfo = Route(name:"aarti-info",path:"all/info",baseUrl:'/aarti');
  static final Route aarti = Route(name:"aarti",path:":id",baseUrl:'/aarti');
  //TODO: define base urls for all below routes

  static final Route brahmasutraChaptersInfo = Route(name:"brahmasutra-chapters-info",path:"chapters-info",baseUrl: '/brahma-sutra');
  static final Route brahmasutraQuatersInfo = Route(name:"brahmasutra-quaters-info",path:"chapter/:chapterNo/quaters/info",baseUrl: '/brahma-sutra');
  static final Route brahmasutra = Route(name:"brahmasutra",path:"chapter/:chapterNo/quater/:quaterNo/sutras",baseUrl: '/brahma-sutra');

  static final Route chalisaInfo = Route(name:"chalisa-info",path:"all/info",baseUrl: '/chalisa');
  static final Route chalisa = Route(name:"chalisa",path:":chalisaId",baseUrl: '/chalisa');

  static final Route chanakyaNitiChapters = Route(name:"chanakya-niti-chapters",path:"chapters/info",baseUrl: '/chanakya-neeti');
  static final Route chanakyaNitiChapterShlok = Route(name:"chanakya-niti-chapter-shlok",path:"chapter/:chapterNo/shloks",baseUrl: '/chanakya-neeti');

  static final Route mahabharatBookInfos = Route(name:"mahabharat-book-info",path:"all/books/info",baseUrl: '/mahabharat');
  static final Route mahabharatBookChaptersInfos = Route(name:"mahabharat-book-chapters-info",path:"book/:bookNo/chapters",baseUrl: '/mahabharat');
  static final Route mahabharatBookChapterShloks = Route(name:"mahabharat-book-chapter-shloks",path:"book/:bookNo/chapter/:chapterNo/shloks",baseUrl: '/mahabharat');

  static final Route mantraInfo = Route(name:"mantra-info",path:"mantra-info",baseUrl: '/mantra');
  static final Route mantra = Route(name:"mantra",path:"mantra/:mantraId",baseUrl: '/mantra');

  static final Route ramcharitmanasInfo = Route(name:"ramcharitmanas-info",path:"info",baseUrl: '/ramcharitmanas');
  static final Route ramcharitmanasMangalaCharan = Route(name:"ramcharitmanas-mangalacharan",path:"kand/:kand/mangalacharan",baseUrl: '/ramcharitmanas');
  static final Route ramcharitmanasKandVerses = Route(name:"ramcharitmanas-kand-verses",path:"kand/:kand/verses",baseUrl: '/ramcharitmanas');

  static final Route rigvedaMandalasInfo = Route(name:"rigveda-mandalas-info",path:"mandalas-info",baseUrl: '/rig-veda');
  static final Route rigvedaMandalaSuktas = Route(name:"rigveda-mandala-suktas",path:"mandala/:mandala/suktas",baseUrl: '/rig-veda');

  static final Route valmikiRamayanKandsInfo = Route(name:"valmiki-ramayan-info",path:"info",baseUrl: '/valmiki-ramayan');
  static final Route valmikiRamayanSargasInfo = Route(name:"valmiki-ramayan-kand-sargas-info",path:"kand/:kand/sargas",baseUrl: '/valmiki-ramayan');
  static final Route valmikiRamayanShlok = Route(name:"valmiki-ramayan-kand-sarga-shlok",path:"kand/:kand/sarga/:sargaNo",baseUrl: '/valmiki-ramayan');

  static final Route bhagvadGeetaChapters = Route(name:"bhagvad-geeta-chapters",path:"chapters",baseUrl: '/bhagvad-geeta');
  static final Route bhagvadGeetaChapterShloks = Route(name:"bhagvad-geeta-Shlok",path:"chapter/:chapterNo/shloks",baseUrl: '/bhagvad-geeta');

  static final Route yogaSutraChapters = Route(name:"yoga-sutra-chapters",path:"all/info",baseUrl: '/yoga-sutra');
  static final Route yogaSutra = Route(name:"yoga-sutra-sutras",path:"chapter/:chapterNo",baseUrl: '/yoga-sutra');

  static final Route vratKathaInfo = Route(name:"vrat-katha-infos",path:"all/info",baseUrl: '/vrat-katha');
  static final Route vratKatha = Route(name:"vrat-katha",path:":kathaId",baseUrl: '/vrat-katha');

  static final Route guruGranthSahibInfo = Route(name:"guru-granth-sahib_info",path:"info",baseUrl: '/guru-granth-sahib');
  static final Route guruGranthSahibRagaParts= Route(name:"guru-granth-sahib_raga_parts",path:"raga_parts/raga-no/:ragaNo",baseUrl: '/guru-granth-sahib');
}
