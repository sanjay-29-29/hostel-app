from rest_framework.routers import DefaultRouter

from wastes.views import WasteViewSet

router = DefaultRouter()

router.register(r"", WasteViewSet, basename="waste")

urlpatterns = router.urls
