from rest_framework.routers import path

from hostels.views import HostelUpdateView

urlpatterns = [
    path("<int:pk>/", HostelUpdateView.as_view()),
]
