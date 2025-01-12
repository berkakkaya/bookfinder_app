enum BookCategory {
  // Fiction
  adventure,
  classics,
  contemporary,
  fantasy,
  historicalFiction,
  horror,
  mysteryCrime,
  romance,
  scienceFiction,
  thrillerSuspense,
  youngAdult,

  // Non-Fiction
  artPhotography,
  biographyMemoir,
  businessEconomics,
  cookingFood,
  healthWellness,
  history,
  politicsSocialSciences,
  religionSpirituality,
  scienceNature,
  selfHelp,
  travelAdventure,

  // Academic & Educational
  computersTechnology,
  engineering,
  mathematics,
  medicalHealthSciences,
  psychology,
  reference,
  studyAids,
  testPreparation,
  textbooks,

  // Children's Books
  activityBooks,
  earlyLearning,
  pictureBooks,
  chapterBooks,
  middleGrade,

  // Comics & Graphic Novels
  manga,
  superheroes,
  webcomics,
  fantasySciFi,

  // Genres for Special Audiences
  lgbtq,
  multicultural,
  womensFiction,

  // Other Genres
  poetry,
  drama,
  essays,
  anthologies,
}

String convertBookCategoryToDisplayStr(BookCategory category) {
  return switch (category) {
    // Fiction
    BookCategory.adventure => "Macera",
    BookCategory.classics => "Klasikler",
    BookCategory.contemporary => "Çağdaş",
    BookCategory.fantasy => "Fantastik",
    BookCategory.historicalFiction => "Tarihi Kurgu",
    BookCategory.horror => "Korku",
    BookCategory.mysteryCrime => "Gizem ve Suç",
    BookCategory.romance => "Romantik",
    BookCategory.scienceFiction => "Bilim Kurgu",
    BookCategory.thrillerSuspense => "Gerilim ve Heyecan",
    BookCategory.youngAdult => "Genç Yetişkin",

    // Non-Fiction
    BookCategory.artPhotography => "Sanat ve Fotoğraf",
    BookCategory.biographyMemoir => "Biyografi ve Anı",
    BookCategory.businessEconomics => "İş ve Ekonomi",
    BookCategory.cookingFood => "Yemek ve Mutfak",
    BookCategory.healthWellness => "Sağlık ve Zindelik",
    BookCategory.history => "Tarih",
    BookCategory.politicsSocialSciences => "Politika ve Sosyal Bilimler",
    BookCategory.religionSpirituality => "Din ve Maneviyat",
    BookCategory.scienceNature => "Bilim ve Doğa",
    BookCategory.selfHelp => "Kişisel Gelişim",
    BookCategory.travelAdventure => "Seyahat ve Macera",

    // Academic & Educational
    BookCategory.computersTechnology => "Bilgisayar ve Teknoloji",
    BookCategory.engineering => "Mühendislik",
    BookCategory.mathematics => "Matematik",
    BookCategory.medicalHealthSciences => "Tıp ve Sağlık Bilimleri",
    BookCategory.psychology => "Psikoloji",
    BookCategory.reference => "Kaynak Kitaplar",
    BookCategory.studyAids => "Çalışma Rehberleri",
    BookCategory.testPreparation => "Sınav Hazırlık",
    BookCategory.textbooks => "Ders Kitapları",

    // Children's Books
    BookCategory.activityBooks => "Aktivite Kitapları",
    BookCategory.earlyLearning => "Erken Öğrenme",
    BookCategory.pictureBooks => "Resimli Kitaplar",
    BookCategory.chapterBooks => "Bölümlü Kitaplar",
    BookCategory.middleGrade => "Orta Seviye",

    // Comics & Graphic Novels
    BookCategory.manga => "Manga",
    BookCategory.superheroes => "Süper Kahramanlar",
    BookCategory.webcomics => "Web Çizgi Romanları",
    BookCategory.fantasySciFi => "Fantastik ve Bilim Kurgu",

    // Genres for Special Audiences
    BookCategory.lgbtq => "LGBTQ+",
    BookCategory.multicultural => "Çokkültürlü",
    BookCategory.womensFiction => "Kadın Kurgu",

    // Other Genres
    BookCategory.poetry => "Şiir",
    BookCategory.drama => "Drama",
    BookCategory.essays => "Denemeler",
    BookCategory.anthologies => "Antolojiler",
  };
}
