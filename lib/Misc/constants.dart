import 'package:flutter/material.dart';

const kUthmaniHafs1FontTextStyle = TextStyle(
  fontFamily: 'UthmanicHafs1',
);

const kUthmaniWarsh1FontTextStyle = TextStyle(
  fontFamily: 'UthmanicWarsh1',
);

const kUthmaniQalun1FontTextStyle = TextStyle(
  fontFamily: 'UthmanicQalun1',
);

//const kMainAppColor01 = Color(0xFF164835);
const kMainAppColor01 = Color(0xFF267EB5);

const kMainQuranLightColor01 = Colors.black;
const kMainQuranDarkColor01 = Colors.white;

//const kMainAppColor02 = Color(0xFFECE4CC);
const kMainAppColor02 = Colors.white;
// const kMainAppColor03 = Color(0xFFD4AF37);
const kMainAppColor03 = Colors.white;
// const kMainAppColor04 = Color(0xFF00FF00);

const kMainAppColor04 = Color(0xFF00003f);
const kMainAppColor05 = Colors.white;
const kMainAppColor06 = Color(0xFFBCA46D);

const kAppBarTitleStyle = TextStyle(color: kMainAppColor03);
const kAppDefaultTextStyle = TextStyle(color: kMainAppColor01);

const kMainCategoriesButtonBorderSide = BorderSide(
  color: kMainAppColor03,
  width: 5,
);

const kButtonTextStyleWhiteAmiriFontNormal = TextStyle(
  // color: Colors.black,
  fontFamily: 'Amiri',
  height: 1,
);

const kHadithButtonTextStyleWhiteScheherazadeFontNormal = TextStyle(
  color: kMainAppColor03,
  fontFamily: 'Scheherazade',
  height: 1,
);

const kButtonTextStyleScheherazadeFontNormal = TextStyle(
  // color: Colors.black,
  fontFamily: 'Scheherazade',
  height: 1,
);

const kTextStyleMe_quranFontNormal = TextStyle(
  // color: Colors.black,
  fontFamily: 'me_quran',
);

const kTextStyleBlackNormal = TextStyle(
  color: Colors.black,
  // fontFamily: 'Scheherazade',
  height: 1.25,
);
const kTextStyleRedNormal = TextStyle(
  color: Colors.red,
  // fontFamily: 'Scheherazade',
  height: 1.25,
);

const kTextDottedStyleNormal = TextStyle(
  fontFamily: 'dotty',
  height: 1,
);

const kButtonTextStyleAmiriFontWhiteBold = TextStyle(
  // color: Colors.white,
  fontFamily: 'Amiri',
  fontWeight: FontWeight.w700,
  height: 1,
);

const kMainLinearGradient = LinearGradient(
  colors: [kMainAppColor01, kMainAppColor01],
  begin: Alignment.bottomCenter,
  end: Alignment.topRight,
);

const kMain02LinearGradient = LinearGradient(
  colors: [kMainAppColor05, kMainAppColor02],
  begin: Alignment.bottomCenter,
  end: Alignment.topRight,
);

const kWeekDaysList = [
  ['الاثنين', 'Mon', 'Monday'],
  ['الثلاثاء', 'Tue', 'Tuesday'],
  ['الأربعاء', 'Wed', 'Wednesday'],
  ['الخميس', 'Thu', 'Thursday'],
  ['الجمعة', 'Fri', 'Friday'],
  ['السبت', 'Sat', 'Saturday'],
  ['الأحد', 'Sun', 'Sunday'],
];

const kPrayersNames = [
  ['الفجر', 'Fajr'],
  ['الشروق', 'Sunrise'],
  ['الظهر', 'Dhuhr'],
  ['العصر', 'Asr'],
  ['المغرب', 'Maghrib'],
  ['العشاء', 'Isha'],
];

const kMainCategoriesNames = [
  ['القرآن', 'The Holy Quran'],
  ['جوامع الدعاء', 'The Pithy Prayers'],
  ['الأذكار', 'The Prayers'],
  ['التفسير', 'The Interpretation'],
  ['الحديث', 'The Hadith'],
  ['التلاوة', 'Reciting Holy Quran'],
];

