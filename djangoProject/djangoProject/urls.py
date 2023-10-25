from django.contrib import admin
from django.urls import path

from djangoProject.fileApi import create_file

urlpatterns = [
    path("file/", create_file, name="create_file"),
]
