from rest_framework import serializers
from .models import User, Team, TeamStats, Player, Game, PlayerStats, News
from django.contrib.auth.hashers import make_password

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        # Hash the password before saving
        validated_data['password'] = make_password(validated_data['password'])
        return super().create(validated_data)

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("This email is already registered.")
        return value

    def validate_username(self, value):
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("This username is already taken.")
        return value

class TeamSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ['id', 'name', 'gender', 'photo']

class TeamStatsSerializer(serializers.ModelSerializer):
    team = TeamSerializer()

    class Meta:
        model = TeamStats
        fields = ['id', 'team', 'wins', 'losses']

class PlayerSerializer(serializers.ModelSerializer):
    team = TeamSerializer()

    class Meta:
        model = Player
        fields = ['id', 'first_name', 'last_name', 'team', 'position', 'height', 'weight', 'photo']

class GameSerializer(serializers.ModelSerializer):
    team1 = TeamSerializer()
    team2 = TeamSerializer()

    class Meta:
        model = Game
        fields = ['id', 'date', 'location', 'team1', 'team2', 'score_team1', 'score_team2']

class PlayerStatsSerializer(serializers.ModelSerializer):
    player = PlayerSerializer()
    game = GameSerializer()

    class Meta:
        model = PlayerStats
        fields = ['id', 'player', 'game', 'points', 'assists', 'blocks', 'aces']

class NewsSerializer(serializers.ModelSerializer):
    class Meta:
        model = News
        fields = '__all__'
