import 'package:flutter/material.dart';
import 'pages/standings_page.dart';
import 'pages/game_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'services/api_service.dart';

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
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _apiService = ApiService();
  List<dynamic> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final news = await _apiService.fetchNews();
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Мэдээ ачаалахад алдаа гарлаа'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VollMedia', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _news.length,
              itemBuilder: (context, index) {
                final newsItem = _news[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: NewsCard(
                    title: newsItem['title'] ?? '',
                    imageUrl: newsItem['image'] ?? 'assets/negah.jpg',
                    content: newsItem['content'] ?? '',
                    timeAgo: _formatDate(newsItem['created_at']),
                  ),
                );
              },
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

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} өдрийн өмнө';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} цагийн өмнө';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} минутын өмнө';
    } else {
      return 'Сая';
    }
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;
  final String timeAgo;

  NewsCard({
    required this.title,
    required this.imageUrl,
    required this.content,
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
              content: content,
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
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    width: 300,
                    color: Colors.grey[800],
                    child: Icon(Icons.image_not_supported, color: Colors.white, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(timeAgo, style: TextStyle(color: Colors.grey)),
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
  final String content;
  final String timeAgo;

  DetailPage({
    required this.title,
    required this.imageUrl,
    required this.content,
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
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                color: Colors.grey[900],
                child: Icon(Icons.image_not_supported, color: Colors.white, size: 50),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
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



