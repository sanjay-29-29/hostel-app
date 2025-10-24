from django.urls import path

from .views import StudentSearchView

urlpatterns = [path("student/", StudentSearchView.as_view())]
