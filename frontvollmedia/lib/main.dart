import 'package:flutter/material.dart';
import 'pages/standings_page.dart';
import 'pages/game_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(BasketMediaApp());
}

class BasketMediaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => NewsPage(),
        '/matches': (context) => MatchesPage(),
        '/standings': (context) => StandingsPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VollMedia', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          NewsCard(
            title: '“Монголын волейболын тамирчдын холбоо”-г Монголын волейболын холбооноос албан ёсоор батламжиллаа.',
            imageUrl: 'assets/negah.jpg',
            likes: 48,
            comments: 30,
            timeAgo: '2 өдрийн өмнө',
          ),
          SizedBox(height: 10),
          NewsCard(
            title: 'Эмгэнэл',
            imageUrl: 'assets/negegch.jpg',
            likes: 57,
            comments: 24,
            timeAgo: '2 өдрийн өмнө',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/matches');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/standings');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Мэдээ'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_basketball), label: 'Тоглолт'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Бусад'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Хэрэглэгч'),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;

  NewsCard({
    required this.title,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: title,
              imageUrl: imageUrl,
              likes: likes,
              comments: comments,
              timeAgo: timeAgo,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 140,
                width: 300,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red),
                      SizedBox(width: 5),
                      Text('$likes', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.comment, color: Colors.orange),
                      SizedBox(width: 5),
                      Text('$comments', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Text(timeAgo, style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;

  DetailPage({
    required this.title,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Жаргалсайханы Болортуяа\n(1978-2025)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        SizedBox(width: 5),
                        Text('$likes', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.comment, color: Colors.orange),
                        SizedBox(width: 5),
                        Text('$comments', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Text(timeAgo, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 24),
                ContentSection(
                  text: 'Монголын Волейболын спортын бахархалт тамирчин, волейболын спортын Олон Улсын Хэмжээний Мастер Жаргалсайханы Болортуяа 2025 оны 3 дугаар сарын 21 -ний өдөр зуурдаар таалал төгсөж, Биеийн тамир, спортын салбарт нөхөж баршгүй хүнд гарз тохиолоо.',
                ),
                ContentSection(
                  title: 'Спортын амжилтууд',
                  text: 'Ж. Болортуяа нь 1992 оноос волейболын спортоор хичээллэж, 1998-2008 оны хугацаанд шигшээ багийн хамтаар Зүүн Азийн аварга шалгаруулах тэмцээний мөнгө, хүрэл медалиудыг хүртэж байсан түүхэн амжилтын эзэн билээ.',
                ),
                ContentSection(
                  title: 'Багийн түүх',
                  text: 'Тэрээр 1992-2010 онуудад "Эрдэм" цогцолбор, Бодь группийн Бодь баг, Говь ХХК-ны баг, Ноён группийн Ноён баг, ДЦС-4 ТӨХК-ны Эрчим багийн тамирчнаар тоглож Идэрчүүдийн УАШТ-ий 2 удаагийн аварга, Клубүүдийн аварга шалгаруулах тэмцээний 3 алт, 5 мөнгө, хүрэл, мөн Монголын волейболын Үндэсний дээд лигийн тэмцээний 6 Алт, 6 Мөнгө, 3 Хүрэл, Монголын Бүх ард түмний спартакиадаас алт, мөнгө хүрэл, Ахмад волейболын УАШТ-ий 5-н удаагийн аваргаар шалгарч байсан шилдэг тамирчин байлаа.',
                ),
                ContentSection(
                  title: 'Шагнал урамшуулал',
                  text: 'Төр засгаас түүний волейболын спортод оруулсан хувь нэмрийг өндрөөр үнэлж, 2018 онд Төрийн дээд шагнал Алтангадас одон 2012 онд Биеийн тамир спортын тэргүүний ажилтан 2013 онд МЗХ-ны Тэргүүний залуу алтан медаль 2016 онд Волейболын спортын ОУХМ, 2017 онд Эрчим хүчний яамны жуух бичиг, 2021 онд Эрчим хүчний салбарын тэргүүний ажилтан цол тэмдгээр тус тус шагнаж байсан.',
                ),
                ContentSection(
                  text: 'Түүний эелдэг тусархаг зан, уран чадварлаг тоглолт, хичээнгүй тэмцэгч чанар, үе үеийн волейболчид, хөгжөөн дэмжигчид, Монголын Волейболын Холбооны нийт хамт олны сэтгэл зүрхэнд үүрд хоногшин үлдэх болно.',
                ),
                SizedBox(height: 24),
                Text(
                  'Талийгаачийн гэр бүл, үр хүүхэд, төрөл төрөгсдөд Волейболчдынхоо өмнөөс гүн эмгэнэл илэрхийлье.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'УМ МА НИ БАД МЭ ХУМ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'МОНГОЛЫН ВОЛЕЙБОЛЫН ХОЛБОО',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Сэтгэгдэлүүд',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                CommentItem(
                  username: 'psddsadasdsaa',
                  comment: 'Мэнххүслsdasdasdsэн sdasdsa',
                  timeAgo: '0:14',
                ),
                CommentItem(
                  username: 'Ган Эрдэнэ',
                  comment: 'dasdasdsadsadsad',
                  timeAgo: '0:15',
                ),
                CommentItem(
                  username: 'Ichko Ichinnorow',
                  comment: 'ooo',
                  timeAgo: '0:16',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final String username;
  final String comment;
  final String timeAgo;

  CommentItem({
    required this.username,
    required this.comment,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[800],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  comment,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContentSection extends StatelessWidget {
  final String? title;
  final String text;

  ContentSection({
    this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}



