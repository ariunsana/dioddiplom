from rest_framework import serializers
from .models import User, Team, TeamStats, Player, Game, PlayerStats, News, PlayerSeasonStats
from django.contrib.auth.hashers import make_password

class UserSerializer(serializers.ModelSerializer):
    photo = serializers.ImageField(required=False, allow_null=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password', 'photo']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        # Hash the password before saving
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        return super().create(validated_data)

    def update(self, instance, validated_data):
        # Handle password update separately
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        return super().update(instance, validated_data)

    def validate_email(self, value):
        if self.instance and self.instance.email == value:
            return value
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("This email is already registered.")
        return value

    def validate_username(self, value):
        if self.instance and self.instance.username == value:
            return value
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
        fields = ['id', 'date', 'start_time', 'location', 'team1', 'team2', 'score_team1', 'score_team2', 'is_finished']

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

class PlayerSeasonStatsSerializer(serializers.ModelSerializer):
    player = PlayerSerializer()

    class Meta:
        model = PlayerSeasonStats
        fields = ['id', 'player', 'season', 'games_played', 'average_points', 
                 'average_assists', 'average_blocks', 'average_aces']