const kSubCatergoriesNames = [
  ['القبلة', 'The Qibla'],
  ['الإعدادات', 'Settings'],
  ['عنا', 'About us'],
  ['مساعدة', 'Help'],
];

const kMainPrayersNames = [
  "أذكار الصباح",
  "أذكار المساء",
  "أذكار الاستيقاظ من النوم",
  "أذكار النوم",
  "الدعاء إذا تقلب ليلا",
  "دعاء الفزع في النوم و من بلي بالوحشة",
  "دعاء رؤية الهلال",
  "ما يفعل من رأى الرؤيا أو الحلم في النوم",
  "الذكر قبل الوضوء",
  "الذكر بعد الفراغ من الوضوء",
  "دعاء الذهاب إلى المسجد",
  "دعاء دخول المسجد",
  "دعاء الخروج من المسجد",
  "أذكار الآذان",
  "دعاء الاستفتاح", //hena
  "دعاء الركوع",
  "دعاء الرفع من الركوع",
  "دعاء السجود",
  "دعاء الجلسة بين السجدتين",
  "دعاء سجود التلاوة",
  "التشهد",
  "الصلاة على النبي بعد التشهد",
  "الدعاء بعد التشهد الأخير قبل السلام",
  "الأذكار بعد السلام من الصلاة",
  "دعاء صلاة الاستخارة",
  "دعاء قنوت الوتر",
  "الذكر عقب السلام من الوتر",
  "دعاء من أصابه وسوسة في الإيمان",
  "الدعاء لمن قال غفر الله لك",
  "الاستغفار و التوبة",
  "التسبيح، التحميد، التهليل، التكبير",
  "كفارة اﻟﻤﺠلس",
  "الذكر عند الخروج من المنزل",
  "الذكر عند دخول المنزل",
  "دعاء دخول الخلاء - الحمام",
  "دعاء الخروج من الخلاء - الحمام",
  "دعاء لبس الثوب",
  "دعاء لبس الثوب الجديد",
  "ما يقول إذا وضع الثوب",
  "دعاء قضاء الدين",
  "ما يقول ويفعل من أذنب ذنبا",
  "دعاء الريح",
  "دعاء الرعد",
  "من أدعية الاستسقاء",
  "الدعاء إذا نزل المطر",
  "الذكر بعد نزول المطر",
  "الدعاء عند إفطار الصائم - الصوم",
  "الدعاء قبل الطعام",
  "الدعاء عند الفراغ من الطعام",
  "دعاء الضيف لصاحب الطعام",
  "التعريض بالدعاء لطلب الطعام أو الشراب",
  "الدعاء إذا أفطر عند أهل بيت - طعام",
  "ما يقول الصائم إذا سابه أحد",
  "دعاء الصائم إذا حضر الطعام ولم يفطر",
  "الدعاء عند رؤية باكورة الثمر",
  "دعاء العطاس",
  "ما يقال للكافر إذا عطس فحمد الله",
  "الدعاء للمتزوج",
  "دعاء المتزوج و شراء الدابة",
  "الدعاء قبل إتيان الزوجة - الجماع",
  "ما يقال في اﻟﻤﺠلس",
  "ما يقول عند الذبح أو النحر",
  "دعاء التعجب والأمر السار",
  "ما يقول المسلم إذا زكي",
  "الدعاء لمن سببته",
  "كيف يرد السلام على الكافر إذا سلم",
  "الدعاء لمن أقرض عند القضاء",
  "الدعاء لمن عرض عليك ماله",
  "الدعاء لمن قال إني أحبك في الله",
  "الدعاء لمن صنع إليك معروفا",
  "ما يقول المسلم إذا مدح المسلم",
  "ما يفعل من أتاه أمر يسره",
  "ما يعصم الله به من الدجال",
  "فضل الصلاة على النبي صلى الله عليه و سلم",
  "إفشاء السلام",
  "كيف كان النبي يسبح؟",
  "من أنواع الخير والآداب الجامعة",
  "دعاء الركوب",
  "دعاء السفر",
  "دعاء دخول القرية أو البلدة",
  "دعاء دخول السوق",
  "الدعاء إذا تعس المركوب",
  "دعاء المسافر للمقيم",
  "دعاء المقيم للمسافر",
  "التكبير و التسبيح في سير السفر",
  "دعاء المسافر إذا أسحر",
  "الدعاء إذا نزل مترلا في سفر أو غيره",
  "ذكر الرجوع من السفر",
  "كيف يلبي المحرم في الحج أو العمرة ؟",
  "التكبير إذا أتى الركن الأسود",
  "الدعاء بين الركن اليماني والحجر الأسود",
  "دعاء الوقوف على الصفا والمروة",
  "الدعاء يوم عرفة",
  "التكبير عند رمي الجمار مع كل حصاة",
  "الذكر عند المشعر الحرام",
  "دعاء الهم والحزن",
  "دعاء الكرب",
  "دعاء من استصعب عليه أمر",
  "دعاء الغضب",
  "ما يقول من أتاه أمر يسره أو يكرهه",
  "دعاء من رأى مبتلى",
  "الدعاء حينما يقع ما لا يرضاه أو غلب على أمره",
  "ما يقال عند الفزع",
  "ما يقول لرد كيد مردة الشياطين",
  "ما يقول من خاف قوما",
  "الدعاء على العدو",
  "دعاء الوسوسة في الصلاة و القراءة",
  "دعاء طرد الشيطان و وساوسه",
  "ﺗﻬنئة المولود له وجوابه",
  "ما يعوذ به الأولاد - رقية",
  "من أدعية الاستصحاء",
  "دعاء الخوف من الشرك",
  "الدعاء لمن قال بارك الله فيك",
  "دعاء كراهية الطيرة",
  "الدعاء عند سماع صياح الديك ونهيق الحمار",
  "دعاء نباح الكلب بالليل",
  "دعاء لقاء العدو و ذي السلطان",
  "دعاء من خاف ظلم السلطان",
  "دعاء من خشي أن يصيب شيئا بعينه",
  "ما يقول من أحس وجعا في جسده",
  "دعاء من أصيب بمصيبة",
  "الدعاء للمريض في عيادته",
  "فضل عيادة المريض",
  "دعاء المريض الذي يئس من حياته",
  "الدعاء للميت في الصلاة عليه",
  "تلقين المحتضر",
  "الدعاء للفرط في الصلاة عليه",
  "دعاء التعزية",
  "الدعاء عند إدخال الميت القبر",
  "الدعاء بعد دفن الميت",
  "دعاء زيارة القبور",
  "الدعاء عند إغماض الميت",
  "الرُّقية الشرعية من القرآن الكريم",
  "الرُّقية الشرعية من السنة النبوية"
];

