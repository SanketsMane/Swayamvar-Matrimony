\$data = json_decode('[
  {
    "religion": "Hindu",
    "castes": [
      {
        "name": "Brahmin",
        "sub_castes": ["Deshastha Brahmin", "Chitpavan Brahmin", "Saraswat Brahmin", "Iyer", "Iyengar", "Kanyakubja", "Saryupareen", "Gaur", "Pushkarna", "Havyaka"]
      },
      {
        "name": "Kshatriya",
        "sub_castes": ["Rajput", "Maratha", "Reddy", "Kamma", "Kshatriya Raju", "Bhavsar Kshatriya", "Kurmi Kshatriya", "Vanniyar", "Gounder"]
      },
      {
        "name": "Vaishya",
        "sub_castes": ["Agarwal", "Gupta", "Bania", "Maheshwari", "Khandelwal", "Porwal", "Arya Vysya", "Komati", "Chettiar"]
      },
      {
        "name": "Shudra",
        "sub_castes": ["Yadav", "Kurmi", "Jat", "Lingayat", "Patel", "Patidar", "Nadar", "Ezhava", "Vokkaliga", "Koli"]
      },
      {
        "name": "Scheduled Caste (SC)",
        "sub_castes": ["Mahar", "Chamar", "Valmiki", "Pasi", "Khatik", "Mala", "Madiga"]
      },
      {
        "name": "Scheduled Tribe (ST)",
        "sub_castes": ["Gond", "Bhil", "Santhal", "Mina", "Bodo"]
      },
      {
        "name": "Other Backward Class (OBC)",
        "sub_castes": ["Saini", "Gurjar", "Kushwaha", "Maurya", "Teli", "Chaurasia"]
      }
    ]
  },
  {
    "religion": "Muslim",
    "castes": [
      {
        "name": "Sunni",
        "sub_castes": ["Sheikh", "Ansari", "Qureshi", "Pathan", "Syed", "Siddiqui", "Memon", "Chauhan", "Khatri"]
      },
      {
        "name": "Shia",
        "sub_castes": ["Syed", "Bohra", "Khoja", "Rizvi", "Zaidi", "Naqvi", "Mirza"]
      },
      {
        "name": "Others (Muslim)",
        "sub_castes": ["Ahmadiyya", "Sufi", "Dawoodi Bohra", "Alavi Bohra"]
      }
    ]
  },
  {
    "religion": "Christian",
    "castes": [
      {
        "name": "Roman Catholic",
        "sub_castes": ["Goan Catholic", "Mangalorean Catholic", "East Indian Catholic", "Tamil Catholic", "Syro-Malabar Catholic"]
      },
      {
        "name": "Protestant",
        "sub_castes": ["Church of South India (CSI)", "Church of North India (CNI)", "Methodist", "Baptist", "Pentecostal", "Lutheran"]
      },
      {
        "name": "Syrian Christian",
        "sub_castes": ["Jacobite", "Orthodox", "Marthoma", "Syro-Malankara"]
      },
      {
        "name": "Others (Christian)",
        "sub_castes": ["Anglo Indian", "Born Again", "Evangelical"]
      }
    ]
  },
  {
    "religion": "Sikh",
    "castes": [
      {
        "name": "Jat Sikh",
        "sub_castes": ["Dhillon", "Gill", "Sandhu", "Sidhu", "Grewal", "Kaur"]
      },
      {
        "name": "Ramgarhia",
        "sub_castes": ["Matharu", "Panesar", "Tarkhan", "Bhamra"]
      },
      {
        "name": "Khatri",
        "sub_castes": ["Kapoor", "Khanna", "Mehra", "Sethi"]
      },
      {
        "name": "Arora",
        "sub_castes": ["Ahuja", "Batra", "Chawla", "Dhingra"]
      },
      {
        "name": "Others (Sikh)",
        "sub_castes": ["Majhabi", "Ravidasia", "Saini", "Rajput", "Kamboj"]
      }
    ]
  },
  {
    "religion": "Jain",
    "castes": [
      {
        "name": "Digambar",
        "sub_castes": ["Bisapanthi", "Terapanthi", "Taranpanthi", "Khandelwal", "Agarwal"]
      },
      {
        "name": "Shwetambar",
        "sub_castes": ["Murtipujaka", "Sthanakvasi", "Terapanthi", "Oswal", "Porwal"]
      }
    ]
  },
  {
    "religion": "Buddhist",
    "castes": [
      {
        "name": "Navayana (Neo-Buddhist)",
        "sub_castes": ["No Sub-Caste"]
      },
      {
        "name": "Theravada",
        "sub_castes": ["No Sub-Caste"]
      },
      {
        "name": "Mahayana",
        "sub_castes": ["No Sub-Caste"]
      }
    ]
  },
  {
    "religion": "Parsi",
    "castes": [
      {
        "name": "Irani",
        "sub_castes": ["No Sub-Caste"]
      },
      {
        "name": "Zoroastrian",
        "sub_castes": ["No Sub-Caste"]
      }
    ]
  },
  {
    "religion": "Jewish",
    "castes": [
      {
        "name": "Bene Israel",
        "sub_castes": ["No Sub-Caste"]
      },
      {
        "name": "Cochin Jews",
        "sub_castes": ["No Sub-Caste"]
      },
      {
        "name": "Baghdadi Jews",
        "sub_castes": ["No Sub-Caste"]
      }
    ]
  },
  {
    "religion": "No Religion",
    "castes": [
      {
        "name": "No Caste",
        "sub_castes": ["No Sub-Caste"]
      }
    ]
  },
  {
    "religion": "Spiritual",
    "castes": [
      {
        "name": "No Caste",
        "sub_castes": ["No Sub-Caste"]
      }
    ]
  }
]', true);

DB::statement('SET FOREIGN_KEY_CHECKS=0;');
\App\Models\SubCaste::truncate();
\App\Models\Caste::truncate();
\App\Models\Religion::truncate();
DB::statement('SET FOREIGN_KEY_CHECKS=1;');

foreach (\$data as \$rData) {
    \$religion = \App\Models\Religion::create(['name' => \$rData['religion']]);
    foreach (\$rData['castes'] as \$cData) {
        \$caste = \App\Models\Caste::create([
            'religion_id' => \$religion->id,
            'name' => \$cData['name']
        ]);
        foreach (\$cData['sub_castes'] as \$scName) {
            \App\Models\SubCaste::create([
                'caste_id' => \$caste->id,
                'name' => \$scName
            ]);
        }
    }
}
echo "Seeding completed Successfully!";
