from django.urls import path, include

import users.views as users_views

urlpatterns = [
    path("token/", users_views.UserLoginView.as_view()),
    path(
        "users/",
        include(
            [
                path("", users_views.CreateUpdateUserView.as_view({"post": "create"})),
                path(
                    "<int:pk>/",
                    users_views.CreateUpdateUserView.as_view(
                        {
                            "get": "retrieve",
                            "put": "update",
                            "patch": "partial_update",
                            "delete": "destroy",
                        }
                    ),
                ),
                path("all/", users_views.SearchAllUsersView.as_view()),
                path("create-info/", users_views.CreateUserInfoGetView.as_view()),
            ]
        ),
    ),
]