const kMainQuranCopiesNames = [
  ['عثماني', 'Uthmani'],
  ['مجود', 'Tajweed'],
];

const kMainFontsTypesNames = [
  ['حفص', 'Hafs'],
  // ['نستعليق', 'Nastaleeq'],
  ['ورش', 'Warsh'],
  ['شعبة', 'Shu\'bah'],
  ['البزي', 'Al-Bazzi'],
  ['الدوري', 'Al-Duri'],
  ['قالون', 'Qalun'],
  ['قنبل', 'Qunbul'],
  ['السوسي', 'As-Soussi'],
];

const String DomainFirstPart =
    'https://fastworldsolutions.com/islamic/public/api';
const String HadithAPISecondPart = '/hadith';
const String DomainQuranTextSearchFirstPart = 'https://api.quran.com';
const String DomainQuranTextSearchSecondPart = '/api/v4';
const String kFacebookPlaceHolder = "https://www.facebook.com";
const String kGmailPlaceHolder = "fwsolutions2021@gmail.com";
const String kPhoneNumber = "+20123456789";
const String kWhatsApp = "+20123456789";
const String kShare = "شارك التطبيق";
const String kRate = "قيمنا";

const String kAddress = "Cair,Egypt";
const String kQuranAndSunnahDomain = "www.fastworldsolutions.com";
const String kAPISecondPart = "/islamic/public/api";
const String kUploadsSecondPart = "/islamic/public/uploads";

const String kTafseerFolder = "/tafseer";
const String kHadithFolder = "/hadith";
const String kHadithsFolder = "/hadiths";

const longtiude = 12;
const latitiude = 15;
const kHeightForBanner = 80.0;
enum language { arabic, english }

