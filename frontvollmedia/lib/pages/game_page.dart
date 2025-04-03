import 'package:flutter/material.dart';
import 'package:frontvollmedia/pages/standings_page.dart';
import 'package:frontvollmedia/pages/profile_page.dart';
import 'package:frontvollmedia/pages/team_players_page.dart';

void main() {
  runApp(VolleyballApp());
}

class VolleyballApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volleyball App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MatchesPage(),
    );
  }
}

class MatchesPage extends StatefulWidget {
  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  DateTime selectedDate = DateTime.now();
  int _selectedIndex = 1;
  final List<Map<String, dynamic>> matches = [
    {
      'homeTeam': 'Хасу мегастарс',
      'awayTeam': 'SG HAWKS',
      'homeScore': 119,
      'awayScore': 114,
      'status': 'дууссан',
      'homeImage': 'hasu.png',
      'awayImage': 'sghawks.png',
    },
    {
      'homeTeam': 'Улаанбаатар финикс',
      'awayTeam': 'Ховд ижил алтайн торгууд',
      'homeScore': 116,
      'awayScore': 86,
      'status': 'дууссан',
      'homeImage': 'ubbin.png',
      'awayImage': 'howd.png',
    },
  ];

  final Map<String, List<Map<String, dynamic>>> teamPlayers = {
    'hasu.png': [
      {'number': '1', 'name': 'Болортуяа', 'position': 'Довтлогч', 'height': 185},
      {'number': '2', 'name': 'Энхбаяр', 'position': 'Довтлогч', 'height': 190},
      {'number': '3', 'name': 'Батбаяр', 'position': 'Довтлогч', 'height': 188},
      {'number': '4', 'name': 'Ганбаяр', 'position': 'Довтлогч', 'height': 192},
      {'number': '5', 'name': 'Болор', 'position': 'Довтлогч', 'height': 187},
    ],
    'sghawks.png': [
      {'number': '1', 'name': 'Алтанцэцэг', 'position': 'Довтлогч', 'height': 183},
      {'number': '2', 'name': 'Болормаа', 'position': 'Довтлогч', 'height': 186},
      {'number': '3', 'name': 'Ганбаатар', 'position': 'Довтлогч', 'height': 189},
      {'number': '4', 'name': 'Дорж', 'position': 'Довтлогч', 'height': 185},
      {'number': '5', 'name': 'Энхбат', 'position': 'Довтлогч', 'height': 191},
    ],
    'ubbin.png': [
      {'number': '1', 'name': 'Батбаяр', 'position': 'Довтлогч', 'height': 187},
      {'number': '2', 'name': 'Ганбаатар', 'position': 'Довтлогч', 'height': 190},
      {'number': '3', 'name': 'Дорж', 'position': 'Довтлогч', 'height': 185},
      {'number': '4', 'name': 'Энхбат', 'position': 'Довтлогч', 'height': 191},
      {'number': '5', 'name': 'Болор', 'position': 'Довтлогч', 'height': 188},
    ],
    'howd.png': [
      {'number': '1', 'name': 'Алтанцэцэг', 'position': 'Довтлогч', 'height': 183},
      {'number': '2', 'name': 'Болормаа', 'position': 'Довтлогч', 'height': 186},
      {'number': '3', 'name': 'Ганбаатар', 'position': 'Довтлогч', 'height': 189},
      {'number': '4', 'name': 'Дорж', 'position': 'Довтлогч', 'height': 185},
      {'number': '5', 'name': 'Энхбат', 'position': 'Довтлогч', 'height': 191},
    ],
  };

  final Map<String, String> teamNames = {
    'hasu.png': 'Хасу мегастарс',
    'sghawks.png': 'SG HAWKS',
    'ubbin.png': 'Улаанбаатар финикс',
    'howd.png': 'Ховд ижил алтайн торгууд',
  };

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + offset, 1);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/');
    } else if (index == 1) {
      // Already on MatchesPage
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/standings');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  void _showTeamPlayers(String teamImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamPlayersPage(
          teamName: teamNames[teamImage] ?? 'Баг',
          teamImage: teamImage,
          players: teamPlayers[teamImage] ?? [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = selectedDate.month;
    final currentYear = selectedDate.year;
    
    // Generate dates for 6 months before and 6 months after current month
    final allDates = <Map<String, dynamic>>[];
    for (int monthOffset = -6; monthOffset <= 6; monthOffset++) {
      final date = DateTime(currentYear, currentMonth + monthOffset, 1);
      final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
      
      for (int day = 1; day <= daysInMonth; day++) {
        final currentDate = DateTime(date.year, date.month, day);
        allDates.add({
          'date': currentDate,
          'isCurrentMonth': monthOffset == 0,
          'isPastMonth': monthOffset < 0,
          'isFutureMonth': monthOffset > 0,
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Тоглолт',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => _changeMonth(-1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${currentYear} оны ${currentMonth} сар',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: () => _changeMonth(1),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: allDates.map((dateInfo) {
                        final date = dateInfo['date'] as DateTime;
                        final isCurrentMonth = dateInfo['isCurrentMonth'] as bool;
                        final isPastMonth = dateInfo['isPastMonth'] as bool;
                        final isSelected = date.day == selectedDate.day && 
                                         date.month == selectedDate.month && 
                                         date.year == selectedDate.year;
                        
                        final textColor = isSelected 
                            ? Colors.black 
                            : (isCurrentMonth 
                                ? Colors.white 
                                : (isPastMonth 
                                    ? Colors.grey[400] 
                                    : Colors.grey[600]));
                        
                        final backgroundColor = isSelected 
                            ? Colors.blue 
                            : (isCurrentMonth 
                                ? Colors.grey[800] 
                                : (isPastMonth 
                                    ? Colors.grey[900] 
                                    : Colors.grey[900]));

                        return GestureDetector(
                          onTap: () => _selectDate(date),
                          child: Container(
                            width: 60,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ['Дав', 'Мяг', 'Лха', 'Пүр', 'Баа', 'Бям', 'Ням'][date.weekday - 1],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ] : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _showTeamPlayers(match['homeImage']),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(match['homeImage'], height: 40, width: 40),
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showTeamPlayers(match['awayImage']),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(match['awayImage'], height: 40, width: 40),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match['homeTeam'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              match['awayTeam'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              match['homeScore'].toString(),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              match['awayScore'].toString(),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            match['status'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[300],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Мэдээ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Тоглолт',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Бусад',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Хэрэглэгч',
          ),
        ],
      ),
    );
  }
}
