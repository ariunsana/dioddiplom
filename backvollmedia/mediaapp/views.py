from rest_framework import viewsets, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.contrib.auth.hashers import make_password, check_password
from .models import User, Team, TeamStats, Player, Game, PlayerStats, News
from .serializers import UserSerializer, TeamSerializer, TeamStatsSerializer, PlayerSerializer, GameSerializer, PlayerStatsSerializer, NewsSerializer

@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        return Response({
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'message': 'User registered successfully'
        }, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([AllowAny])
def login_user(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    if not email or not password:
        return Response({
            'error': 'Email and password are required'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        user = User.objects.get(email=email)
        if user.check_password(password):
            return Response({
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'message': 'Login successful'
            })
        else:
            return Response({
                'error': 'Invalid password'
            }, status=status.HTTP_400_BAD_REQUEST)
    except User.DoesNotExist:
        return Response({
            'error': 'User not found'
        }, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'message': 'User created successfully'
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TeamViewSet(viewsets.ModelViewSet):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

class TeamStatsViewSet(viewsets.ModelViewSet):
    queryset = TeamStats.objects.all()
    serializer_class = TeamStatsSerializer

class PlayerViewSet(viewsets.ModelViewSet):
    queryset = Player.objects.all()
    serializer_class = PlayerSerializer

class GameViewSet(viewsets.ModelViewSet):
    queryset = Game.objects.all()
    serializer_class = GameSerializer

class PlayerStatsViewSet(viewsets.ModelViewSet):
    queryset = PlayerStats.objects.all()
    serializer_class = PlayerStatsSerializer

class NewsViewSet(viewsets.ModelViewSet):
    queryset = News.objects.all().order_by('-created_at')
    serializer_class = NewsSerializer