const kAyatNumbersGlyphs = ['fc00', 'fd1d'];
const kSurahsNamesGlyphs = [
  '0021',
  '0022',
  '0023',
  '0024',
  '0025',
  '0026',
  '0027',
  '0028',
  '0029',
  '002a',
  '002b',
  '002c',
  '002d',
  '002e',
  '002f', // 15
  //////////////////////////
  '0030',
  '0031',
  '0032',
  '0033',
  '0034',
  '0035',
  '0036',
  '0037',
  '0038',
  '0039',
  '003a',
  '003b',
  '003c',
  '003d',
  '003e',
  '003f', // 31
  /////////////////////////
  '0040',
  '0041',
  '0042',
  '0043',
  '0044',
  '0045',
  '0046',
  '0047',
  '0048',
  '0049',
  '004a',
  '004b',
  '004c',
  '004d',
  '004e',
  '004f', // 47
  /////////////////////////
  '0050',
  '0051',
  '0052',
  '0053',
  '0054',
  '0055',
  '0056',
  '0057',
  '0058',
  '0059',
  '005a',
  '005b',
  '005c',
  '005d',
  '005e',
  '005f', // 63
  /////////////////////////
  '0060',
  '0061',
  '0062',
  '0063',
  '0064',
  '0065',
  '0066',
  '0067',
  '0068',
  '0069',
  '006a',
  '006b',
  '006c',
  '006d',
  '006e',
  '006f', // 79
  /////////////////////////
  '0070',
  '0071',
  '0072',
  '0073',
  '0074',
  '0075',
  '0076',
  '0077',
  '0078',
  '0079',
  '007a',
  '007b',
  '007c',
  '007d',
  '007e',
  '00a1', // 95
  /////////////////////////
  '00a2',
  '00a3',
  '00a4',
  '00a5',
  '00a6',
  '00a7',
  '00a8',
  '00a9',
  '00aa',
  '00ab',
  '00ac',
  '00ae',
  '00af', // 108
  /////////////////////////
  '00b0',
  '00b1',
  '00b2',
  '00b3',
  '00b4',
  '00b5', // 114
];

const kSurahTitleFontSizeUnit = 0.02;
const kAyahTextFontSizeUnit = 0.020175;

const kQuranTajweedCodeColorMap = {
  'h': Color(0xFFAAAAAA), // Hamzat ul Wasl
  's': Color(0xFFAAAAAA), // Silent
  'l': Color(0xFFAAAAAA), // Lam Shamsiyyah
  'n': Color(0xFF537FFF), // Normal Prolongation: 2 Vowels
  'p': Color(0xFF4050FF), // Permissible Prolongation: 2, 4, 6 Vowels
  'm': Color(0xFF000EBC), // Necessary Prolongation: 6 Vowels
  'q': Color(0xFFDD0008), // Qalaqah
  'o': Color(0xFF2144C1), // Obligatory Prolongation: 4-5 Vowels
  'c': Color(0xFFD500B7), // Ikhafa' Shafawi - With Meem
  'f': Color(0xFF9400A8), // Ikhafa'
  'w': Color(0xFF58B800), // Idgham Shafawi - With Meem
  'i': Color(0xFF26BFFD), // Iqlab
  'a': Color(0xFF169777), // Idgham - With Ghunnah
  'u': Color(0xFF169200), // Idgham - Without Ghunnah
  'd': Color(0xFFA1A1A1), // Idgham - Mutajanisayn
  'b': Color(0xFFA1A1A1), // Idgham - Mutaqaribayn
  'g': Color(0xFFFF7E1E), // Ghunnah: 2 Vowels
  'normal': Color(0xFF000000), // Normal
};

const kQuranTajweedNotations = [
  'مد ٦ حركات لزومًا',
  'مد ٢أو٤أو٦جوازًا',
  'مد واجب ٤ أو ٥ حركات',
  'مد حركتان',
  'إخفاء ومواقع الغُنة(حركتان)',
  'إدغام, وما لا يلفظ',
  'تفخيم الراء',
  'قلقلة',
];

const kAzkarGroupsImagesPaths = [
  "assets/images/mard.jpg",
  "assets/images/life.png",
  "assets/images/travel.png",
  "assets/images/sobh.jpg",
  "assets/images/sogod.png",
  "assets/images/eman.png",
  "assets/images/mehn.png",
  "assets/images/kaba.png",
];
