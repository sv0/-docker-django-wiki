
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include, path
from django.contrib import admin
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.http.response import HttpResponse

admin.autodiscover()

urlpatterns = [
    path('admin/', admin.site.urls),
    path('robots.txt', lambda _: HttpResponse('User-agent: *\nDisallow: /')),
    path('notify/', include('django_nyt.urls')),
    path('', include('wiki.urls'))
]

if settings.DEBUG:
    urlpatterns += staticfiles_urlpatterns()

    urlpatterns.extend(
        static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    )
    urlpatterns.extend(
        static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    )

handler500 = 'wikiproject.views.server_error'
handler404 = 'wikiproject.views.page_not_found'
