import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";

const List<MockUser> mockUserDatas = [
  MockUser(
    userId: "1",
    nameSurname: "Ahmet Yılmaz",
    email: "ahmet@gmail.com",
    password: "ahmet123",
  ),
  MockUser(
    userId: "2",
    nameSurname: "Kübra Kaya",
    email: "kubra@gmail.com",
    password: "kubra123",
  ),
];

const List<BookData> mockBookDatas = [
  BookData(
    bookId: "1",
    title: "The History of Science Fiction and Its Toy Figurines",
    description:
    "A lavishly illustrated book covering the history of literary science fiction and toy figurines inspired by it.",
    authors: ["Luigi Toiati"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=FK3YEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9781399005579",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "139900557X",
      ),
    ],
  ),
  BookData(
    bookId: "2",
    title: "Medyatik Mizahın Panoraması",
    description:
    "A deep dive into the role of humor in media, from newspapers to digital media.",
    authors: ["Fatma Nisan", "Ömer Faruk Yücel"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=Yz8EEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9786256552180",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "6256552180",
      ),
    ],
  ),
  BookData(
    bookId: "3",
    title: "D SESİ NASIL ÇIKARILIR?",
    authors: ["MEHMET KARABURÇ"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=mWHdDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
  ),
  BookData(
    bookId: "4",
    title: "Futbol Ve Kültürü",
    authors: ["Roman Horak", "Tanil Bora"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=D_7VAAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "9754703728",
      ),
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9789754703726",
      ),
    ],
  ),
  BookData(
    bookId: "5",
    title: "Tarih, Türkiye, sosyalizm",
    authors: ["Metin Çulhaoğlu"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=9cxJAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "UCAL:B5151030",
      ),
    ],
  ),
  BookData(
    bookId: "6",
    title: "İngilizce-Türkçe sözlük: J-Z",
    authors: ["Hâmit Atalay"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=_tUHAQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "IND:30000067931273",
      ),
    ],
  ),
  BookData(
    bookId: "7",
    title: "Nicknight",
    description: "A collection of works by English photographer Nick Knight.",
    authors: ["Satoko Nakahara"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=1laVQgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "3888146615",
      ),
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9783888146619",
      ),
    ],
  ),
  BookData(
    bookId: "8",
    title: "The Amended School Laws of Oregon",
    authors: ["Oregon"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=5GAdAQAAIAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "UCAL:B2982334",
      ),
    ],
  ),
  BookData(
    bookId: "9",
    title:
    "Research Anthology on Multi-Industry Uses of Genetic Programming and Algorithms",
    description:
    "A comprehensive guide on genetic programming and its applications across various industries.",
    authors: ["Management Association, Information Resources"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=nt8XEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9781799880998",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "1799880990",
      ),
    ],
  ),
  BookData(
    bookId: "10",
    title: "What is Adaptation?",
    authors: ["Richard Ernest Lloyd"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=FwgFvBXeF-MC&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "HARVARD:32044019647080",
      ),
    ],
  ),
  BookData(
    bookId: "11",
    title: "Directory of the Medical Library Association",
    authors: ["Medical Library Association"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=f7NtAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "UOM:39015039097095",
      ),
    ],
  ),
  BookData(
    bookId: "12",
    title: "A Critical and Exegetical Commentary on the Book of Job",
    authors: ["Samuel Rolles Driver", "George Buchanan Gray"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=4Co2AQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "CORNELL:31924058535026",
      ),
    ],
  ),
  BookData(
    bookId: "13",
    title: "Faith Or Fraud",
    description:
    "Examines the impact of non-mainstream faiths and spiritual practices on the legal understanding of religious freedom.",
    authors: ["Jeremy Patrick"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=ubo8zQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "0774863331",
      ),
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9780774863339",
      ),
    ],
  ),
  BookData(
    bookId: "14",
    title:
    "Self-help Activators (727 +) to Rapidly Eliminate Anxiety, Depression, Cravings, and More Using Energy Psychology",
    description:
    "A practical guide to using energy psychology to eliminate anxiety, depression, and cravings.",
    authors: ["Nicholas Mag"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=BTjADwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
  ),
  BookData(
    bookId: "15",
    title:
    "GÜÇLÜ BİR PSİKOLOJİ - Kişisel gelişim, Psikolojik olarak güçlenmenin yolları, Karakter Analizi, Kişilik Psikolojisi",
    description:
    "A guide to personal development and psychological empowerment.",
    authors: ["Jenna Meyra"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=MHpoEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9783752964684",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "3752964685",
      ),
    ],
  ),
  BookData(
    bookId: "16",
    title: "Intelligence, Creativity and Fantasy",
    description:
    "A multidisciplinary platform for the presentation, interaction, and dissemination of research on harmony and proportion.",
    authors: [
      "Mário Ming Kong",
      "Maria do Rosário Monteiro",
      "Maria João Pereira Neto"
    ],
    thumbnailUrl:
    "http://books.google.com/books/content?id=pcO2DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9781000734065",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "1000734064",
      ),
    ],
  ),
  BookData(
    bookId: "17",
    title: "OLUMLU DÜŞÜNMEK",
    description: "A guide to positive thinking and personal success.",
    authors: ["UĞUR KALKAN"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=ga2qEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
  ),
  BookData(
    bookId: "18",
    title: "Öfke ve Tahammülsüzlük",
    description: "A guide to understanding and managing anger and intolerance.",
    authors: ["William Davies"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=wC26DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9789752754720",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "9752754724",
      ),
    ],
  ),
  BookData(
    bookId: "19",
    title: "The Dublin University Calendar",
    authors: ["Trinity College (Dublin, Ireland)"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=lWstAQAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "CORNELL:31924096344357",
      ),
    ],
  ),
  BookData(
    bookId: "20",
    title: "Catalogue",
    authors: ["Rutgers University"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=znw4AAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "UOM:39015066633929",
      ),
    ],
  ),
  BookData(
    bookId: "21",
    title: "The Last Second",
    description:
    "A thriller about a private space agency with the power to end the world.",
    authors: ["Catherine Coulter", "J.T. Ellison"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=bWmGDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9781760850869",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "1760850861",
      ),
    ],
  ),
  BookData(
    bookId: "22",
    title: "Multicultural Horizons",
    description:
    "Explores the cultural politics of multiculturalism and the concept of 'multicultural intimacies'.",
    authors: ["Anne-Marie Fortier"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=Ra1-AgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9781134221738",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "1134221738",
      ),
    ],
  ),
  BookData(
    bookId: "23",
    title: "DÜŞÜNCE BECERİSİ",
    description: "Exercises to develop thinking skills for brain development.",
    authors: ["MEHMET KARABURÇ"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=aOlhDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
  ),
  BookData(
    bookId: "24",
    title:
    "Ana Hatlarıyla İngiliz Edebiyatı: Anglo-Sakson Döneminden Çağdaş İngiliz Edebiyatına",
    authors: ["Sıla ŞENLEN GÜVENÇ"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=mLXuEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.isbn13,
        identifier: "9786253995676",
      ),
      BookIdentifier(
        type: IdentifierType.isbn10,
        identifier: "6253995677",
      ),
    ],
  ),
  BookData(
    bookId: "25",
    title: "Eğitim yönetimi",
    authors: ["Yahya Kemal Kaya"],
    thumbnailUrl:
    "http://books.google.com/books/content?id=iYItAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
    identifiers: [
      BookIdentifier(
        type: IdentifierType.other,
        identifier: "UCAL:B3195599",
      ),
    ],
  ),
];