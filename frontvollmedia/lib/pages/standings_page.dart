import 'package:flutter/material.dart';
import 'game_page.dart';
import '../services/api_service.dart';
import 'team_details_page.dart';

class StandingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Хүснэгт'),
            ],
            indicatorColor: Colors.purple,
          ),
        ),
        body: TabBarView(
          children: [
            StandingsTab(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            currentIndex: 2,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(context, '/');
              } else if (index == 1) {
                Navigator.pushReplacementNamed(context, '/matches');
              } else if (index == 2) {
                // Already on StandingsPage
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
        ),
      ),
    );
  }
}

class StandingsTab extends StatefulWidget {
  @override
  _StandingsTabState createState() => _StandingsTabState();
}

class _StandingsTabState extends State<StandingsTab> {
  bool isMaleSelected = true;
  final _apiService = ApiService();
  List<dynamic> _maleTeams = [];
  List<dynamic> _femaleTeams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamStats();
  }

  Future<void> _loadTeamStats() async {
    try {
      final teams = await _apiService.fetchTeams();
      final teamStats = await _apiService.fetchTeamStats();
      
      setState(() {
        _maleTeams = teamStats.where((stat) => stat['team']['gender'] == 'male').toList();
        _femaleTeams = teamStats.where((stat) => stat['team']['gender'] == 'female').toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Өгөгдөл ачаалахад алдаа гарлаа'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMaleSelected = true;
                  });
                },
                child: Text(
                  'ЭРЭГТЭЙ',
                  style: TextStyle(
                    color: isMaleSelected ? Colors.blue : Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMaleSelected = false;
                  });
                },
                child: Text(
                  'ЭМЭГТЭЙ',
                  style: TextStyle(
                    color: !isMaleSelected ? Colors.blue : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: isMaleSelected ? _maleTeams.length : _femaleTeams.length,
                  itemBuilder: (context, index) {
                    final team = isMaleSelected ? _maleTeams[index] : _femaleTeams[index];
                    return TeamStandingRow(
                      rank: (index + 1).toString(),
                      teamLogo: team['team']['photo'] ?? 'default_team.png',
                      teamName: team['team']['name'] ?? '',
                      W: team['wins'].toString(),
                      L: team['losses'].toString(),
                      PTS: (team['wins'] * 3).toString(),
                      teamId: team['team']['id'].toString(),
                      gender: team['team']['gender'],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class TeamStandingRow extends StatelessWidget {
  final String rank;
  final String teamLogo;
  final String teamName;
  final String W;
  final String L;
  final String PTS;
  final String teamId;
  final String gender;

  TeamStandingRow({
    required this.rank,
    required this.teamLogo,
    required this.teamName,
    required this.W,
    required this.L,
    required this.PTS,
    required this.teamId,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamDetailsPage(
              teamId: teamId,
              teamName: teamName,
              teamLogo: teamLogo,
              gender: gender,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade800, width: 0.5)),
        ),
        child: Row(
          children: [
            SizedBox(width: 30, child: Text(rank)),
            SizedBox(
              width: 30,
              height: 30,
              child: teamLogo.startsWith('http')
                  ? Image.network(
                      teamLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.sports_basketball, color: Colors.white, size: 20),
                        );
                      },
                    )
                  : Image.asset(
                      teamLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.sports_basketball, color: Colors.white, size: 20),
                        );
                      },
                    ),
            ),
            SizedBox(width: 8),
            SizedBox(width: 100, child: Text(teamName)),
            Spacer(),
            Row(
              children: [
                SizedBox(width: 50, child: Text(W)),
                SizedBox(width: 50, child: Text(L)),
                SizedBox(width: 50, child: Text(PTS)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}