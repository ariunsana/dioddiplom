import 'package:flutter/material.dart';
import 'game_page.dart';

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
                Navigator.pop(context);
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MatchesPage()),
                );
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
          child: ListView.builder(
            itemCount: isMaleSelected ? _maleTeams.length : _femaleTeams.length,
            itemBuilder: (context, index) {
              final team = isMaleSelected ? _maleTeams[index] : _femaleTeams[index];
              return TeamStandingRow(
                rank: team['rank'] ?? '',
                teamLogo: team['teamLogo'] ?? '',
                teamName: team['teamName'] ?? '',
                W: team['W'] ?? '',
                L: team['L'] ?? '',
                PTS: team['PTS'] ?? '',
              );
            },
          ),
        ),
      ],
    );
  }

  final List<Map<String, String>> _maleTeams = [
    {'rank': '1', 'teamLogo': 'hasu.png', 'teamName': 'Хасу мегастарс', 'W': '17', 'L': '1', 'PTS': '50'},
    {'rank': '2', 'teamLogo': 'sghawks.png', 'teamName': 'SG HAWKS', 'W': '16', 'L': '2', 'PTS': '47'},
  ];

  final List<Map<String, String>> _femaleTeams = [
    {'rank': '1', 'teamLogo': 'ubbin.png', 'teamName': 'Улаанбаатар финикс', 'W': '15', 'L': '6', 'PTS': '48'},
    {'rank': '2', 'teamLogo': 'howd.png', 'teamName': 'Ховд ижил алтайн торгууд', 'W': '14', 'L': '7', 'PTS': '39'},
  ];
}

class TeamStandingRow extends StatelessWidget {
  final String rank;
  final String teamLogo;
  final String teamName;
  final String W;
  final String L;
  final String PTS;

  TeamStandingRow({
    required this.rank,
    required this.teamLogo,
    required this.teamName,
    required this.W,
    required this.L,
    required this.PTS,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade800, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text(rank)),
          SizedBox(width: 30, height: 30, child: Image.asset(teamLogo)),
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
    );
  }
}