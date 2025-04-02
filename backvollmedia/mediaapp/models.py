from django.db import models

class User(models.Model):
    username = models.CharField(max_length=50, unique=True)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=128)  # Hashed password

    def __str__(self):
        return self.username

class Team(models.Model):
    name = models.CharField(max_length=100, unique=True)
    photo = models.ImageField(upload_to='team_photos/', blank=True, null=True)

    def __str__(self):
        return self.name

class TeamStats(models.Model):
    team = models.OneToOneField(Team, on_delete=models.CASCADE)
    wins = models.IntegerField(default=0)
    losses = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.team.name} - Wins: {self.wins}, Losses: {self.losses}"

class Player(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    team = models.ForeignKey(Team, on_delete=models.SET_NULL, null=True, blank=True)
    position = models.CharField(max_length=50)
    height = models.IntegerField()
    weight = models.IntegerField()
    photo = models.ImageField(upload_to='player_photos/', blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

class Game(models.Model):
    date = models.DateField()
    location = models.CharField(max_length=100)
    team1 = models.ForeignKey(Team, related_name="team1", on_delete=models.CASCADE)
    team2 = models.ForeignKey(Team, related_name="team2", on_delete=models.CASCADE)
    score_team1 = models.IntegerField(default=0)
    score_team2 = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.team1} vs {self.team2} on {self.date}"

class PlayerStats(models.Model):
    player = models.ForeignKey(Player, on_delete=models.CASCADE)
    game = models.ForeignKey(Game, on_delete=models.CASCADE)
    points = models.IntegerField(default=0)
    assists = models.IntegerField(default=0)
    blocks = models.IntegerField(default=0)
    aces = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.player.first_name} {self.player.last_name} stats in {self.game}"
