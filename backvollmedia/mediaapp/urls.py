from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework.authtoken.views import obtain_auth_token
from .views import UserViewSet, TeamViewSet, TeamStatsViewSet, PlayerViewSet, GameViewSet, PlayerStatsViewSet, register_user, login_user, NewsViewSet

router = DefaultRouter()
router.register('users', UserViewSet)
router.register('teams', TeamViewSet)
router.register('teamstats', TeamStatsViewSet)
router.register('players', PlayerViewSet)
router.register('games', GameViewSet)
router.register('playerstats', PlayerStatsViewSet)
router.register('news', NewsViewSet)
urlpatterns = [
    path('', include(router.urls)),
    path('register/', register_user, name='register'),
    path('login/', login_user, name='login'),
    path('token/', obtain_auth_token, name='token'),
]
