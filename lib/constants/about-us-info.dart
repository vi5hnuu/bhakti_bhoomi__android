
const Map<String, Object> _aboutUsInfo = {
  "aboutUs": {
    "title": "About Spiritual Shakti",
    "description":
        "Spiritual Shakti is a divine app crafted to connect you with the rich spiritual heritage of Hinduism. Our app provides access to a vast collection of Aartis, Mantras, and sacred scriptures, empowering you on your spiritual journey.",
    "contributors": [
      {
        "name": "Vishnu Kumar",
        "role":
            "Senior Software Developer, Spiritual Advisor & Lead Content Curator",
        "photo_url":
            "https://res.cloudinary.com/dmzcpxynz/image/upload/v1723303768/contributors/vishnu_kumar.png",
        "description": [
          "Vishnu Kumar is a seasoned software developer with extensive experience in crafting high-quality, scalable applications. With a deep understanding of technology and a passion for solving complex problems, Vishnu has consistently delivered innovative solutions throughout his career.",
          "Beyond his technical expertise, Vishnu is also deeply rooted in spirituality. He finds balance between the fast-paced world of software development and his spiritual practices, drawing inspiration from ancient wisdom to guide his modern-day work. His unique blend of technical prowess and spiritual insight allows him to approach projects with a holistic perspective, making meaningful contributions to both the digital and spiritual realms."
        ],
        "social_links": {
          "linkedin": "https://www.linkedin.com/in/vi5hnukumar/",
          "instagram": "https://www.instagram.com/kvi5hnu/",
          "github": "https://github.com/vi5hnuu"
        }
      },
      // {
      //   "name": "Jyoti Maurya",
      //   "role":
      //       "Psychologist in Training & Spiritual Seeker",
      //   "photo_url":
      //       "https://res.cloudinary.com/dmzcpxynz/image/upload/v1723358447/contributors/jyoti.jpg",
      //   "description": [
      //     "Jyoti Maurya is a dedicated individual who has recently completed his 12th grade and is preparing to study psychology. Her journey into psychology is driven by a deep interest in understanding the human mind and behavior.",
      //     "Alongside his academic pursuits, Jyoti follows a spiritual path, seeking balance and meaning through spiritual practices. Her approach to life combines psychological insights with spiritual wisdom, allowing him to connect deeply with both the scientific and spiritual aspects of the human experience."
      //   ],
      //   "social_links": {
      //     "instagram": "https://www.instagram.com/vyakti_04/"
      //   }
      // },
    ]
  },
  "contactInfo": {
    "email": "support@spiritualshakti.com",
    "phone": "+91-9876543210",
    "address": "108, Temple Road, Varanasi, India",
    "contact_form_url": "https://spiritualshakti.com/contact"
  },
  "missionStatement": {
    "title": "Our Mission",
    "text":
        "Our mission is to spread the divine vibrations of Hindu spirituality across the world. Spiritual Shakti aims to make sacred scriptures and Aartis accessible to everyone, fostering a deeper connection with the divine."
  },
  "appVersion": {
    "version": "1.0.0",
    "release_date": "2024-08-01",
    "changelog_url": "https://spiritualshakti.com/changelog"
  },
  "testimonials": [
    {
      "quote":
          "Spiritual Shakti has brought me closer to my roots. The collection of Aartis and scriptures is truly a blessing.",
      "author": "Anjali Verma, Devotee"
    },
    {
      "quote":
          "The app’s design and content are both serene and powerful, just like the spiritual journey it represents.",
      "author": "Vikas Khanna, User"
    }
  ]
};

class Contributor {
  String name;
  String role;
  String photoUrl;
  List<String> description;
  SocialLinks socialLinks;

  Contributor({
    required this.name,
    required this.role,
    required this.photoUrl,
    required this.description,
    required this.socialLinks,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      name: json['name'],
      role: json['role'],
      photoUrl: json['photo_url'],
      description: List<String>.from(json['description']),
      socialLinks: SocialLinks.fromJson(json['social_links']),
    );
  }
}

// SocialLinks Model
class SocialLinks {
  String? linkedin;
  String? instagram;
  String? github;

  SocialLinks({this.linkedin, this.instagram,this.github});

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      linkedin: json['linkedin'],
      instagram: json['instagram'],
      github: json['github'],
    );
  }
}

// ContactInfo Model
class ContactInfo {
  String email;
  String phone;
  String address;
  String contactFormUrl;

  ContactInfo({
    required this.email,
    required this.phone,
    required this.address,
    required this.contactFormUrl,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      contactFormUrl: json['contact_form_url'],
    );
  }
}

// MissionStatement Model
class MissionStatement {
  String title;
  String text;

  MissionStatement({required this.title, required this.text});

  factory MissionStatement.fromJson(Map<String, dynamic> json) {
    return MissionStatement(
      title: json['title'],
      text: json['text'],
    );
  }
}

// Testimonial Model
class Testimonial {
  String quote;
  String author;

  Testimonial({required this.quote, required this.author});

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      quote: json['quote'],
      author: json['author'],
    );
  }
}

// AboutUsInfo Model
class AboutUsInfo {
  String title;
  String description;
  List<Contributor> contributors;
  ContactInfo contactInfo;
  MissionStatement missionStatement;
  String version;
  String releaseDate;
  String changelogUrl;
  List<Testimonial> testimonials;

  AboutUsInfo({
    required this.title,
    required this.description,
    required this.contributors,
    required this.contactInfo,
    required this.missionStatement,
    required this.version,
    required this.releaseDate,
    required this.changelogUrl,
    required this.testimonials,
  });

  factory AboutUsInfo.fromJson(Map<String, dynamic> json) {
    return AboutUsInfo(
      title: json['aboutUs']['title'],
      description: json['aboutUs']['description'],
      contributors: (json['aboutUs']['contributors'] as List)
          .map((i) => Contributor.fromJson(i))
          .toList(),
      contactInfo: ContactInfo.fromJson(json['contactInfo']),
      missionStatement: MissionStatement.fromJson(json['missionStatement']),
      version: json['appVersion']['version'],
      releaseDate: json['appVersion']['release_date'],
      changelogUrl: json['appVersion']['changelog_url'],
      testimonials: (json['testimonials'] as List)
          .map((i) => Testimonial.fromJson(i))
          .toList(),
    );
  }
}

final aboutUsInfo = AboutUsInfo.fromJson(_aboutUsInfo);
