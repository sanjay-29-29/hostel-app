from django.urls import path, include

import users.views as users_views

urlpatterns = [
    path("token/", users_views.UserLoginView.as_view()),
    path(
        "users/",
        include(
            [
                path("", users_views.CreateUserView.as_view()),
                path("", users_views.RetrieveAndUpdateUserView.as_view()),
                path("all/", users_views.SearchAllUsersView.as_view()),
            ]
        ),
    ),
]
