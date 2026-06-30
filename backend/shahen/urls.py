from django.contrib import admin
from django.http import JsonResponse
from django.urls import path, include
from core.views import ListCreateAutoView, RetrieveUpdateDestroyAutoView
from django.conf import settings
from django.conf.urls.static import static
from core.views import MandobLogin,CaptainLogin,UserLogin,DeliveryCompanyLogin
from home.urls import urlpatterns as home_urls


def health_check(request):
    return JsonResponse({"status": "ok", "service": "shahen2"})

urlpatterns = [
    path('', health_check),
    path('health/', health_check),
    path('admin/', admin.site.urls),
    path('api/v1/<str:app>/<str:model>', ListCreateAutoView.as_view()),
    path('api/v1/<str:app>/<str:model>/<int:pk>', RetrieveUpdateDestroyAutoView.as_view()),
    path('api/v1/MandobLogin', MandobLogin.as_view()),
    path('api/v1/CaptainLogin', CaptainLogin.as_view()),
    path('api/v1/UserLogin', UserLogin.as_view()),
    path('api/v1/DeliveryCompanyLogin', DeliveryCompanyLogin.as_view()),

    path('', include(home_urls)),
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
