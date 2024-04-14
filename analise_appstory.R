{
  "metadata": {
    "kernelspec": {
      "name": "ir",
      "display_name": "R",
      "language": "R"
    },
    "language_info": {
      "name": "R",
      "codemirror_mode": "r",
      "pygments_lexer": "r",
      "mimetype": "text/x-r-source",
      "file_extension": ".r",
      "version": "4.0.5"
    },
    "kaggle": {
      "accelerator": "none",
      "dataSources": [
        {
          "sourceId": 274957,
          "sourceType": "datasetVersion",
          "datasetId": 49864
        },
        {
          "sourceId": 8118102,
          "sourceType": "datasetVersion",
          "datasetId": 4796580
        }
      ],
      "dockerImageVersionId": 30618,
      "isInternetEnabled": false,
      "language": "r",
      "sourceType": "notebook",
      "isGpuEnabled": false
    },
    "colab": {
      "name": "analise_appstory",
      "provenance": []
    }
  },
  "nbformat_minor": 0,
  "nbformat": 4,
  "cells": [
    {
      "source": [
        "\n",
        "# IMPORTANT: RUN THIS CELL IN ORDER TO IMPORT YOUR KAGGLE DATA SOURCES\n",
        "# TO THE CORRECT LOCATION (/kaggle/input) IN YOUR NOTEBOOK,\n",
        "# THEN FEEL FREE TO DELETE THIS CELL.\n",
        "# NOTE: THIS NOTEBOOK ENVIRONMENT DIFFERS FROM KAGGLE'S R\n",
        "# ENVIRONMENT SO THERE MAY BE MISSING LIBRARIES USED BY YOUR\n",
        "# NOTEBOOK.\n",
        "\n",
        "DATA_SOURCE_MAPPING = 'google-play-store-apps:https%3A%2F%2Fstorage.googleapis.com%2Fkaggle-data-sets%2F49864%2F274957%2Fbundle%2Farchive.zip%3FX-Goog-Algorithm%3DGOOG4-RSA-SHA256%26X-Goog-Credential%3Dgcp-kaggle-com%2540kaggle-161607.iam.gserviceaccount.com%252F20240414%252Fauto%252Fstorage%252Fgoog4_request%26X-Goog-Date%3D20240414T170718Z%26X-Goog-Expires%3D259200%26X-Goog-SignedHeaders%3Dhost%26X-Goog-Signature%3Ddcfc821cf039117c59f8a4f6081b69fe4b46962eadd81ae99f3b37e499f2945c4707f5db12fd69e060d45d79632b89bec69af512b327ad05a83b58255d5c17ac8146fb929da3d5cd39f2c151ee5e4b2ac061a44695a4971fb6c433b42dfb74a77f77acff5d5c724fa7dfcd7a1ff9198a1f41fad1f254c0f264cfc9bd1f8cb54a34d0157b49febc9b8bce63a695c02f67e463ce72c794c984c9c856341346b6423f8f5980c6ec4d32a0de0dd4f54cdc90a1ba11e3c84ab807dd5fb4598873459ca2fca8259dbb2ba17c1d0a7d5fe7844371763ab28359f5eded7f50093f5c20d322e1ca5634fdaeff3fec93d424c34b3da2c5a7835c30f5d29dc04c61ca775f72,dataset-google-com-data:https%3A%2F%2Fstorage.googleapis.com%2Fkaggle-data-sets%2F4796580%2F8118102%2Fbundle%2Farchive.zip%3FX-Goog-Algorithm%3DGOOG4-RSA-SHA256%26X-Goog-Credential%3Dgcp-kaggle-com%2540kaggle-161607.iam.gserviceaccount.com%252F20240414%252Fauto%252Fstorage%252Fgoog4_request%26X-Goog-Date%3D20240414T170718Z%26X-Goog-Expires%3D259200%26X-Goog-SignedHeaders%3Dhost%26X-Goog-Signature%3D2d42588978819d45e81e7806c3e3ecac7627beac0eedac7b0eb77fb5ea1228f7cc5505bed5e185c899dabcb9d13f2b7912e71c16c632a71b29cb1d811ce00eeee897e1abe33c19badab6ec087511f223864ad0b85154eb8cf4277367d68cb2283eba45d22e187a1998b1fd444e025646b910a441034f0b39f7250b428364fb53243463896a38b307bc44445858f1995e23a3bbcf39f1c27d01235bc904f85e24d94a29f0fa97a53613cd5cdd6eeede1fcf68b865f2474f9bf9c7089e9f03f0f7567945fb614729404b9a882289948c86e1bea98bfaa488f5e5fd2e914da21ddb45ed9270be464738cdda64455c06a78f6ee782d1d7c119035edfffedd8db9bad'\n",
        "\n",
        "KAGGLE_INPUT_PATH = '/kaggle/input'\n",
        "KAGGLE_WORKING_PATH = '/kaggle/working'\n",
        "\n",
        "system(paste0('sudo umount ', '/kaggle/input'))\n",
        "system(paste0('sudo rmdir ', '/kaggle/input'))\n",
        "system(paste0('sudo mkdir -p -- ', KAGGLE_INPUT_PATH), intern=TRUE)\n",
        "system(paste0('sudo chmod 777 ', KAGGLE_INPUT_PATH), intern=TRUE)\n",
        "system(\n",
        "  paste0('sudo ln -sfn ', KAGGLE_INPUT_PATH,' ',file.path('..', 'input')),\n",
        "  intern=TRUE)\n",
        "\n",
        "system(paste0('sudo mkdir -p -- ', KAGGLE_WORKING_PATH), intern=TRUE)\n",
        "system(paste0('sudo chmod 777 ', KAGGLE_WORKING_PATH), intern=TRUE)\n",
        "system(\n",
        "  paste0('sudo ln -sfn ', KAGGLE_WORKING_PATH, ' ', file.path('..', 'working')),\n",
        "  intern=TRUE)\n",
        "\n",
        "data_source_mappings = strsplit(DATA_SOURCE_MAPPING, ',')[[1]]\n",
        "for (data_source_mapping in data_source_mappings) {\n",
        "    path_and_url = strsplit(data_source_mapping, ':')\n",
        "    directory = path_and_url[[1]][1]\n",
        "    download_url = URLdecode(path_and_url[[1]][2])\n",
        "    filename = sub(\"\\\\?.+\", \"\", download_url)\n",
        "    destination_path = file.path(KAGGLE_INPUT_PATH, directory)\n",
        "    print(paste0('Downloading and uncompressing: ', directory))\n",
        "    if (endsWith(filename, '.zip')){\n",
        "      temp = tempfile(fileext = '.zip')\n",
        "      download.file(download_url, temp)\n",
        "      unzip(temp, overwrite = TRUE, exdir = destination_path)\n",
        "      unlink(temp)\n",
        "    }\n",
        "    else{\n",
        "      temp = tempfile(fileext = '.tar')\n",
        "      download.file(download_url, temp)\n",
        "      untar(temp, exdir = destination_path)\n",
        "      unlink(temp)\n",
        "    }\n",
        "    print(paste0('Downloaded and uncompressed: ', directory))\n",
        "}\n",
        "\n",
        "print(paste0('Data source import complete'))\n"
      ],
      "metadata": {
        "id": "KQP0SPiSk-jQ",
        "outputId": "dd13df9c-ab86-43d1-e185-ea95b5f6bbab",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 104
        }
      },
      "cell_type": "code",
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [],
            "text/markdown": "",
            "text/latex": "",
            "text/plain": [
              "character(0)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [],
            "text/markdown": "",
            "text/latex": "",
            "text/plain": [
              "character(0)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [],
            "text/markdown": "",
            "text/latex": "",
            "text/plain": [
              "character(0)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [],
            "text/markdown": "",
            "text/latex": "",
            "text/plain": [
              "character(0)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [],
            "text/markdown": "",
            "text/latex": "",
            "text/plain": [
              "character(0)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [],
            "text/markdown": "",
            "text/latex": "",
            "text/plain": [
              "character(0)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "[1] \"Downloading and uncompressing: google-play-store-apps\"\n",
            "[1] \"Downloaded and uncompressed: google-play-store-apps\"\n",
            "[1] \"Downloading and uncompressing: dataset-google-com-data\"\n",
            "[1] \"Downloaded and uncompressed: dataset-google-com-data\"\n",
            "[1] \"Data source import complete\"\n"
          ]
        }
      ],
      "execution_count": 1
    },
    {
      "cell_type": "code",
      "source": [
        "# This R environment comes with many helpful analytics packages installed\n",
        "# It is defined by the kaggle/rstats Docker image: https://github.com/kaggle/docker-rstats\n",
        "# For example, here's a helpful package to load\n",
        "\n",
        "library(tidyverse) # metapackage of all tidyverse packages\n",
        "\n",
        "# Input data files are available in the read-only \"../input/\" directory\n",
        "# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory\n",
        "\n",
        "list.files(path = \"../input\")\n",
        "\n",
        "# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using \"Save & Run All\"\n",
        "# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session"
      ],
      "metadata": {
        "_uuid": "051d70d956493feee0c6d64651c6a088724dca2a",
        "_execution_state": "idle",
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:21.633278Z",
          "iopub.execute_input": "2024-04-14T16:55:21.636059Z",
          "iopub.status.idle": "2024-04-14T16:55:22.433505Z"
        },
        "trusted": true,
        "id": "vftorW9Nk-jW",
        "outputId": "2ecf94a8-7715-4189-d0cb-147658c8f1fb",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 208
        }
      },
      "execution_count": 2,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "── \u001b[1mAttaching core tidyverse packages\u001b[22m ──────────────────────── tidyverse 2.0.0 ──\n",
            "\u001b[32m✔\u001b[39m \u001b[34mdplyr    \u001b[39m 1.1.4     \u001b[32m✔\u001b[39m \u001b[34mreadr    \u001b[39m 2.1.5\n",
            "\u001b[32m✔\u001b[39m \u001b[34mforcats  \u001b[39m 1.0.0     \u001b[32m✔\u001b[39m \u001b[34mstringr  \u001b[39m 1.5.1\n",
            "\u001b[32m✔\u001b[39m \u001b[34mggplot2  \u001b[39m 3.4.4     \u001b[32m✔\u001b[39m \u001b[34mtibble   \u001b[39m 3.2.1\n",
            "\u001b[32m✔\u001b[39m \u001b[34mlubridate\u001b[39m 1.9.3     \u001b[32m✔\u001b[39m \u001b[34mtidyr    \u001b[39m 1.3.1\n",
            "\u001b[32m✔\u001b[39m \u001b[34mpurrr    \u001b[39m 1.0.2     \n",
            "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
            "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
            "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
            "\u001b[36mℹ\u001b[39m Use the conflicted package (\u001b[3m\u001b[34m<http://conflicted.r-lib.org/>\u001b[39m\u001b[23m) to force all conflicts to become errors\n"
          ]
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<style>\n",
              ".list-inline {list-style: none; margin:0; padding: 0}\n",
              ".list-inline>li {display: inline-block}\n",
              ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
              "</style>\n",
              "<ol class=list-inline><li>'dataset-google-com-data'</li><li>'google-play-store-apps'</li></ol>\n"
            ],
            "text/markdown": "1. 'dataset-google-com-data'\n2. 'google-play-store-apps'\n\n\n",
            "text/latex": "\\begin{enumerate*}\n\\item 'dataset-google-com-data'\n\\item 'google-play-store-apps'\n\\end{enumerate*}\n",
            "text/plain": [
              "[1] \"dataset-google-com-data\" \"google-play-store-apps\" "
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "path <- \"/kaggle/input/google-play-store-apps/googleplaystore.csv\"\n",
        "dados <- read.csv(file = path)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:22.441239Z",
          "iopub.execute_input": "2024-04-14T16:55:22.446734Z",
          "iopub.status.idle": "2024-04-14T16:55:22.714391Z"
        },
        "trusted": true,
        "id": "iijNRelCk-jY"
      },
      "execution_count": 3,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "View(dados)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:22.731989Z",
          "iopub.execute_input": "2024-04-14T16:55:22.74785Z",
          "iopub.status.idle": "2024-04-14T16:55:23.135849Z"
        },
        "trusted": true,
        "id": "RshQJlHpk-jY",
        "outputId": "f47bd1a5-ae2b-4885-bf07-95288d95b787",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 4,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "      App                                                Category           \n",
              "1     Photo Editor & Candy Camera & Grid & ScrapBook     ART_AND_DESIGN     \n",
              "2     Coloring book moana                                ART_AND_DESIGN     \n",
              "3     U Launcher Lite – FREE Live Cool Themes, Hide Apps ART_AND_DESIGN     \n",
              "4     Sketch - Draw & Paint                              ART_AND_DESIGN     \n",
              "5     Pixel Draw - Number Art Coloring Book              ART_AND_DESIGN     \n",
              "6     Paper flowers instructions                         ART_AND_DESIGN     \n",
              "7     Smoke Effect Photo Maker - Smoke Editor            ART_AND_DESIGN     \n",
              "8     Infinite Painter                                   ART_AND_DESIGN     \n",
              "9     Garden Coloring Book                               ART_AND_DESIGN     \n",
              "10    Kids Paint Free - Drawing Fun                      ART_AND_DESIGN     \n",
              "11    Text on Photo - Fonteee                            ART_AND_DESIGN     \n",
              "12    Name Art Photo Editor - Focus n Filters            ART_AND_DESIGN     \n",
              "13    Tattoo Name On My Photo Editor                     ART_AND_DESIGN     \n",
              "14    Mandala Coloring Book                              ART_AND_DESIGN     \n",
              "15    3D Color Pixel by Number - Sandbox Art Coloring    ART_AND_DESIGN     \n",
              "16    Learn To Draw Kawaii Characters                    ART_AND_DESIGN     \n",
              "17    Photo Designer - Write your name with shapes       ART_AND_DESIGN     \n",
              "18    350 Diy Room Decor Ideas                           ART_AND_DESIGN     \n",
              "19    FlipaClip - Cartoon animation                      ART_AND_DESIGN     \n",
              "20    ibis Paint X                                       ART_AND_DESIGN     \n",
              "21    Logo Maker - Small Business                        ART_AND_DESIGN     \n",
              "22    Boys Photo Editor - Six Pack & Men's Suit          ART_AND_DESIGN     \n",
              "23    Superheroes Wallpapers | 4K Backgrounds            ART_AND_DESIGN     \n",
              "24    Mcqueen Coloring pages                             ART_AND_DESIGN     \n",
              "25    HD Mickey Minnie Wallpapers                        ART_AND_DESIGN     \n",
              "26    Harley Quinn wallpapers HD                         ART_AND_DESIGN     \n",
              "27    Colorfit - Drawing & Coloring                      ART_AND_DESIGN     \n",
              "28    Animated Photo Editor                              ART_AND_DESIGN     \n",
              "29    Pencil Sketch Drawing                              ART_AND_DESIGN     \n",
              "30    Easy Realistic Drawing Tutorial                    ART_AND_DESIGN     \n",
              "⋮     ⋮                                                  ⋮                  \n",
              "10812 FR Plus 1.6                                        AUTO_AND_VEHICLES  \n",
              "10813 Fr Agnel Pune                                      FAMILY             \n",
              "10814 DICT.fr Mobile                                     BUSINESS           \n",
              "10815 FR: My Secret Pets!                                FAMILY             \n",
              "10816 Golden Dictionary (FR-AR)                          BOOKS_AND_REFERENCE\n",
              "10817 FieldBi FR Offline                                 BUSINESS           \n",
              "10818 HTC Sense Input - FR                               TOOLS              \n",
              "10819 Gold Quote - Gold.fr                               FINANCE            \n",
              "10820 Fanfic-FR                                          BOOKS_AND_REFERENCE\n",
              "10821 Fr. Daoud Lamei                                    FAMILY             \n",
              "10822 Poop FR                                            FAMILY             \n",
              "10823 PLMGSS FR                                          PRODUCTIVITY       \n",
              "10824 List iptv FR                                       VIDEO_PLAYERS      \n",
              "10825 Cardio-FR                                          MEDICAL            \n",
              "10826 Naruto & Boruto FR                                 SOCIAL             \n",
              "10827 Frim: get new friends on local chat rooms          SOCIAL             \n",
              "10828 Fr Agnel Ambarnath                                 FAMILY             \n",
              "10829 Manga-FR - Anime Vostfr                            COMICS             \n",
              "10830 Bulgarian French Dictionary Fr                     BOOKS_AND_REFERENCE\n",
              "10831 News Minecraft.fr                                  NEWS_AND_MAGAZINES \n",
              "10832 payermonstationnement.fr                           MAPS_AND_NAVIGATION\n",
              "10833 FR Tides                                           WEATHER            \n",
              "10834 Chemin (fr)                                        BOOKS_AND_REFERENCE\n",
              "10835 FR Calculator                                      FAMILY             \n",
              "10836 FR Forms                                           BUSINESS           \n",
              "10837 Sya9a Maroc - FR                                   FAMILY             \n",
              "10838 Fr. Mike Schmitz Audio Teachings                   FAMILY             \n",
              "10839 Parkinson Exercices FR                             MEDICAL            \n",
              "10840 The SCP Foundation DB fr nn5n                      BOOKS_AND_REFERENCE\n",
              "10841 iHoroscope - 2018 Daily Horoscope & Astrology      LIFESTYLE          \n",
              "      Rating Reviews Size               Installs    Type Price Content.Rating\n",
              "1     4.1    159     19M                10,000+     Free 0     Everyone      \n",
              "2     3.9    967     14M                500,000+    Free 0     Everyone      \n",
              "3     4.7    87510   8.7M               5,000,000+  Free 0     Everyone      \n",
              "4     4.5    215644  25M                50,000,000+ Free 0     Teen          \n",
              "5     4.3    967     2.8M               100,000+    Free 0     Everyone      \n",
              "6     4.4    167     5.6M               50,000+     Free 0     Everyone      \n",
              "7     3.8    178     19M                50,000+     Free 0     Everyone      \n",
              "8     4.1    36815   29M                1,000,000+  Free 0     Everyone      \n",
              "9     4.4    13791   33M                1,000,000+  Free 0     Everyone      \n",
              "10    4.7    121     3.1M               10,000+     Free 0     Everyone      \n",
              "11    4.4    13880   28M                1,000,000+  Free 0     Everyone      \n",
              "12    4.4    8788    12M                1,000,000+  Free 0     Everyone      \n",
              "13    4.2    44829   20M                10,000,000+ Free 0     Teen          \n",
              "14    4.6    4326    21M                100,000+    Free 0     Everyone      \n",
              "15    4.4    1518    37M                100,000+    Free 0     Everyone      \n",
              "16    3.2    55      2.7M               5,000+      Free 0     Everyone      \n",
              "17    4.7    3632    5.5M               500,000+    Free 0     Everyone      \n",
              "18    4.5    27      17M                10,000+     Free 0     Everyone      \n",
              "19    4.3    194216  39M                5,000,000+  Free 0     Everyone      \n",
              "20    4.6    224399  31M                10,000,000+ Free 0     Everyone      \n",
              "21    4.0    450     14M                100,000+    Free 0     Everyone      \n",
              "22    4.1    654     12M                100,000+    Free 0     Everyone      \n",
              "23    4.7    7699    4.2M               500,000+    Free 0     Everyone 10+  \n",
              "24    NaN    61      7.0M               100,000+    Free 0     Everyone      \n",
              "25    4.7    118     23M                50,000+     Free 0     Everyone      \n",
              "26    4.8    192     6.0M               10,000+     Free 0     Everyone      \n",
              "27    4.7    20260   25M                500,000+    Free 0     Everyone      \n",
              "28    4.1    203     6.1M               100,000+    Free 0     Everyone      \n",
              "29    3.9    136     4.6M               10,000+     Free 0     Everyone      \n",
              "30    4.1    223     4.2M               100,000+    Free 0     Everyone      \n",
              "⋮     ⋮      ⋮       ⋮                  ⋮           ⋮    ⋮     ⋮             \n",
              "10812 NaN    4       3.9M               100+        Free 0     Everyone      \n",
              "10813 4.1    80      13M                1,000+      Free 0     Everyone      \n",
              "10814 NaN    20      2.7M               10,000+     Free 0     Everyone      \n",
              "10815 4.0    785     31M                50,000+     Free 0     Teen          \n",
              "10816 4.2    5775    4.9M               500,000+    Free 0     Everyone      \n",
              "10817 NaN    2       6.8M               100+        Free 0     Everyone      \n",
              "10818 4.0    885     8.0M               100,000+    Free 0     Everyone      \n",
              "10819 NaN    96      1.5M               10,000+     Free 0     Everyone      \n",
              "10820 3.3    52      3.6M               5,000+      Free 0     Teen          \n",
              "10821 5.0    22      8.6M               1,000+      Free 0     Teen          \n",
              "10822 NaN    6       2.5M               50+         Free 0     Everyone      \n",
              "10823 NaN    0       3.1M               10+         Free 0     Everyone      \n",
              "10824 NaN    1       2.9M               100+        Free 0     Everyone      \n",
              "10825 NaN    67      82M                10,000+     Free 0     Everyone      \n",
              "10826 NaN    7       7.7M               100+        Free 0     Teen          \n",
              "10827 4.0    88486   Varies with device 5,000,000+  Free 0     Mature 17+    \n",
              "10828 4.2    117     13M                5,000+      Free 0     Everyone      \n",
              "10829 3.4    291     13M                10,000+     Free 0     Everyone      \n",
              "10830 4.6    603     7.4M               10,000+     Free 0     Everyone      \n",
              "10831 3.8    881     2.3M               100,000+    Free 0     Everyone      \n",
              "10832 NaN    38      9.8M               5,000+      Free 0     Everyone      \n",
              "10833 3.8    1195    582k               100,000+    Free 0     Everyone      \n",
              "10834 4.8    44      619k               1,000+      Free 0     Everyone      \n",
              "10835 4.0    7       2.6M               500+        Free 0     Everyone      \n",
              "10836 NaN    0       9.6M               10+         Free 0     Everyone      \n",
              "10837 4.5    38      53M                5,000+      Free 0     Everyone      \n",
              "10838 5.0    4       3.6M               100+        Free 0     Everyone      \n",
              "10839 NaN    3       9.5M               1,000+      Free 0     Everyone      \n",
              "10840 4.5    114     Varies with device 1,000+      Free 0     Mature 17+    \n",
              "10841 4.5    398307  19M                10,000,000+ Free 0     Everyone      \n",
              "      Genres                          Last.Updated       Current.Ver       \n",
              "1     Art & Design                    January 7, 2018    1.0.0             \n",
              "2     Art & Design;Pretend Play       January 15, 2018   2.0.0             \n",
              "3     Art & Design                    August 1, 2018     1.2.4             \n",
              "4     Art & Design                    June 8, 2018       Varies with device\n",
              "5     Art & Design;Creativity         June 20, 2018      1.1               \n",
              "6     Art & Design                    March 26, 2017     1.0               \n",
              "7     Art & Design                    April 26, 2018     1.1               \n",
              "8     Art & Design                    June 14, 2018      6.1.61.1          \n",
              "9     Art & Design                    September 20, 2017 2.9.2             \n",
              "10    Art & Design;Creativity         July 3, 2018       2.8               \n",
              "11    Art & Design                    October 27, 2017   1.0.4             \n",
              "12    Art & Design                    July 31, 2018      1.0.15            \n",
              "13    Art & Design                    April 2, 2018      3.8               \n",
              "14    Art & Design                    June 26, 2018      1.0.4             \n",
              "15    Art & Design                    August 3, 2018     1.2.3             \n",
              "16    Art & Design                    June 6, 2018       NaN               \n",
              "17    Art & Design                    July 31, 2018      3.1               \n",
              "18    Art & Design                    November 7, 2017   1.0               \n",
              "19    Art & Design                    August 3, 2018     2.2.5             \n",
              "20    Art & Design                    July 30, 2018      5.5.4             \n",
              "21    Art & Design                    April 20, 2018     4.0               \n",
              "22    Art & Design                    March 20, 2018     1.1               \n",
              "23    Art & Design                    July 12, 2018      2.2.6.2           \n",
              "24    Art & Design;Action & Adventure March 7, 2018      1.0.0             \n",
              "25    Art & Design                    July 7, 2018       1.1.3             \n",
              "26    Art & Design                    April 25, 2018     1.5               \n",
              "27    Art & Design;Creativity         October 11, 2017   1.0.8             \n",
              "28    Art & Design                    March 21, 2018     1.03              \n",
              "29    Art & Design                    July 12, 2018      6.0               \n",
              "30    Art & Design                    August 22, 2017    1.0               \n",
              "⋮     ⋮                               ⋮                  ⋮                 \n",
              "10812 Auto & Vehicles                 July 24, 2018      1.3.6             \n",
              "10813 Education                       June 13, 2018      2.0.20            \n",
              "10814 Business                        July 17, 2018      2.1.10            \n",
              "10815 Entertainment                   June 3, 2015       1.3.1             \n",
              "10816 Books & Reference               July 19, 2018      7.0.4.6           \n",
              "10817 Business                        August 6, 2018     2.1.8             \n",
              "10818 Tools                           October 30, 2015   1.0.612928        \n",
              "10819 Finance                         May 19, 2016       2.3               \n",
              "10820 Books & Reference               August 5, 2017     0.3.4             \n",
              "10821 Education                       June 27, 2018      3.8.0             \n",
              "10822 Entertainment                   May 29, 2018       1.0               \n",
              "10823 Productivity                    December 1, 2017   1                 \n",
              "10824 Video Players & Editors         April 22, 2018     1.0               \n",
              "10825 Medical                         July 31, 2018      2.2.2             \n",
              "10826 Social                          February 2, 2018   1.0               \n",
              "10827 Social                          March 23, 2018     Varies with device\n",
              "10828 Education                       June 13, 2018      2.0.20            \n",
              "10829 Comics                          May 15, 2017       2.0.1             \n",
              "10830 Books & Reference               June 19, 2016      2.96              \n",
              "10831 News & Magazines                January 20, 2014   1.5               \n",
              "10832 Maps & Navigation               June 13, 2018      2.0.148.0         \n",
              "10833 Weather                         February 16, 2014  6.0               \n",
              "10834 Books & Reference               March 23, 2014     0.8               \n",
              "10835 Education                       June 18, 2017      1.0.0             \n",
              "10836 Business                        September 29, 2016 1.1.5             \n",
              "10837 Education                       July 25, 2017      1.48              \n",
              "10838 Education                       July 6, 2018       1.0               \n",
              "10839 Medical                         January 20, 2017   1.0               \n",
              "10840 Books & Reference               January 19, 2015   Varies with device\n",
              "10841 Lifestyle                       July 25, 2018      Varies with device\n",
              "      Android.Ver       \n",
              "1     4.0.3 and up      \n",
              "2     4.0.3 and up      \n",
              "3     4.0.3 and up      \n",
              "4     4.2 and up        \n",
              "5     4.4 and up        \n",
              "6     2.3 and up        \n",
              "7     4.0.3 and up      \n",
              "8     4.2 and up        \n",
              "9     3.0 and up        \n",
              "10    4.0.3 and up      \n",
              "11    4.1 and up        \n",
              "12    4.0 and up        \n",
              "13    4.1 and up        \n",
              "14    4.4 and up        \n",
              "15    2.3 and up        \n",
              "16    4.2 and up        \n",
              "17    4.1 and up        \n",
              "18    2.3 and up        \n",
              "19    4.0.3 and up      \n",
              "20    4.1 and up        \n",
              "21    4.1 and up        \n",
              "22    4.0.3 and up      \n",
              "23    4.0.3 and up      \n",
              "24    4.1 and up        \n",
              "25    4.1 and up        \n",
              "26    3.0 and up        \n",
              "27    4.0.3 and up      \n",
              "28    4.0.3 and up      \n",
              "29    2.3 and up        \n",
              "30    2.3 and up        \n",
              "⋮     ⋮                 \n",
              "10812 4.4W and up       \n",
              "10813 4.0.3 and up      \n",
              "10814 4.1 and up        \n",
              "10815 3.0 and up        \n",
              "10816 4.2 and up        \n",
              "10817 4.1 and up        \n",
              "10818 5.0 and up        \n",
              "10819 2.2 and up        \n",
              "10820 4.1 and up        \n",
              "10821 4.1 and up        \n",
              "10822 4.0.3 and up      \n",
              "10823 4.4 and up        \n",
              "10824 4.0.3 and up      \n",
              "10825 4.4 and up        \n",
              "10826 4.0 and up        \n",
              "10827 Varies with device\n",
              "10828 4.0.3 and up      \n",
              "10829 4.0 and up        \n",
              "10830 4.1 and up        \n",
              "10831 1.6 and up        \n",
              "10832 4.0 and up        \n",
              "10833 2.1 and up        \n",
              "10834 2.2 and up        \n",
              "10835 4.1 and up        \n",
              "10836 4.0 and up        \n",
              "10837 4.1 and up        \n",
              "10838 4.1 and up        \n",
              "10839 2.2 and up        \n",
              "10840 Varies with device\n",
              "10841 Varies with device"
            ],
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 10841 × 13</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>App</th><th scope=col>Category</th><th scope=col>Rating</th><th scope=col>Reviews</th><th scope=col>Size</th><th scope=col>Installs</th><th scope=col>Type</th><th scope=col>Price</th><th scope=col>Content.Rating</th><th scope=col>Genres</th><th scope=col>Last.Updated</th><th scope=col>Current.Ver</th><th scope=col>Android.Ver</th></tr>\n",
              "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook    </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>159   </span></td><td>19M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>January 7, 2018   </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Coloring book moana                               </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>967   </span></td><td>14M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Pretend Play      </span></td><td><span style=white-space:pre-wrap>January 15, 2018  </span></td><td><span style=white-space:pre-wrap>2.0.0             </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td>U Launcher Lite – FREE Live Cool Themes, Hide Apps</td><td>ART_AND_DESIGN</td><td>4.7</td><td>87510 </td><td>8.7M</td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 1, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.4             </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Sketch - Draw &amp; Paint                             </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td>215644</td><td>25M </td><td>50,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 8, 2018      </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>4.2 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pixel Draw - Number Art Coloring Book             </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td><span style=white-space:pre-wrap>967   </span></td><td>2.8M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>June 20, 2018     </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Paper flowers instructions                        </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>167   </span></td><td>5.6M</td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 26, 2017    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Smoke Effect Photo Maker - Smoke Editor           </span></td><td>ART_AND_DESIGN</td><td>3.8</td><td><span style=white-space:pre-wrap>178   </span></td><td>19M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 26, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Infinite Painter                                  </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td>36815 </td><td>29M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 14, 2018     </span></td><td><span style=white-space:pre-wrap>6.1.61.1          </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Garden Coloring Book                              </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13791 </td><td>33M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td>September 20, 2017</td><td><span style=white-space:pre-wrap>2.9.2             </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Kids Paint Free - Drawing Fun                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>121   </span></td><td>3.1M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>July 3, 2018      </span></td><td><span style=white-space:pre-wrap>2.8               </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Text on Photo - Fonteee                           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13880 </td><td>28M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>October 27, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Name Art Photo Editor - Focus n Filters           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>8788  </span></td><td>12M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.15            </span></td><td><span style=white-space:pre-wrap>4.0 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Tattoo Name On My Photo Editor                    </span></td><td>ART_AND_DESIGN</td><td>4.2</td><td>44829 </td><td>20M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 2, 2018     </span></td><td><span style=white-space:pre-wrap>3.8               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mandala Coloring Book                             </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td><span style=white-space:pre-wrap>4326  </span></td><td>21M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 26, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>3D Color Pixel by Number - Sandbox Art Coloring   </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>1518  </span></td><td>37M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.3             </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Learn To Draw Kawaii Characters                   </span></td><td>ART_AND_DESIGN</td><td>3.2</td><td><span style=white-space:pre-wrap>55    </span></td><td>2.7M</td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 6, 2018      </span></td><td><span style=white-space:pre-wrap>NaN               </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Designer - Write your name with shapes      </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>3632  </span></td><td>5.5M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>3.1               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>350 Diy Room Decor Ideas                          </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td><span style=white-space:pre-wrap>27    </span></td><td>17M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>November 7, 2017  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FlipaClip - Cartoon animation                     </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td>194216</td><td>39M </td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>2.2.5             </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>ibis Paint X                                      </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td>224399</td><td>31M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 30, 2018     </span></td><td><span style=white-space:pre-wrap>5.5.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Logo Maker - Small Business                       </span></td><td>ART_AND_DESIGN</td><td>4.0</td><td><span style=white-space:pre-wrap>450   </span></td><td>14M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 20, 2018    </span></td><td><span style=white-space:pre-wrap>4.0               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Boys Photo Editor - Six Pack &amp; Men's Suit         </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>654   </span></td><td>12M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 20, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Superheroes Wallpapers | 4K Backgrounds           </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>7699  </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td>Everyone 10+</td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>2.2.6.2           </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mcqueen Coloring pages                            </span></td><td>ART_AND_DESIGN</td><td>NaN</td><td><span style=white-space:pre-wrap>61    </span></td><td>7.0M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td>Art &amp; Design;Action &amp; Adventure</td><td><span style=white-space:pre-wrap>March 7, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>HD Mickey Minnie Wallpapers                       </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>118   </span></td><td>23M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 7, 2018      </span></td><td><span style=white-space:pre-wrap>1.1.3             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Harley Quinn wallpapers HD                        </span></td><td>ART_AND_DESIGN</td><td>4.8</td><td><span style=white-space:pre-wrap>192   </span></td><td>6.0M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 25, 2018    </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Colorfit - Drawing &amp; Coloring                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td>20260 </td><td>25M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>October 11, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.8             </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Animated Photo Editor                             </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>203   </span></td><td>6.1M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 21, 2018    </span></td><td><span style=white-space:pre-wrap>1.03              </span></td><td>4.0.3 and up</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pencil Sketch Drawing                             </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>136   </span></td><td>4.6M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>6.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Easy Realistic Drawing Tutorial                   </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>223   </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 22, 2017   </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td></tr>\n",
              "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FR Plus 1.6                                  </span></td><td><span style=white-space:pre-wrap>AUTO_AND_VEHICLES  </span></td><td>NaN</td><td><span style=white-space:pre-wrap>4     </span></td><td><span style=white-space:pre-wrap>3.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Auto &amp; Vehicles        </span></td><td><span style=white-space:pre-wrap>July 24, 2018     </span></td><td><span style=white-space:pre-wrap>1.3.6             </span></td><td><span style=white-space:pre-wrap>4.4W and up       </span></td></tr>\n",
              "\t<tr><td>Fr Agnel Pune                                </td><td>FAMILY             </td><td>4.1</td><td>80    </td><td>13M               </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td></tr>\n",
              "\t<tr><td>DICT.fr Mobile                               </td><td>BUSINESS           </td><td>NaN</td><td>20    </td><td>2.7M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>July 17, 2018     </td><td>2.1.10            </td><td>4.1 and up        </td></tr>\n",
              "\t<tr><td>FR: My Secret Pets!                          </td><td>FAMILY             </td><td>4.0</td><td>785   </td><td>31M               </td><td>50,000+    </td><td>Free</td><td>0</td><td>Teen      </td><td>Entertainment          </td><td>June 3, 2015      </td><td>1.3.1             </td><td>3.0 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Golden Dictionary (FR-AR)                    </span></td><td>BOOKS_AND_REFERENCE</td><td>4.2</td><td><span style=white-space:pre-wrap>5775  </span></td><td><span style=white-space:pre-wrap>4.9M              </span></td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>July 19, 2018     </span></td><td><span style=white-space:pre-wrap>7.0.4.6           </span></td><td><span style=white-space:pre-wrap>4.2 and up        </span></td></tr>\n",
              "\t<tr><td>FieldBi FR Offline                           </td><td>BUSINESS           </td><td>NaN</td><td>2     </td><td>6.8M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>August 6, 2018    </td><td>2.1.8             </td><td>4.1 and up        </td></tr>\n",
              "\t<tr><td>HTC Sense Input - FR                         </td><td>TOOLS              </td><td>4.0</td><td>885   </td><td>8.0M              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Tools                  </td><td>October 30, 2015  </td><td>1.0.612928        </td><td>5.0 and up        </td></tr>\n",
              "\t<tr><td>Gold Quote - Gold.fr                         </td><td>FINANCE            </td><td>NaN</td><td>96    </td><td>1.5M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Finance                </td><td>May 19, 2016      </td><td>2.3               </td><td>2.2 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Fanfic-FR                                    </span></td><td>BOOKS_AND_REFERENCE</td><td>3.3</td><td><span style=white-space:pre-wrap>52    </span></td><td><span style=white-space:pre-wrap>3.6M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>August 5, 2017    </span></td><td><span style=white-space:pre-wrap>0.3.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td></tr>\n",
              "\t<tr><td>Fr. Daoud Lamei                              </td><td>FAMILY             </td><td>5.0</td><td>22    </td><td>8.6M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Teen      </td><td>Education              </td><td>June 27, 2018     </td><td>3.8.0             </td><td>4.1 and up        </td></tr>\n",
              "\t<tr><td>Poop FR                                      </td><td>FAMILY             </td><td>NaN</td><td>6     </td><td>2.5M              </td><td>50+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Entertainment          </td><td>May 29, 2018      </td><td>1.0               </td><td>4.0.3 and up      </td></tr>\n",
              "\t<tr><td>PLMGSS FR                                    </td><td>PRODUCTIVITY       </td><td>NaN</td><td>0     </td><td>3.1M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Productivity           </td><td>December 1, 2017  </td><td>1                 </td><td>4.4 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>List iptv FR                                 </span></td><td><span style=white-space:pre-wrap>VIDEO_PLAYERS      </span></td><td>NaN</td><td><span style=white-space:pre-wrap>1     </span></td><td><span style=white-space:pre-wrap>2.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td>Video Players &amp; Editors</td><td><span style=white-space:pre-wrap>April 22, 2018    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0.3 and up      </span></td></tr>\n",
              "\t<tr><td>Cardio-FR                                    </td><td>MEDICAL            </td><td>NaN</td><td>67    </td><td>82M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>July 31, 2018     </td><td>2.2.2             </td><td>4.4 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Naruto &amp; Boruto FR                           </span></td><td><span style=white-space:pre-wrap>SOCIAL             </span></td><td>NaN</td><td><span style=white-space:pre-wrap>7     </span></td><td><span style=white-space:pre-wrap>7.7M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Social                 </span></td><td><span style=white-space:pre-wrap>February 2, 2018  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td></tr>\n",
              "\t<tr><td>Frim: get new friends on local chat rooms    </td><td>SOCIAL             </td><td>4.0</td><td>88486 </td><td>Varies with device</td><td>5,000,000+ </td><td>Free</td><td>0</td><td>Mature 17+</td><td>Social                 </td><td>March 23, 2018    </td><td>Varies with device</td><td>Varies with device</td></tr>\n",
              "\t<tr><td>Fr Agnel Ambarnath                           </td><td>FAMILY             </td><td>4.2</td><td>117   </td><td>13M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td></tr>\n",
              "\t<tr><td>Manga-FR - Anime Vostfr                      </td><td>COMICS             </td><td>3.4</td><td>291   </td><td>13M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Comics                 </td><td>May 15, 2017      </td><td>2.0.1             </td><td>4.0 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Bulgarian French Dictionary Fr               </span></td><td>BOOKS_AND_REFERENCE</td><td>4.6</td><td><span style=white-space:pre-wrap>603   </span></td><td><span style=white-space:pre-wrap>7.4M              </span></td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>June 19, 2016     </span></td><td><span style=white-space:pre-wrap>2.96              </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>News Minecraft.fr                            </span></td><td>NEWS_AND_MAGAZINES </td><td>3.8</td><td><span style=white-space:pre-wrap>881   </span></td><td><span style=white-space:pre-wrap>2.3M              </span></td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>News &amp; Magazines       </span></td><td><span style=white-space:pre-wrap>January 20, 2014  </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>1.6 and up        </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>payermonstationnement.fr                     </span></td><td>MAPS_AND_NAVIGATION</td><td>NaN</td><td><span style=white-space:pre-wrap>38    </span></td><td><span style=white-space:pre-wrap>9.8M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Maps &amp; Navigation      </span></td><td><span style=white-space:pre-wrap>June 13, 2018     </span></td><td><span style=white-space:pre-wrap>2.0.148.0         </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td></tr>\n",
              "\t<tr><td>FR Tides                                     </td><td>WEATHER            </td><td>3.8</td><td>1195  </td><td>582k              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Weather                </td><td>February 16, 2014 </td><td>6.0               </td><td>2.1 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Chemin (fr)                                  </span></td><td>BOOKS_AND_REFERENCE</td><td>4.8</td><td><span style=white-space:pre-wrap>44    </span></td><td><span style=white-space:pre-wrap>619k              </span></td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>March 23, 2014    </span></td><td><span style=white-space:pre-wrap>0.8               </span></td><td><span style=white-space:pre-wrap>2.2 and up        </span></td></tr>\n",
              "\t<tr><td>FR Calculator                                </td><td>FAMILY             </td><td>4.0</td><td>7     </td><td>2.6M              </td><td>500+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 18, 2017     </td><td>1.0.0             </td><td>4.1 and up        </td></tr>\n",
              "\t<tr><td>FR Forms                                     </td><td>BUSINESS           </td><td>NaN</td><td>0     </td><td>9.6M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>September 29, 2016</td><td>1.1.5             </td><td>4.0 and up        </td></tr>\n",
              "\t<tr><td>Sya9a Maroc - FR                             </td><td>FAMILY             </td><td>4.5</td><td>38    </td><td>53M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 25, 2017     </td><td>1.48              </td><td>4.1 and up        </td></tr>\n",
              "\t<tr><td>Fr. Mike Schmitz Audio Teachings             </td><td>FAMILY             </td><td>5.0</td><td>4     </td><td>3.6M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 6, 2018      </td><td>1.0               </td><td>4.1 and up        </td></tr>\n",
              "\t<tr><td>Parkinson Exercices FR                       </td><td>MEDICAL            </td><td>NaN</td><td>3     </td><td>9.5M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>January 20, 2017  </td><td>1.0               </td><td>2.2 and up        </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>The SCP Foundation DB fr nn5n                </span></td><td>BOOKS_AND_REFERENCE</td><td>4.5</td><td><span style=white-space:pre-wrap>114   </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td>Mature 17+</td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>January 19, 2015  </span></td><td>Varies with device</td><td>Varies with device</td></tr>\n",
              "\t<tr><td>iHoroscope - 2018 Daily Horoscope &amp; Astrology</td><td><span style=white-space:pre-wrap>LIFESTYLE          </span></td><td>4.5</td><td>398307</td><td><span style=white-space:pre-wrap>19M               </span></td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Lifestyle              </span></td><td><span style=white-space:pre-wrap>July 25, 2018     </span></td><td>Varies with device</td><td>Varies with device</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 10841 × 13\n\n| App &lt;chr&gt; | Category &lt;chr&gt; | Rating &lt;dbl&gt; | Reviews &lt;chr&gt; | Size &lt;chr&gt; | Installs &lt;chr&gt; | Type &lt;chr&gt; | Price &lt;chr&gt; | Content.Rating &lt;chr&gt; | Genres &lt;chr&gt; | Last.Updated &lt;chr&gt; | Current.Ver &lt;chr&gt; | Android.Ver &lt;chr&gt; |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|\n| Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook     | ART_AND_DESIGN | 4.1 | 159    | 19M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | January 7, 2018    | 1.0.0              | 4.0.3 and up |\n| Coloring book moana                                | ART_AND_DESIGN | 3.9 | 967    | 14M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Pretend Play       | January 15, 2018   | 2.0.0              | 4.0.3 and up |\n| U Launcher Lite – FREE Live Cool Themes, Hide Apps | ART_AND_DESIGN | 4.7 | 87510  | 8.7M | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 1, 2018     | 1.2.4              | 4.0.3 and up |\n| Sketch - Draw &amp; Paint                              | ART_AND_DESIGN | 4.5 | 215644 | 25M  | 50,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | June 8, 2018       | Varies with device | 4.2 and up   |\n| Pixel Draw - Number Art Coloring Book              | ART_AND_DESIGN | 4.3 | 967    | 2.8M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | June 20, 2018      | 1.1                | 4.4 and up   |\n| Paper flowers instructions                         | ART_AND_DESIGN | 4.4 | 167    | 5.6M | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | March 26, 2017     | 1.0                | 2.3 and up   |\n| Smoke Effect Photo Maker - Smoke Editor            | ART_AND_DESIGN | 3.8 | 178    | 19M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 26, 2018     | 1.1                | 4.0.3 and up |\n| Infinite Painter                                   | ART_AND_DESIGN | 4.1 | 36815  | 29M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | June 14, 2018      | 6.1.61.1           | 4.2 and up   |\n| Garden Coloring Book                               | ART_AND_DESIGN | 4.4 | 13791  | 33M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | September 20, 2017 | 2.9.2              | 3.0 and up   |\n| Kids Paint Free - Drawing Fun                      | ART_AND_DESIGN | 4.7 | 121    | 3.1M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design;Creativity         | July 3, 2018       | 2.8                | 4.0.3 and up |\n| Text on Photo - Fonteee                            | ART_AND_DESIGN | 4.4 | 13880  | 28M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | October 27, 2017   | 1.0.4              | 4.1 and up   |\n| Name Art Photo Editor - Focus n Filters            | ART_AND_DESIGN | 4.4 | 8788   | 12M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 1.0.15             | 4.0 and up   |\n| Tattoo Name On My Photo Editor                     | ART_AND_DESIGN | 4.2 | 44829  | 20M  | 10,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | April 2, 2018      | 3.8                | 4.1 and up   |\n| Mandala Coloring Book                              | ART_AND_DESIGN | 4.6 | 4326   | 21M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | June 26, 2018      | 1.0.4              | 4.4 and up   |\n| 3D Color Pixel by Number - Sandbox Art Coloring    | ART_AND_DESIGN | 4.4 | 1518   | 37M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 1.2.3              | 2.3 and up   |\n| Learn To Draw Kawaii Characters                    | ART_AND_DESIGN | 3.2 | 55     | 2.7M | 5,000+      | Free | 0 | Everyone     | Art &amp; Design                    | June 6, 2018       | NaN                | 4.2 and up   |\n| Photo Designer - Write your name with shapes       | ART_AND_DESIGN | 4.7 | 3632   | 5.5M | 500,000+    | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 3.1                | 4.1 and up   |\n| 350 Diy Room Decor Ideas                           | ART_AND_DESIGN | 4.5 | 27     | 17M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | November 7, 2017   | 1.0                | 2.3 and up   |\n| FlipaClip - Cartoon animation                      | ART_AND_DESIGN | 4.3 | 194216 | 39M  | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 2.2.5              | 4.0.3 and up |\n| ibis Paint X                                       | ART_AND_DESIGN | 4.6 | 224399 | 31M  | 10,000,000+ | Free | 0 | Everyone     | Art &amp; Design                    | July 30, 2018      | 5.5.4              | 4.1 and up   |\n| Logo Maker - Small Business                        | ART_AND_DESIGN | 4.0 | 450    | 14M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | April 20, 2018     | 4.0                | 4.1 and up   |\n| Boys Photo Editor - Six Pack &amp; Men's Suit          | ART_AND_DESIGN | 4.1 | 654    | 12M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 20, 2018     | 1.1                | 4.0.3 and up |\n| Superheroes Wallpapers | 4K Backgrounds            | ART_AND_DESIGN | 4.7 | 7699   | 4.2M | 500,000+    | Free | 0 | Everyone 10+ | Art &amp; Design                    | July 12, 2018      | 2.2.6.2            | 4.0.3 and up |\n| Mcqueen Coloring pages                             | ART_AND_DESIGN | NaN | 61     | 7.0M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Action &amp; Adventure | March 7, 2018      | 1.0.0              | 4.1 and up   |\n| HD Mickey Minnie Wallpapers                        | ART_AND_DESIGN | 4.7 | 118    | 23M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 7, 2018       | 1.1.3              | 4.1 and up   |\n| Harley Quinn wallpapers HD                         | ART_AND_DESIGN | 4.8 | 192    | 6.0M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 25, 2018     | 1.5                | 3.0 and up   |\n| Colorfit - Drawing &amp; Coloring                      | ART_AND_DESIGN | 4.7 | 20260  | 25M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | October 11, 2017   | 1.0.8              | 4.0.3 and up |\n| Animated Photo Editor                              | ART_AND_DESIGN | 4.1 | 203    | 6.1M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 21, 2018     | 1.03               | 4.0.3 and up |\n| Pencil Sketch Drawing                              | ART_AND_DESIGN | 3.9 | 136    | 4.6M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 12, 2018      | 6.0                | 2.3 and up   |\n| Easy Realistic Drawing Tutorial                    | ART_AND_DESIGN | 4.1 | 223    | 4.2M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 22, 2017    | 1.0                | 2.3 and up   |\n| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n| FR Plus 1.6                                   | AUTO_AND_VEHICLES   | NaN | 4      | 3.9M               | 100+        | Free | 0 | Everyone   | Auto &amp; Vehicles         | July 24, 2018      | 1.3.6              | 4.4W and up        |\n| Fr Agnel Pune                                 | FAMILY              | 4.1 | 80     | 13M                | 1,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       |\n| DICT.fr Mobile                                | BUSINESS            | NaN | 20     | 2.7M               | 10,000+     | Free | 0 | Everyone   | Business                | July 17, 2018      | 2.1.10             | 4.1 and up         |\n| FR: My Secret Pets!                           | FAMILY              | 4.0 | 785    | 31M                | 50,000+     | Free | 0 | Teen       | Entertainment           | June 3, 2015       | 1.3.1              | 3.0 and up         |\n| Golden Dictionary (FR-AR)                     | BOOKS_AND_REFERENCE | 4.2 | 5775   | 4.9M               | 500,000+    | Free | 0 | Everyone   | Books &amp; Reference       | July 19, 2018      | 7.0.4.6            | 4.2 and up         |\n| FieldBi FR Offline                            | BUSINESS            | NaN | 2      | 6.8M               | 100+        | Free | 0 | Everyone   | Business                | August 6, 2018     | 2.1.8              | 4.1 and up         |\n| HTC Sense Input - FR                          | TOOLS               | 4.0 | 885    | 8.0M               | 100,000+    | Free | 0 | Everyone   | Tools                   | October 30, 2015   | 1.0.612928         | 5.0 and up         |\n| Gold Quote - Gold.fr                          | FINANCE             | NaN | 96     | 1.5M               | 10,000+     | Free | 0 | Everyone   | Finance                 | May 19, 2016       | 2.3                | 2.2 and up         |\n| Fanfic-FR                                     | BOOKS_AND_REFERENCE | 3.3 | 52     | 3.6M               | 5,000+      | Free | 0 | Teen       | Books &amp; Reference       | August 5, 2017     | 0.3.4              | 4.1 and up         |\n| Fr. Daoud Lamei                               | FAMILY              | 5.0 | 22     | 8.6M               | 1,000+      | Free | 0 | Teen       | Education               | June 27, 2018      | 3.8.0              | 4.1 and up         |\n| Poop FR                                       | FAMILY              | NaN | 6      | 2.5M               | 50+         | Free | 0 | Everyone   | Entertainment           | May 29, 2018       | 1.0                | 4.0.3 and up       |\n| PLMGSS FR                                     | PRODUCTIVITY        | NaN | 0      | 3.1M               | 10+         | Free | 0 | Everyone   | Productivity            | December 1, 2017   | 1                  | 4.4 and up         |\n| List iptv FR                                  | VIDEO_PLAYERS       | NaN | 1      | 2.9M               | 100+        | Free | 0 | Everyone   | Video Players &amp; Editors | April 22, 2018     | 1.0                | 4.0.3 and up       |\n| Cardio-FR                                     | MEDICAL             | NaN | 67     | 82M                | 10,000+     | Free | 0 | Everyone   | Medical                 | July 31, 2018      | 2.2.2              | 4.4 and up         |\n| Naruto &amp; Boruto FR                            | SOCIAL              | NaN | 7      | 7.7M               | 100+        | Free | 0 | Teen       | Social                  | February 2, 2018   | 1.0                | 4.0 and up         |\n| Frim: get new friends on local chat rooms     | SOCIAL              | 4.0 | 88486  | Varies with device | 5,000,000+  | Free | 0 | Mature 17+ | Social                  | March 23, 2018     | Varies with device | Varies with device |\n| Fr Agnel Ambarnath                            | FAMILY              | 4.2 | 117    | 13M                | 5,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       |\n| Manga-FR - Anime Vostfr                       | COMICS              | 3.4 | 291    | 13M                | 10,000+     | Free | 0 | Everyone   | Comics                  | May 15, 2017       | 2.0.1              | 4.0 and up         |\n| Bulgarian French Dictionary Fr                | BOOKS_AND_REFERENCE | 4.6 | 603    | 7.4M               | 10,000+     | Free | 0 | Everyone   | Books &amp; Reference       | June 19, 2016      | 2.96               | 4.1 and up         |\n| News Minecraft.fr                             | NEWS_AND_MAGAZINES  | 3.8 | 881    | 2.3M               | 100,000+    | Free | 0 | Everyone   | News &amp; Magazines        | January 20, 2014   | 1.5                | 1.6 and up         |\n| payermonstationnement.fr                      | MAPS_AND_NAVIGATION | NaN | 38     | 9.8M               | 5,000+      | Free | 0 | Everyone   | Maps &amp; Navigation       | June 13, 2018      | 2.0.148.0          | 4.0 and up         |\n| FR Tides                                      | WEATHER             | 3.8 | 1195   | 582k               | 100,000+    | Free | 0 | Everyone   | Weather                 | February 16, 2014  | 6.0                | 2.1 and up         |\n| Chemin (fr)                                   | BOOKS_AND_REFERENCE | 4.8 | 44     | 619k               | 1,000+      | Free | 0 | Everyone   | Books &amp; Reference       | March 23, 2014     | 0.8                | 2.2 and up         |\n| FR Calculator                                 | FAMILY              | 4.0 | 7      | 2.6M               | 500+        | Free | 0 | Everyone   | Education               | June 18, 2017      | 1.0.0              | 4.1 and up         |\n| FR Forms                                      | BUSINESS            | NaN | 0      | 9.6M               | 10+         | Free | 0 | Everyone   | Business                | September 29, 2016 | 1.1.5              | 4.0 and up         |\n| Sya9a Maroc - FR                              | FAMILY              | 4.5 | 38     | 53M                | 5,000+      | Free | 0 | Everyone   | Education               | July 25, 2017      | 1.48               | 4.1 and up         |\n| Fr. Mike Schmitz Audio Teachings              | FAMILY              | 5.0 | 4      | 3.6M               | 100+        | Free | 0 | Everyone   | Education               | July 6, 2018       | 1.0                | 4.1 and up         |\n| Parkinson Exercices FR                        | MEDICAL             | NaN | 3      | 9.5M               | 1,000+      | Free | 0 | Everyone   | Medical                 | January 20, 2017   | 1.0                | 2.2 and up         |\n| The SCP Foundation DB fr nn5n                 | BOOKS_AND_REFERENCE | 4.5 | 114    | Varies with device | 1,000+      | Free | 0 | Mature 17+ | Books &amp; Reference       | January 19, 2015   | Varies with device | Varies with device |\n| iHoroscope - 2018 Daily Horoscope &amp; Astrology | LIFESTYLE           | 4.5 | 398307 | 19M                | 10,000,000+ | Free | 0 | Everyone   | Lifestyle               | July 25, 2018      | Varies with device | Varies with device |\n\n",
            "text/latex": "A data.frame: 10841 × 13\n\\begin{tabular}{lllllllllllll}\n App & Category & Rating & Reviews & Size & Installs & Type & Price & Content.Rating & Genres & Last.Updated & Current.Ver & Android.Ver\\\\\n <chr> & <chr> & <dbl> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr>\\\\\n\\hline\n\t Photo Editor \\& Candy Camera \\& Grid \\& ScrapBook     & ART\\_AND\\_DESIGN & 4.1 & 159    & 19M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & January 7, 2018    & 1.0.0              & 4.0.3 and up\\\\\n\t Coloring book moana                                & ART\\_AND\\_DESIGN & 3.9 & 967    & 14M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Pretend Play       & January 15, 2018   & 2.0.0              & 4.0.3 and up\\\\\n\t U Launcher Lite – FREE Live Cool Themes, Hide Apps & ART\\_AND\\_DESIGN & 4.7 & 87510  & 8.7M & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 1, 2018     & 1.2.4              & 4.0.3 and up\\\\\n\t Sketch - Draw \\& Paint                              & ART\\_AND\\_DESIGN & 4.5 & 215644 & 25M  & 50,000,000+ & Free & 0 & Teen         & Art \\& Design                    & June 8, 2018       & Varies with device & 4.2 and up  \\\\\n\t Pixel Draw - Number Art Coloring Book              & ART\\_AND\\_DESIGN & 4.3 & 967    & 2.8M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & June 20, 2018      & 1.1                & 4.4 and up  \\\\\n\t Paper flowers instructions                         & ART\\_AND\\_DESIGN & 4.4 & 167    & 5.6M & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & March 26, 2017     & 1.0                & 2.3 and up  \\\\\n\t Smoke Effect Photo Maker - Smoke Editor            & ART\\_AND\\_DESIGN & 3.8 & 178    & 19M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 26, 2018     & 1.1                & 4.0.3 and up\\\\\n\t Infinite Painter                                   & ART\\_AND\\_DESIGN & 4.1 & 36815  & 29M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & June 14, 2018      & 6.1.61.1           & 4.2 and up  \\\\\n\t Garden Coloring Book                               & ART\\_AND\\_DESIGN & 4.4 & 13791  & 33M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & September 20, 2017 & 2.9.2              & 3.0 and up  \\\\\n\t Kids Paint Free - Drawing Fun                      & ART\\_AND\\_DESIGN & 4.7 & 121    & 3.1M & 10,000+     & Free & 0 & Everyone     & Art \\& Design;Creativity         & July 3, 2018       & 2.8                & 4.0.3 and up\\\\\n\t Text on Photo - Fonteee                            & ART\\_AND\\_DESIGN & 4.4 & 13880  & 28M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & October 27, 2017   & 1.0.4              & 4.1 and up  \\\\\n\t Name Art Photo Editor - Focus n Filters            & ART\\_AND\\_DESIGN & 4.4 & 8788   & 12M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 1.0.15             & 4.0 and up  \\\\\n\t Tattoo Name On My Photo Editor                     & ART\\_AND\\_DESIGN & 4.2 & 44829  & 20M  & 10,000,000+ & Free & 0 & Teen         & Art \\& Design                    & April 2, 2018      & 3.8                & 4.1 and up  \\\\\n\t Mandala Coloring Book                              & ART\\_AND\\_DESIGN & 4.6 & 4326   & 21M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & June 26, 2018      & 1.0.4              & 4.4 and up  \\\\\n\t 3D Color Pixel by Number - Sandbox Art Coloring    & ART\\_AND\\_DESIGN & 4.4 & 1518   & 37M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 1.2.3              & 2.3 and up  \\\\\n\t Learn To Draw Kawaii Characters                    & ART\\_AND\\_DESIGN & 3.2 & 55     & 2.7M & 5,000+      & Free & 0 & Everyone     & Art \\& Design                    & June 6, 2018       & NaN                & 4.2 and up  \\\\\n\t Photo Designer - Write your name with shapes       & ART\\_AND\\_DESIGN & 4.7 & 3632   & 5.5M & 500,000+    & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 3.1                & 4.1 and up  \\\\\n\t 350 Diy Room Decor Ideas                           & ART\\_AND\\_DESIGN & 4.5 & 27     & 17M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & November 7, 2017   & 1.0                & 2.3 and up  \\\\\n\t FlipaClip - Cartoon animation                      & ART\\_AND\\_DESIGN & 4.3 & 194216 & 39M  & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 2.2.5              & 4.0.3 and up\\\\\n\t ibis Paint X                                       & ART\\_AND\\_DESIGN & 4.6 & 224399 & 31M  & 10,000,000+ & Free & 0 & Everyone     & Art \\& Design                    & July 30, 2018      & 5.5.4              & 4.1 and up  \\\\\n\t Logo Maker - Small Business                        & ART\\_AND\\_DESIGN & 4.0 & 450    & 14M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & April 20, 2018     & 4.0                & 4.1 and up  \\\\\n\t Boys Photo Editor - Six Pack \\& Men's Suit          & ART\\_AND\\_DESIGN & 4.1 & 654    & 12M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 20, 2018     & 1.1                & 4.0.3 and up\\\\\n\t Superheroes Wallpapers \\textbar{} 4K Backgrounds            & ART\\_AND\\_DESIGN & 4.7 & 7699   & 4.2M & 500,000+    & Free & 0 & Everyone 10+ & Art \\& Design                    & July 12, 2018      & 2.2.6.2            & 4.0.3 and up\\\\\n\t Mcqueen Coloring pages                             & ART\\_AND\\_DESIGN & NaN & 61     & 7.0M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Action \\& Adventure & March 7, 2018      & 1.0.0              & 4.1 and up  \\\\\n\t HD Mickey Minnie Wallpapers                        & ART\\_AND\\_DESIGN & 4.7 & 118    & 23M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 7, 2018       & 1.1.3              & 4.1 and up  \\\\\n\t Harley Quinn wallpapers HD                         & ART\\_AND\\_DESIGN & 4.8 & 192    & 6.0M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 25, 2018     & 1.5                & 3.0 and up  \\\\\n\t Colorfit - Drawing \\& Coloring                      & ART\\_AND\\_DESIGN & 4.7 & 20260  & 25M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & October 11, 2017   & 1.0.8              & 4.0.3 and up\\\\\n\t Animated Photo Editor                              & ART\\_AND\\_DESIGN & 4.1 & 203    & 6.1M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 21, 2018     & 1.03               & 4.0.3 and up\\\\\n\t Pencil Sketch Drawing                              & ART\\_AND\\_DESIGN & 3.9 & 136    & 4.6M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 12, 2018      & 6.0                & 2.3 and up  \\\\\n\t Easy Realistic Drawing Tutorial                    & ART\\_AND\\_DESIGN & 4.1 & 223    & 4.2M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 22, 2017    & 1.0                & 2.3 and up  \\\\\n\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n\t FR Plus 1.6                                   & AUTO\\_AND\\_VEHICLES   & NaN & 4      & 3.9M               & 100+        & Free & 0 & Everyone   & Auto \\& Vehicles         & July 24, 2018      & 1.3.6              & 4.4W and up       \\\\\n\t Fr Agnel Pune                                 & FAMILY              & 4.1 & 80     & 13M                & 1,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up      \\\\\n\t DICT.fr Mobile                                & BUSINESS            & NaN & 20     & 2.7M               & 10,000+     & Free & 0 & Everyone   & Business                & July 17, 2018      & 2.1.10             & 4.1 and up        \\\\\n\t FR: My Secret Pets!                           & FAMILY              & 4.0 & 785    & 31M                & 50,000+     & Free & 0 & Teen       & Entertainment           & June 3, 2015       & 1.3.1              & 3.0 and up        \\\\\n\t Golden Dictionary (FR-AR)                     & BOOKS\\_AND\\_REFERENCE & 4.2 & 5775   & 4.9M               & 500,000+    & Free & 0 & Everyone   & Books \\& Reference       & July 19, 2018      & 7.0.4.6            & 4.2 and up        \\\\\n\t FieldBi FR Offline                            & BUSINESS            & NaN & 2      & 6.8M               & 100+        & Free & 0 & Everyone   & Business                & August 6, 2018     & 2.1.8              & 4.1 and up        \\\\\n\t HTC Sense Input - FR                          & TOOLS               & 4.0 & 885    & 8.0M               & 100,000+    & Free & 0 & Everyone   & Tools                   & October 30, 2015   & 1.0.612928         & 5.0 and up        \\\\\n\t Gold Quote - Gold.fr                          & FINANCE             & NaN & 96     & 1.5M               & 10,000+     & Free & 0 & Everyone   & Finance                 & May 19, 2016       & 2.3                & 2.2 and up        \\\\\n\t Fanfic-FR                                     & BOOKS\\_AND\\_REFERENCE & 3.3 & 52     & 3.6M               & 5,000+      & Free & 0 & Teen       & Books \\& Reference       & August 5, 2017     & 0.3.4              & 4.1 and up        \\\\\n\t Fr. Daoud Lamei                               & FAMILY              & 5.0 & 22     & 8.6M               & 1,000+      & Free & 0 & Teen       & Education               & June 27, 2018      & 3.8.0              & 4.1 and up        \\\\\n\t Poop FR                                       & FAMILY              & NaN & 6      & 2.5M               & 50+         & Free & 0 & Everyone   & Entertainment           & May 29, 2018       & 1.0                & 4.0.3 and up      \\\\\n\t PLMGSS FR                                     & PRODUCTIVITY        & NaN & 0      & 3.1M               & 10+         & Free & 0 & Everyone   & Productivity            & December 1, 2017   & 1                  & 4.4 and up        \\\\\n\t List iptv FR                                  & VIDEO\\_PLAYERS       & NaN & 1      & 2.9M               & 100+        & Free & 0 & Everyone   & Video Players \\& Editors & April 22, 2018     & 1.0                & 4.0.3 and up      \\\\\n\t Cardio-FR                                     & MEDICAL             & NaN & 67     & 82M                & 10,000+     & Free & 0 & Everyone   & Medical                 & July 31, 2018      & 2.2.2              & 4.4 and up        \\\\\n\t Naruto \\& Boruto FR                            & SOCIAL              & NaN & 7      & 7.7M               & 100+        & Free & 0 & Teen       & Social                  & February 2, 2018   & 1.0                & 4.0 and up        \\\\\n\t Frim: get new friends on local chat rooms     & SOCIAL              & 4.0 & 88486  & Varies with device & 5,000,000+  & Free & 0 & Mature 17+ & Social                  & March 23, 2018     & Varies with device & Varies with device\\\\\n\t Fr Agnel Ambarnath                            & FAMILY              & 4.2 & 117    & 13M                & 5,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up      \\\\\n\t Manga-FR - Anime Vostfr                       & COMICS              & 3.4 & 291    & 13M                & 10,000+     & Free & 0 & Everyone   & Comics                  & May 15, 2017       & 2.0.1              & 4.0 and up        \\\\\n\t Bulgarian French Dictionary Fr                & BOOKS\\_AND\\_REFERENCE & 4.6 & 603    & 7.4M               & 10,000+     & Free & 0 & Everyone   & Books \\& Reference       & June 19, 2016      & 2.96               & 4.1 and up        \\\\\n\t News Minecraft.fr                             & NEWS\\_AND\\_MAGAZINES  & 3.8 & 881    & 2.3M               & 100,000+    & Free & 0 & Everyone   & News \\& Magazines        & January 20, 2014   & 1.5                & 1.6 and up        \\\\\n\t payermonstationnement.fr                      & MAPS\\_AND\\_NAVIGATION & NaN & 38     & 9.8M               & 5,000+      & Free & 0 & Everyone   & Maps \\& Navigation       & June 13, 2018      & 2.0.148.0          & 4.0 and up        \\\\\n\t FR Tides                                      & WEATHER             & 3.8 & 1195   & 582k               & 100,000+    & Free & 0 & Everyone   & Weather                 & February 16, 2014  & 6.0                & 2.1 and up        \\\\\n\t Chemin (fr)                                   & BOOKS\\_AND\\_REFERENCE & 4.8 & 44     & 619k               & 1,000+      & Free & 0 & Everyone   & Books \\& Reference       & March 23, 2014     & 0.8                & 2.2 and up        \\\\\n\t FR Calculator                                 & FAMILY              & 4.0 & 7      & 2.6M               & 500+        & Free & 0 & Everyone   & Education               & June 18, 2017      & 1.0.0              & 4.1 and up        \\\\\n\t FR Forms                                      & BUSINESS            & NaN & 0      & 9.6M               & 10+         & Free & 0 & Everyone   & Business                & September 29, 2016 & 1.1.5              & 4.0 and up        \\\\\n\t Sya9a Maroc - FR                              & FAMILY              & 4.5 & 38     & 53M                & 5,000+      & Free & 0 & Everyone   & Education               & July 25, 2017      & 1.48               & 4.1 and up        \\\\\n\t Fr. Mike Schmitz Audio Teachings              & FAMILY              & 5.0 & 4      & 3.6M               & 100+        & Free & 0 & Everyone   & Education               & July 6, 2018       & 1.0                & 4.1 and up        \\\\\n\t Parkinson Exercices FR                        & MEDICAL             & NaN & 3      & 9.5M               & 1,000+      & Free & 0 & Everyone   & Medical                 & January 20, 2017   & 1.0                & 2.2 and up        \\\\\n\t The SCP Foundation DB fr nn5n                 & BOOKS\\_AND\\_REFERENCE & 4.5 & 114    & Varies with device & 1,000+      & Free & 0 & Mature 17+ & Books \\& Reference       & January 19, 2015   & Varies with device & Varies with device\\\\\n\t iHoroscope - 2018 Daily Horoscope \\& Astrology & LIFESTYLE           & 4.5 & 398307 & 19M                & 10,000,000+ & Free & 0 & Everyone   & Lifestyle               & July 25, 2018      & Varies with device & Varies with device\\\\\n\\end{tabular}\n"
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "str(dados)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:23.143034Z",
          "iopub.execute_input": "2024-04-14T16:55:23.14808Z",
          "iopub.status.idle": "2024-04-14T16:55:23.23128Z"
        },
        "trusted": true,
        "id": "oBlPqtiQk-jZ",
        "outputId": "dce9cbf8-c846-4c21-d1e5-337b0d8f1b6f",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 5,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "'data.frame':\t10841 obs. of  13 variables:\n",
            " $ App           : chr  \"Photo Editor & Candy Camera & Grid & ScrapBook\" \"Coloring book moana\" \"U Launcher Lite – FREE Live Cool Themes, Hide Apps\" \"Sketch - Draw & Paint\" ...\n",
            " $ Category      : chr  \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" ...\n",
            " $ Rating        : num  4.1 3.9 4.7 4.5 4.3 4.4 3.8 4.1 4.4 4.7 ...\n",
            " $ Reviews       : chr  \"159\" \"967\" \"87510\" \"215644\" ...\n",
            " $ Size          : chr  \"19M\" \"14M\" \"8.7M\" \"25M\" ...\n",
            " $ Installs      : chr  \"10,000+\" \"500,000+\" \"5,000,000+\" \"50,000,000+\" ...\n",
            " $ Type          : chr  \"Free\" \"Free\" \"Free\" \"Free\" ...\n",
            " $ Price         : chr  \"0\" \"0\" \"0\" \"0\" ...\n",
            " $ Content.Rating: chr  \"Everyone\" \"Everyone\" \"Everyone\" \"Teen\" ...\n",
            " $ Genres        : chr  \"Art & Design\" \"Art & Design;Pretend Play\" \"Art & Design\" \"Art & Design\" ...\n",
            " $ Last.Updated  : chr  \"January 7, 2018\" \"January 15, 2018\" \"August 1, 2018\" \"June 8, 2018\" ...\n",
            " $ Current.Ver   : chr  \"1.0.0\" \"2.0.0\" \"1.2.4\" \"Varies with device\" ...\n",
            " $ Android.Ver   : chr  \"4.0.3 and up\" \"4.0.3 and up\" \"4.0.3 and up\" \"4.2 and up\" ...\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "dados <- read.csv( file = path, stringsAsFactors = FALSE)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:23.238714Z",
          "iopub.execute_input": "2024-04-14T16:55:23.253731Z",
          "iopub.status.idle": "2024-04-14T16:55:23.510901Z"
        },
        "trusted": true,
        "id": "i_ylsFKdk-jZ"
      },
      "execution_count": 6,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "str(dados)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:23.515383Z",
          "iopub.execute_input": "2024-04-14T16:55:23.51781Z",
          "iopub.status.idle": "2024-04-14T16:55:23.573289Z"
        },
        "trusted": true,
        "id": "smcS7lCwk-jZ",
        "outputId": "1b2fc963-561c-4bbe-8241-58045dadf957",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 7,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "'data.frame':\t10841 obs. of  13 variables:\n",
            " $ App           : chr  \"Photo Editor & Candy Camera & Grid & ScrapBook\" \"Coloring book moana\" \"U Launcher Lite – FREE Live Cool Themes, Hide Apps\" \"Sketch - Draw & Paint\" ...\n",
            " $ Category      : chr  \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" ...\n",
            " $ Rating        : num  4.1 3.9 4.7 4.5 4.3 4.4 3.8 4.1 4.4 4.7 ...\n",
            " $ Reviews       : chr  \"159\" \"967\" \"87510\" \"215644\" ...\n",
            " $ Size          : chr  \"19M\" \"14M\" \"8.7M\" \"25M\" ...\n",
            " $ Installs      : chr  \"10,000+\" \"500,000+\" \"5,000,000+\" \"50,000,000+\" ...\n",
            " $ Type          : chr  \"Free\" \"Free\" \"Free\" \"Free\" ...\n",
            " $ Price         : chr  \"0\" \"0\" \"0\" \"0\" ...\n",
            " $ Content.Rating: chr  \"Everyone\" \"Everyone\" \"Everyone\" \"Teen\" ...\n",
            " $ Genres        : chr  \"Art & Design\" \"Art & Design;Pretend Play\" \"Art & Design\" \"Art & Design\" ...\n",
            " $ Last.Updated  : chr  \"January 7, 2018\" \"January 15, 2018\" \"August 1, 2018\" \"June 8, 2018\" ...\n",
            " $ Current.Ver   : chr  \"1.0.0\" \"2.0.0\" \"1.2.4\" \"Varies with device\" ...\n",
            " $ Android.Ver   : chr  \"4.0.3 and up\" \"4.0.3 and up\" \"4.0.3 and up\" \"4.2 and up\" ...\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "install.packages(\"dplyr\")\n",
        "install.packages(\"ggplot2\")"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:55:23.576632Z",
          "iopub.execute_input": "2024-04-14T16:55:23.578299Z",
          "iopub.status.idle": "2024-04-14T16:57:23.750572Z"
        },
        "trusted": true,
        "id": "fHRMaK_Wk-ja",
        "outputId": "59bf5a7e-ca50-42ef-c59a-a714227fe1e7",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 8,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n",
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "library(dplyr)\n",
        "library(ggplot2)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:23.753774Z",
          "iopub.execute_input": "2024-04-14T16:57:23.755702Z",
          "iopub.status.idle": "2024-04-14T16:57:23.790438Z"
        },
        "trusted": true,
        "id": "2R2JYE6Ik-ja"
      },
      "execution_count": 9,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "hist(dados$Rating)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:23.79351Z",
          "iopub.execute_input": "2024-04-14T16:57:23.795205Z",
          "iopub.status.idle": "2024-04-14T16:57:23.873226Z"
        },
        "trusted": true,
        "id": "VCQsQAXgk-ja",
        "outputId": "91f945e5-6170-4f34-d15f-a995db171c71",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 10,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "Plot with title “Histogram of dados$Rating”"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAADAFBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUW\nFhYXFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIjIyMkJCQlJSUmJiYnJyco\nKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6\nOjo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlKSkpLS0tM\nTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1e\nXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29w\ncHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGC\ngoKDg4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OU\nlJSVlZWWlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWm\npqanp6eoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4\nuLi5ubm6urq7u7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnK\nysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc\n3Nzd3d3e3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u\n7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////i\nsF19AAAACXBIWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3dC3gU5b2A8W9JNiGBEFEJGAkB\nlaJVS8QbVrFUUFREsFYQLyUS76CxxYooclOkDUesVbzgUau01qJGrT3WmqK0eJfU9qh4SkQt\n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\nMr6NpQAAAABJRU5ErkJggg=="
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "table(dados$Rating)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:23.876756Z",
          "iopub.execute_input": "2024-04-14T16:57:23.878423Z",
          "iopub.status.idle": "2024-04-14T16:57:23.90602Z"
        },
        "trusted": true,
        "id": "jzL_4rMEk-jb",
        "outputId": "8ba19d6f-e692-49e1-f6b4-1311c7db3386",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 139
        }
      },
      "execution_count": 11,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "\n",
              "   1  1.2  1.4  1.5  1.6  1.7  1.8  1.9    2  2.1  2.2  2.3  2.4  2.5  2.6  2.7 \n",
              "  16    1    3    3    4    8    8   13   12    8   14   20   19   21   25   25 \n",
              " 2.8  2.9    3  3.1  3.2  3.3  3.4  3.5  3.6  3.7  3.8  3.9    4  4.1  4.2  4.3 \n",
              "  42   45   83   69   64  102  128  163  174  239  303  386  568  708  952 1076 \n",
              " 4.4  4.5  4.6  4.7  4.8  4.9    5   19 \n",
              "1109 1038  823  499  234   87  274    1 "
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "hist(dados$Rating, xlim = c(1,5))"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:23.908985Z",
          "iopub.execute_input": "2024-04-14T16:57:23.910611Z",
          "iopub.status.idle": "2024-04-14T16:57:23.986009Z"
        },
        "trusted": true,
        "id": "IcKC8_A5k-jb",
        "outputId": "511e2966-a488-4639-dc6e-3fef5312ff9e",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 12,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "Plot with title “Histogram of dados$Rating”"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAADAFBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUW\nFhYXFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIjIyMkJCQlJSUmJiYnJyco\nKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6\nOjo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlKSkpLS0tM\nTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1e\nXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29w\ncHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGC\ngoKDg4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OU\nlJSVlZWWlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWm\npqanp6eoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4\nuLi5ubm6urq7u7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnK\nysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc\n3Nzd3d3e3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u\n7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////i\nsF19AAAACXBIWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3dC3gU1d348RPCJoRbROVi5KpS\nay+CqJWqWCooKiJYWxAvJRLvoLHFFi8IiEVa+Ku1iq32VWttrUXFWt/X2lIqLd6V+rYqvjWi\nLSjiLRFBriHzn53dJLsLOzPh/DYz8ff9PI/ZYffM7Bmf/bKXHBLjALBmop4A8FlASIAAQgIE\nEBIggJAAAYQECCAkQAAhAQIICRBASIAAQgIEEBIggJAAAYQECCAkQAAhAQIICRBASIAAQgIE\nEBIggJAAAYQECCAkQAAhAQIICRBASIAAQgIEEBIggJAAAYQECCAkQAAhAQIICRBASIAAQgIE\nEBIggJAAAYQECCAkQAAhtdQDxpRGdueLhnQo229TzpUPG1Ocbwe/2zL1vLsl04j0/0E8EVKA\nnxtj6lKbI4wZFe2D6FmTtCHnWtuQ3vv+l8pMca/xK5zU6Xo67n/28rx7ENJOCCnATiHV3HTT\nLTuNWldsXmuFyVxgTPlNv9yWc61lSK91T7eTeDQjpKTLdxqbPs9d/j/QjZAC7BTSLv3EtEpI\nJxpzwc7XWob0dWP2/l6XUX2N6bnJO91Ro0ePHnVQsqRf5Y5tpfNsgwgpQLiQjmqdB5g7g2k7\nX2sX0sdFxqx03yO9t6cx92ec7rIyY76aO7iVzrMNIqQAed8jbb99RPf23Q+7/gPHGZ16JVTt\nXrt+7hHdEj2Ov6s+tctdh3bcc/QLb7o3bnacO405Zvule/dwnIbfHN+9fZev/CQ5yr12mPPA\n4LJ+V29zVo7Zo9Nxr2TefebxLki/4mp+j3T3oR27nfTC79KxZB4197aciWVMfpUxZd6HDVeM\nvPRvmad7gXdD5lGbzjP9/8Cb+t9G7tHp6CW7OF1dCClAvpC2DU8/rPd7IyOk/903fe1XP0zu\n8R1vu3Sh+8X9033GHHyD98A+Mz3q5AbHud+YLy0qSv5pypt7Jy+6f9x871nH2ymkaanDz0jH\nknnU3NuyJ5Y5+fXufS9t+tQu43RnGtM++6i5ISWn/seS5FXFf975dHXRd8YtlC+knxrz+d88\n/fhpxnzNefURd9Cvl7/p1LoP1wE//d309saMdsc87149+Of3Htk59Wh29+zfJzH4QOdRY9rd\n9vKd7qhF3rX79D5larl72BMrqo9wd7mp6c6zj/fG8sOMOX358h3pW59zxx67+PcntE8dPuuo\nObflTCxz8smXa4lvd/nZTqfrxnZQ9lGbzjP9/yA59f6DrzzevfYrO5+uLoQUIOtjrIyQKo25\nwb3YNnHqD3c475rUe4drjen6jnt5r/vnFx3nfGP2cJ8ANvVrCskMXONu3Dp6dPJl4CnGfDt1\n7bcc5yH3osMqZ+uBxoxpuvOc4+W8RzrPffba6L5M+3zq8FlHzbkt50BZk3++LHlmRYf+oM5p\nDqm+Zoq79ZOcozaeZ3NIZthm70mr3badTlcXQgqQL6RLjen7y3XpQY0PsEHGVCb/XN/NmDmO\n8wVjzk7+8ZrmkO7LOPQlxhyfuvZ590FdasxE98rL3b/Vm0bkHC8npIOMmZy8vC7rgZs6as5t\nOQfKmrzz0pGpk+t2d87pHrM156i7COkv7uWf3ct/73S6uhBSgOQjq08/T4fMkF7qmHyo7V/1\nUPLde/oB1tA+9Te943zVq8Idcn3yTw82h5R69C4Zu1+p91Adkbo2uVahtzHz3Av3TdT+jfed\ne7yckMpSeziL0w/czKNm35Z7oKzJu16Y1cF7VvpTZkh7fn9z7lF3EdIn7mWNe/nyTqerCyEF\nyPup3RNfTD3e+j/d9ADb6F7c7g0d6b45dxrcP96c/NPjTSEVe+9vbnNv6HTQoL0bQ/KOt78x\nP3UvbskIKed4OSHlHj7zqDm37XSgzMl7et58l/s26uve6Z40duxY95lrnLPTXHcOyZv6Gi+k\n3PnoQkgB8i8Ranh6zgnlxnsvkvGMtMC77QhjznSc0vTTwgNNIXl7bnD/6j7DfRK6OCik3OPl\nPCN1SD8DLPIOn33U7Nt2OlDm5J133vc+/v6rMZ2bTvdO9/LBnebqG1Lu6epCSAH819rVP+L+\n1f1Y0wNscPphuq2LMT9ynAPSbxpmZIf0N3f0S6nj+YeUe7yckD7nfQDgOFd6h88+avZtOx0o\nY/I/7mWu8UL6IDm08XQb3PdN+3yce1T/kHJOVxdCCpAnpE3XV57ivUw73piHnXXuoOQSzznu\ny6Dkx3J3uO83/uU4ZxlT/oH7t3qf7JCWpD5eeLWd+3beP6Sc4+WENMmYPWrdw/f2Dp991Ozb\ncg6UNfnfuU9L7yZDus+Ygc2n+7/FxpyXe9TG89x1SDmnqwshBcj3jOT+HX/aYy/+7dqEKX3P\nqU8YM2zRH50693F7wMKHvue+yDnXHbPU3ffgX9x5eKfskN5xH5VjXv79vgca0/WZ9/xCyjle\nTkjL3MMfev89h3c2pl3uUbNvyz1Q5uS3fN6YXpd3HV/lvhqcnXG61W5zy3KO2nieuw4p53R1\nIaQA+UJ6uXf6w612dzrealLvW51NCwi+4X3iNcnb7vij7JCSnyW7Kt6qcL/O8gsp93g5a+3O\n8W7qdKv7ZUfOUXNuyzlQ1uRf7db4Od0JWzNOd/0+xnxuc85R0+e565ByTlcXQgqQ9z3SuusO\n65no+Pnz/5H8w9vj9ugwYK67sf4Hh5cn9jn196k9diw4sLTHN//5WPbjztn2oy+U7XvuO86S\nA9v3vt83pJzj5YS044YDS3p885VXU59CZx0157bcA2VN/p3vHlRmivc+/t4dWaf7a3fzypyj\nps8zT0jZp6sLIbWCe9y/0qOeQ4CW/QtZf23gdOURUgGtnHfx6dsdb33NuKjnEmDin+yP0YZO\nVx4hFVBNkfuQWvbkZe4rH4HHaewpO91shFRIsxvfxl8T9UxahbLTzUJIBbX0m70Tpf0mLIt6\nHq1E2elmIiRAACEBAggJEEBIgABCAgQQEiCAkAABhAQIICRAACEBAggJEEBIgABCAgQQEiCA\nkAABhAQIICRAACEBAggJEGATUsOqJYsXL10tNhegzdr9kGqn9Uj9yJi+czYJTghoi3Y7pLUD\nzMDKWfPnz5hYYQbVSk4JaHt2O6SqxKL0Vv3Comqh2QBt1G6H1Gty8/aEPhJTAdqu3Q4pMbd5\ne3aJxFSAtmu3Q+o3vnl7bH+JqQBt126HVF20YEtqa+NMM11qOkDbtNsh1Q0xXUZUTp0yaXhH\nM2yD5JSAtmf3v4+09cbBxclvIyWG3lEvOCGgLbJaIrT59RUrarZKTQVou1giBAhgiRAggCVC\ngACWCAECWCIECGCJECCAJUKAAJYIAQJYIgQIYIkQIKBAS4T+s6rZazZ3AbQJhVki9EaRybDd\n4j6ANqFAS4TW1zZ53LCsFZ95hV8i9BQh4bOv8EuECAkKFH6JECFBgcIvESIkKFD4JUKEBAUK\nv0SIkKBA4ZcIERIUKPwSIUKCAoX/KUKEBAV2O6S3Pgo5kJCgwG6HZDr8IFwghAQFdj+k/sUH\nPRFmICFBgd0PafoLh5gRy4MHEhIUsAjJqb+puznmno8DBhISFLAJyXE2ztvLFB9e9YOf+Awk\nJK3WLom5tYInaxeS43x675hOxvgdhZC0qkp0jbVEleDJ2obk2vrS/bf5DCQkrSrHvhxrYysF\nT1YgpACEpBUhhVE6I+RAQtKKkEQRklaEJIqQtCIkUYSkFSGJIiStCEkUIWlFSKIISStCEkVI\nWhGSKELSipBEEZJWhCSKkLQiJFGEpBUhiSIkrQhJFCFpRUiiCEkrQhJFSFoRkihC0oqQRBGS\nVoQkipC0IiRRhKQVIYkiJK0ISRQhaUVIoghJK0ISRUhaEZIoQtKKkEQRklaEJIqQtCIkUYSk\nFSGJIiStCEkUIWlFSKIISStCEkVIWhGSKELSipBEEZJWhCSKkLQiJFGEpBUhiSIkrQhJFCFp\nRUiiCEkrQhJFSFoRkihC0oqQRBGSVoQkipC0IqSQGlYtWbx46eqAUYSkFSGFUjuth/H0nbPJ\nbxwhaUVIYawdYAZWzpo/f8bECjOo1mcgIWlFSGFUJRalt+oXFlX7DCQkrQgpjF6Tm7cn9PEZ\nSEhaEVIYibnN27NLfAYSklaEFEa/8c3bY/v7DCQkrQgpjOqiBVtSWxtnmuk+AwlJK0IKo26I\n6TKicuqUScM7mmEbfAYSklaEFMrWGwcXJ7+NlBh6R73fOELSipDC2vz6ihU1QZkQklaEFBJL\nhOCHkEJhiRD8EVIYLBFCAEIKgyVCCEBIYbBECAEIKQyWCCEAIYXBEiEEIKQwWCKEAIQUBkuE\nEICQQmGJEPwRUlh5lwit+eJ+TSrMFpv7QJtFSCHlXyK05a7bm3yfZySlCCkUlgjBHyGFwRIh\nBCCkMFgihACEFAZLhBCAkMJgiRACEFIYLBFCAEIKgyVCCEBIYbBECAEIKRSWCMEfIYXFTxGC\nD0Jqgfp/PhXwY4QISStCCuWpKe6Xe3u6L+4G/dV3HCEpRUhhPFHSucF5wHT+1sXHtSt90Wcg\nIWlFSGEM71HjOAP6rXU3ny0b4zOQkLQipDC6Xu44H5ubve3z9vAZSEhaEVIYna5xnC1FD3nb\n13bwGUhIWhFSGEcN/NRxjrw8ubll0CCfgYSkFSGF8agZ8sftK/a559Ntzx5rbvcZSEhaEVIo\nP+9kyr7QzxQXm6LvNviMIyStCCmcdQtG9etSutehl67wHUZIWhGSKELSipBEEZJWhCSKkLQi\nJFGEpBUhiSIkrQhJFCFpRUiiCEkrQhJFSFoRkihC0oqQRBGSVoQkipC0IiRRhKQVIYkiJK0I\nSRQhaUVIoghJK0ISRUhaEZIoQtKKkEQRklaEJIqQtCIkUYSkFSGJIiStCEkUIWlFSKIISStC\nEkVIWhGSKELSipBEEZJWhCSKkLQiJFGEpBUhiSIkrQhJFCFpRUiiCEkrQhJFSFoRkihC0oqQ\nRBGSVoQkipC0IiRRhKQVIYkiJK0ISRQhaUVIoghJK0ISRUhaEZIoQtKKkEJqWLVk8eKlqwNG\nEZJWhBRK7bQextN3zia/cYSkFSGFsXaAGVg5a/78GRMrzKBan4GEpBUhhVGVWJTeql9YVO0z\nkJC0IqQwek1u3p7Qx2cgIWlFSGEk5jZvzy7xGUhIWhFSGP3GN2+P7e8zkJC0IqQwqosWbElt\nbZxppvsMJCStCCmMuiGmy4jKqVMmDe9ohm3wGUhIWhFSKFtvHFyc/DZSYugd9X7jCEkrQgpr\n8+srVtQEZUJIWhFSSCwRgh9CCoUlQvBHSGGwRAgBCCkMlgghACGFwRIhBCCkMFgihACEFAZL\nhBCAkMJgiRACEFIYLBFCAEIKhSVC8EdIYeVdIrThmulNziIkpQgppPxLhNaNHtnkcLPF4j7Q\ndhFSKCwRgj9CCoMlQghASGGwRAgBCCkMlgghACGFwRIhBCCkMFgihACEFAZLhBCAkMJgiRAC\nEFIoLBGCP0IKi58iBB+E1AJbn//Lm/4jCEkrQgrjur8kv/6sm/vi7tCX/AYSklaEFGrH5Cd1\n/21KT73gKFP+hs9AQtKKkELtmAxpYPlK9+tDRef4DCQkrQgp1I5uSO+bq7ztcfv6DCQkrQgp\n1I5uSKvNvd72jITPQELSipBC7eiGVF8+z9uevKfPQELSipBC7TjxhZoPrjzgU3fztU5jfAYS\nklaEFGrHlAcd59ed2j3vM5CQtCKkMO6+aVb1pHHDlzrOwn0f9RtISFoRUsts2OF7MyFpRUii\nCEkrQhJFSFoRkihC0oqQRBGSVoQkipC0IiRRhKQVIYkiJK0ISRQhaUVIoghJK0ISRUhaEZIo\nQtKKkEQRklaEJIqQtCIkUYSkFSGJIiStCEkUIWlFSKIISStCEkVIWhGSKELSipBEEZJWhCSK\nkLQiJFGEpBUhiSIkrQhJFCFpRUiiCEkrQhJFSFoRkihC0oqQRBGSVoQkipC0IiRRhKQVIYki\nJK0ISRQhaUVIoghJK0ISRUhaEZIoQtKKkEQRklaEJIqQtCIkUYSkFSGJIiStCEkUIWlFSCE1\nrFqyePHS1QGjCEkrQgqldloP4+k7Z5PfOELSipDCWDvADKycNX/+jIkVZlCtz0BC0oqQwqhK\nLEpv1S8sqvYZSEhaEVIYvSY3b0/o4zOQkLQipDASc5u3Z5f4DCQkrQgpjH7jm7fH9vcZSEha\nEVIY1UULtqS2Ns40030GEpJWhBRG3RDTZUTl1CmThnc0wzb4DCQkrQgplK03Di5OfhspMfSO\ner9xhKQVIYW1+fUVK2qCMiEkrQgpJJYIwQ8hhcISIfgjpDBYIoQAhBQGS4QQgJDCYIkQAhBS\nGCwRQgBCCoMlQghASGGwRAgBCCkMlgghACGFwhIh+COksPIvEfrHi03uIiSlCCmk/EuE3ig2\nGQhJJ0IKxXeJ0Ke1TR4nJKUIKQyWCCEAIYXBEiEEUBvS0J99HH5HlgghgNqQ2puyiX/aEXJH\nlgghgNqQPrx9RLHpc3VNqB1ZIoQAakNyvf/Tr7czR//XJ8E7skQIATSH5Fp70yDT8cJ/Be3I\nEiEE0B3SpgdOKzN9E4nZDQF7skQI/jSH9OS5XU3ZmU84q08zs4J35qcIwYfakFb/YKAxh9xa\nl9xuGNkj5BHWT3/N93ZC0kptSO1M+YUvNv7h1qKQR1hjHvW9nZC0UhvSsF9kLJqrWey/Y1Wj\nieb4qiqfgYSkldqQHOeVD5Jf/h5qxyw+AwlJK7UhbZtsnnAvbjGVvh/DpXynePDjdUmvmvvr\n6nwGEpJWakO6wYx+0734vwnmxyH2fGFw0UXJtXm8R8KuqQ3pyyenN046IMyu239YVvEgISEf\ntSGV3ZDemJ8It/MbI8yY1YSEXVMbUs9L0hsX9wy7+917dp5FSNgltSFN7vg/yYttd7Q/O/T+\n751uCAm7pDaktfuYvsedfPSeZp//tOAIj01b6Xs7IWmlNiRn3YV7GWO6n/e24B0Qklp6Q3Kc\nhnfe2Ch49CRC0kpzSAVASFqpDalh0cmDv5gieA+EpJXakBYY07E8RfAeCEkrtSH1HrVK8MiN\nCEkrtSElnhU8cBNC0kptSL2fETxwE0LSSm1I37tY8MBNCEkrtSFtGHXG4ytrPIL3QEhaqQ0p\n3L94bSlC0kptSBMnNf0gBsF7ICSt1IZUGISkleaQPnnF78cv7BZC0kpvSMsONeYPjjPmz4J3\nQEhqqQ3puZIuo9yQ3u9V8mLe8S1HSFqpDWl03zXvJp+R3us7VvAeCEkrtSHtNc/xQnKu7yZ4\nD4SkldqQ2v8qHdLdIX+KUCiEpJXakHpfnQ7pnH6C90BIWqkN6fxuK5Ih1V5lJBfdEZJWakN6\nt0/7IWbw4FLTd53gPRCSVmpDct67KPlThPa+6D3BOyAktfSG5DgN62okn42SCEkrzSEVACFp\npTakEU2GCd4DIWmlNqSmf43UpULwHghJK7Uhbfd8+srlx6wXvAdC0kptSE2uuFDwHghJK0J6\nhpd2sEdIf+ooeA+EpJXakOpS3n9iMD/7G/bUhtT8Q4TuFbwHQtJKbUijU8ZdxD81hwC1IRUG\nIWlFSKIISSu1IQ36yhGZhO6BkLRSG1LPMmNMkftfWXGS0D0QklZqQ6o9esrfNzvr//qN41ki\nBHtqQzqn8cAnnCt4D4SkldqQut+Z3vh/PQTvgZC0UhtS6dz0xvdLQ+3bsGrJ4sVLVweMIiSt\n1IZ0SEXql8g+ufegEHvWTuuRWgbRd84mv3GEpJXakB4pNgNGjhm5nyl6MHjHtQPMwMpZ8+fP\nmFhhBtX6DCQkrdSG5Cwb1cF9hik5dkmIHasSi9Jb9QuLqn0GEpJWekNynB1vv76mPtSOvSY3\nb0/o4zOQkLTSHFL4XzSWmNu8PbvEZyAhaaU3pJb8orF+45u3x/b3GUhIWqkNqUW/aKy6aMGW\n1NbGmWa6z0BC0kptSC36RWN1Q0yXEZVTp0wa3tEM2+AzkJC0UhtSy37R2NYbBxcnv42UGHqH\n78cThKSV2pBa/IvGNr++YkVNUCaEpJXakFr6i8ZYIgQ/akNq2S8aY4kQ/KkNqUW/aIwlQgig\nNqQW/aIxlgghgN6QWvKLxlgihABqQ3rklRbsyBIhBFAbUocftmBHlgghgNqQRp64I/yOLBFC\nALUhrZt4wn0v1niCd2SJEAKoDan5h+iH+fmrLBGCP7UhTTh7clVauJ3zLhH698D9mlQQklJq\nQ2qp/EuEti9e1OQ6QlJKZ0i3LPcuXno77J4sEYI/nSGZ1OoEMyXkjiwRQgBCCoMlQghASGGw\nRAgBCCkMlgghACGFwRIhBCCkMFgihACEFAZLhBBAaUhHzEoyh3sXIfZkiRD8KQ0pS7id+SlC\n8KEzpHuzhD9A/coXNvsOICStdIbUYk99a9C4FU7Nl4zpstB3HCEpRUhhPJswCdN11VGdzvxG\nZ/N7n4GEpBUhhXFyYnH9218+q3i54/yr00ifgYSkFSGFsddZ7pel5pjkdqXfzwonJK0IKYzE\nLPfLRnNhcvuq9j4DCUkrQgpjwLeTX8uvSH6d0NNnICFpRUhhVJUub9x8JnGaz0BC0oqQwqjp\nVnRlauusRPvnfQYSklaEFMrKkTNSG1/u84jfOELSipBa5h3/mwlJK0ISRUhaEZIoQtKKkEQR\nklaEJIqQtCIkUYSkFSGJIiStCEkUIWlFSKIISStCEkVIWhGSKELSipBEEZJWhCSKkLQiJFGE\npBUhiSIkrQhJFCFpRUiiCEkrQhJFSFoRkihC0oqQRBGSVoQkipC0IiRRhKQVIYkiJK0ISRQh\naUVIoghJK0ISRUhaEZIoQtKKkEQRklaEJIqQtCIkUYSkFSGJIiStCEkUIWlFSKIISStCEkVI\nWhGSKELSipBEEZJWhCSKkLQiJFGEpBUhiSIkrQhJFCFpRUiiCEkrQgqpYdWSxYuXrg4YRUha\nEVIotdN6GE/fOZv8xhGSVoQUxtoBZmDlrPnzZ0ysMINqfQYSklaEFEZVYlF6q35hUbXPQELS\nipDC6DW5eXtCH5+BhFQoW1fF22mEFEJibvP27BKfgYRUKFNNzBFSCP3GN2+P7e8zkJAKpfK4\nP8RaBSGFUF20YEtqa+NMM91nICEVStzfg/SN+fziEVLdENNlROXUKZOGdzTDNvgMJKRCISQ7\n8QjJ2Xrj4OLkC+HE0Dvq/cYRUqEQkp2YhOTa/PqKFTVBmRBSoRCSndiExBKhaBGSnZiExBKh\nqBGSnXiExBKhyBGSnXiExBKhyBGSnXiExBKhyBGSnXiExBKhyBGSnXiExBKhyBGSnXiExBKh\nyBGSnXiExBKhyBGSnXiExBKhyBGSnZiE5PgsEfr4kvObjCWkAiEkO7EJKf8SoQ/O/FaTY80W\ni/tAfoRkJyYhsUQoaoRkJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJx4h\nsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJyYhOfwUoYgRkp34hNSo9i2fGwmp\nUAjJTkxC+sdJ/Y5emHpRN93vKIRUKIRkJx4hPVlqOibM17zFQYQUCUKyE4+QRicebthyY+Lw\njQ4hRYSQ7MQjpD5nJb8uLTmpnpAiQkh24hFSYqZ38UtzKSFFhJDsxCOk3qekLq808wkpGoRk\nJx4hXVp0y7bkZcMkc9klhBQFQrITj5A+7GtGehsNlxpDSFEgJDvxCMn54OLL0lsP7U9IUSAk\nOzEJKSxCKhRCskNI8BCSHUKCh5DsEBI8hGSHkOAhJDuEBA8h2SEkeAjJDiHBQ0h2CAkeQrJD\nSPAQkh1CgoeQ7BASPIRkh5DgISQ7hAQPIdkhJHgIyQ4hwUNIdggJHkKyQ0jwEJIdQoKHkOwQ\nEjyEZIeQ4CEkO4QEDyHZISR4CMkOIcFDSHYICR5CskNI8BCSHUKCh5DsEBI8hGSHkOAhJDuE\nBA8h2SEkeAjJDiHBQ0h2CAkeQrJDSPAQkh1CgoeQ7BASPIRkh5DgISQ7hAQPIdkhJHgIyQ4h\nwUNIdggJHkKyE5uQGlYtWbx46eqAUYRUKIRkJyYh1U7rYTx952zyG0dIhUJIduIR0toBZmDl\nrPnzZ0ysMINqfQYSUqEQkp14hFSVWJTeql9YVO0zkJAKhZDsxCOkXpObtyf08RlISIVCSHbi\nEVJibvP27BKfgYRUKIRkJx4h9RvfvD22v89AQioUQrITj5CqixZsSW1tnGmm+wwkpEIhJDvx\nCKluiOkyonLqlEnDO5phG3wGElKhEJKdeITkbL1xcHHy20iJoXfU+40jpEIhJDsxCcm1+fUV\nK2qCMiGkQiEkO7EJiSVC0SIkOzEJiSVCUSMkO/EIiSVCkSMkO/EIiSVCkSMkO/EIiSVCkSMk\nO/EIiSVCkSMkO/EIiSVCkSMkO/EIiSVCkSMkO/EIiSVCkSMkO/EIiSVCkSMkOzEJyfFZItSw\nbEmTHxNSgRCSndiElH+J0KoOJsMWi/tAfoRkJyYhsUQoaoRkJx4hsUQocoRkJx4hsUQocoRk\nJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRkJx4hsUQocoRk\nJyYhOfwUoYgRkp34hNTowxqfGwmpUAjJTvxCmu53FEIqFEKyQ0jwEJIdQoKHkOzEI6RDM/Qi\npCgQkp14hNSuXWmTYkKKAiHZiUdI07s0f1THS7tIEJKdeIS07ZDDtjVuE1IkCMlOPEJyVpZd\n3rhJSJEgJDsxCclZ/1Hj1rJ5PsMIqVAIyU5cQgqJkAqFkOwQEjyEZIeQ4CEkO4QEDyHZISR4\nCMkOIcFDSHYICR5CskNI8BCSHUKCh5DsEBI8hGSHkOAhJDuEBA8h2SEkeAjJDiHBQ0h2CAke\nQrJDSPAQkh1CgoeQ7BASPIRkh5DgISQ7hAQPIdkhJHgIyQ4hwUNIdggJHkKyQ0jwEJIdQoKH\nkOwQEjyEZIeQ4CEkO4QED4CX1kQAAAqASURBVCHZISR4CMkOIcFDSHYICR5CskNI8BCSHUKC\nh5DsEBI8hGSHkOAhJDuEBA8h2SEkeAjJDiG1klduj7cjY/5AJSRRbTekc/b4QqyVxPyBSkii\n2m5IvHSyE/f5EVIrISQ7cZ8fIbUSQrIT9/kRUishJDtxnx8htRJCshP3+RFSKyEkO3GfHyG1\nEkKyE/f5EVIrISQ7cZ8fIbUSQrIT9/kRUishJDtxnx8htRJCshP3+RFSKyEkO3GfHyG1EkKy\nE/f5EVIrISQ7cZ8fIbUSQrIT9/kRUishJDtxnx8htRJCshP3+RFSKyEkO3Gf32cmpEXfirf+\nMX8gxP2BGvf5xSakhlVLFi9eujpgVP6QKgdOjrWuMX8gxP2BGvf5xSSk2mk9jKfvnE1+43xC\nivn/6Lg/EJifnXiEtHaAGVg5a/78GRMrzKBan4GEVCjMz048QqpKLEpv1S8sqvYZSEiFwvzs\nxCOkXpObtyf08RlISIXC/OzEI6TE3Obt2SU5N77ZvVuTLmZbnkNUJbrGWjvmZyXu8ysu7ZbH\nd1rew26H1G988/bY/jk37nhiSZM//SrfIdYuibff/jbqGfhjfnbyz29ly3vY7ZCqixZsSW1t\nnGmm7+5RgM+G3Q6pbojpMqJy6pRJwzuaYRskpwS0Pbv/faStNw4uTn4bKTH0jnrBCQFtkdUS\noc2vr1hR01ZX0gGCCr/WDlCAkAABhAQIICRAACEBAggJEEBIgABCAgQQEiCAkAABhAQIICRA\nACEBAggJEEBIgABCAgQQEiAgypCGGiBCQwUfzFGGdMaYF2NtDPOzEvv5nSH4YI4ypErJn3RZ\nAMzPjqr5EVJ+zM+OqvkRUn7Mz46q+RFSfszPjqr5EVJ+zM+OqvkRUn7Mz46q+RFSfszPjqr5\nEVJ+zM+OqvkRUn7Mz46q+RFSfszPjqr5RRnS+edHeOchMD87quYXZUi1tRHeeQjMz46q+fHP\nKAABhAQIICRAACEBAggJEEBIgABCAgQQEiCAkAABhAQIICRAACEBAggJEEBIgABCAgQQEiAg\nwpC2XdHu0OjuPVDttL4l/cc+E/U08lp13n4le499Lupp+PqOqYp6Cvncnf6NFNcJHS+6kFYO\n6RLnkD7qb0Zfc2b7Dv+MeiJ5/N9eJWfNOjOReDrqifh4oTi+Id1kJk5P+ovQ8SILaX3ZYTWl\nMQ5pirnF/fqQOSnqieRxXNFf3a+LzfioJ5Lf9sGD4hvSLPOC6PEiC+mjaducOId02Yht7teG\nsn5RTySPGVcmv9YnBkU9kfx+WPSH+IZUbWpEjxfphw1xDillS+KoqKfg620zLuop5PVG2UV1\n8Q1pkvmgfs0HcscjJF83ey/w4urTJw7uIvsCRdKIfT6OcUjjzNXdjPncr6WOR0h+lpUcvT3q\n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"
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "rating.Histogram <- ggplot(data = dados) + geom_histogram(mapping = aes(x = Rating), na.rm = TRUE, breaks = seq(1,5)) + xlim(c(1,5))\n",
        "rating.Histogram"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:23.989336Z",
          "iopub.execute_input": "2024-04-14T16:57:23.991054Z",
          "iopub.status.idle": "2024-04-14T16:57:24.23884Z"
        },
        "trusted": true,
        "id": "yzjLoqulk-jb",
        "outputId": "da6b4cb7-b0cf-4b0b-b592-42e627ecd65c",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 13,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAACtVBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERETExMUFBQVFRUXFxcY\nGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAiIiIjIyMkJCQmJiYnJycoKCgpKSksLCwtLS0u\nLi4vLy8xMTEyMjIzMzM1NTU2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFC\nQkJDQ0NFRUVGRkZHR0dISEhJSUlMTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZX\nV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhp\naWlqampra2tsbGxtbW1vb29wcHBxcXFycnJzc3N0dHR1dXV3d3d4eHh5eXl6enp7e3t8fHx9\nfX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6P\nj4+QkJCRkZGSkpKTk5OWlpaZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSl\npaWmpqanp6eoqKipqamrq6usrKyurq6vr6+wsLCxsbGzs7O0tLS1tbW2tra3t7e4uLi5ubm6\nurq7u7u8vLy9vb2+vr6/v7/CwsLDw8PExMTGxsbHx8fIyMjJycnKysrLy8vMzMzOzs7Pz8/Q\n0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7f39/g4ODi4uLj\n4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P09PT1\n9fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7///9yG5dpAAAACXBIWXMAABJ0AAASdAHe\nZh94AAAbu0lEQVR4nO3d/59dBX3n8YtUW6DWbbWtq/26tnTXRrutpWulpd0kaIT6SSCBFdxW\ncBW7aN0VKE1oQRtLFet2290tBbsK1IjIuuWrJWsVCzSsEEhD+DYzSWaSycz5O3pnYiyd8Og9\nM5/PmevNfb5+uOdOOLxzZjJP5t75EnqNpHS9YV+AdCIEklQQSFJBIEkFgSQVBJJUEEhSQSBJ\nBRVBmnx2QM/NHRp0ykqamOlkdW66i9mpg52szh3oYvbA/k5W56a6mJ0e+P63otW5iUGnPF8N\n6fl9A3q6OTTolJX0XDerzXQXsxMHu1idbPZ3Mbu/m9VmoovZ6W5Wm+cGnfIsSP/sKkgggVSw\nChJIIBWsggQSSAWrIIEEUsEqSCCBVLAKEkggFayCBBJIBasggQRSwSpIIIFUsAoSSCAVrIIE\nEkgFqyCBNBxIM4cH1cwPPGUFzXaz2sx1MXukm9XmSCez3ax2c7Fz3aw2s4NOOVQNafCPUTSH\na763/Z820c1q08lPZ0x1srq/6eSnMw528sMZB5tOfoxippvVxo9RJFc9tPPQznOkglWQQAKp\nYBUkkEAqWAUJJJAKVkECCaSCVZBAAqlgFSSQQCpYBQkkkApWQQIJpIJVkEACqWAVJJBAKlgF\nCSSQClZBAgmkglWQQAKpYBUkkEAqWAUJJJAKVkECCaSCVZBAAqlgFSSQQCpYBQkkkApWQeoK\nUoxSIGVXQQIpQMqvggRSgJRfBQmkACm/ChJIAVJ+FSSQAqT8KkggBUj5VZBACpDyqyCBFCDl\nV0ECKUDKr4IEUoCUXwUJpAApvwoSSAFSfhUkkAKk/CpIIAVI+VWQQAqQ8qsggRQg5VdBAilA\nyq+CBFKAlF8FCaQAKb8KEkgBUn4VJJACpPwqSCAFSPlVkEAKkPKrIIEUIOVXQQIpQMqvggRS\ngJRfBQmkACm/ChJIAVJ+FSSQAqT8KkggBUj5VZBACpDyqyCBFCDlV0ECKUDKr4IEUoCUXwUJ\npAApvwoSSAFSfhUkkAKk/CpIIAVI+VWQQAqQ8qsggRQg5VdBAilAyq+CBFKAlF8FCaQAKb8K\nEkgBUn4VJJACpPwqSCAFSPlVkEAKkPKrIIEUIOVXQQIpQMqvggRSgJRfBQmkACm/ChJIAVJ+\nFSSQAqT8KkggBUj5VZBACpDyqyCBFCDlV0ECKUDKr4IEUoCUXwUJpAApvwoSSAFSfhUkkAKk\n/CpIIAVI+VWQQAqQ8qsggRQg5VdBAilAyq+CBFKAlF8FCaQAKb8KEkgBUn4VJJACpPwqSCAF\nSPlVkEAKkPKrIIEUIOVXQQIpQMqvggRSgJRfBQmkACm/ChJIAVJ+FSSQohjSbRe99dL7mmbq\no1s2XrX3+CNI7QNpjCHdsfn+vZ+5+EBz9eWPPnHdJXPHHUFqH0hjDOniLy4e9q3b1f8odPbO\npUeQlhFI4wvp6bVffM/b3//15q4N8/2XLr1p6RGkZQTS+EJ6aO0HH5+84R3P77hg4aUP3bD0\n2L+5c02/ewd8YJMWG7aNZTX41fnWc5vBkPqP3o7EHTsuXHipD2jJsX9z/3n9/t/soJr5gaes\noCPdrDZzncx2s9rNxc51szpsG8uqOTLo9TncFtK+tY/0by+5+Z6jD+WOOx47z0O7FnloN74P\n7eY239I0h8790jPr+qAm1n916RGkZQTS+EJqbt70wL7rN08317z30d1XXjZ/3BGk9oE0xpDm\n/uT8t37gsaY5sH3zpm3PHn8EqX0gjTGkloHUIpBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQ\nQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkg\nkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKp\nIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEAC\nqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBA\nAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQ\nQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkg\nkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKp\nIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEAC\nqSCQQAKpIJBAAqkgkEACqSCQQAKpIJBAAqkgkEAa1P7JAU01s4NOWUn7O1k90BzuYvbgoU5W\nm5kuZme6WR22jWXV5t26GNLBQU03Rwaes4JmulltZruYPdTNanO4i9nD3awO28ayamYGvkLV\nkDy0a5GHdh7agVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgg\ngVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBI\nIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQ\nSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFU\nEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCB\nVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgg\ngVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBI\nIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQ\nSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFUEEgggVQQSCCBVBBIIIFU\nEEgggVQQSOMN6Y61dzfN1Ee3bLxq7/FHkNoH0lhDeu78DX1IV1/+6BPXXTJ33BGk9oE01pCu\n+dT5dzf71u3qfxQ6e+fSI0jLCKRxhnTXRdN9SHdtmO/fv/SmpUeQlhFIYwxpavMDTR/SjgsW\nXvjQDUuP/ZuHtvZ7eHpAM83coFNW0qFuVpsjnczOdrF6uOlkdrab1WHbWFbNzMBXqDWkj32s\nWYR04TcBLTn2b+5c0+/eQR/YpIWGbWNZDX51vvVJgkGQHtg8uQjpnqMP5W5eeuzfHNzdb9+z\nA3quOTzolJU00c1qM9PF7NR0F6v7m4NdzB440MXqwWHbWFbNxKDX5/m2kK7dsHHjxnXnbntm\n3SNNM7H+q0uPx87zHKlFniON73OkyYWzz7t9ornmvY/uvvKy+eOOILUPpPGFtFj/oV1zYPvm\nTduePf4IUvtAGnNILQKpRSCBBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEggQRSQSCBBFJBIIEE\nUkEggQRSQSCBBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEggQRSQSCB\nBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEg\ngQRSQSCBBFJBIIEEUkEggQRSQSCBBFJBIIEEUkEgjQukNQ8ePX76J0HqIJDGBVLv/sXD7FUv\n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\nOav/cG/N4kO7M37+r9/y8le9Y2/TzF3xmu/86dsvfelQL3fMAmlkOgbpqZf9UtP8ee+tt976\nK71bm4fX9+5/cBHSma99wxf2fvrkLU2ztXfu5//oB9942pAveKwCaWS6onfbnj17vvG5N5x0\nW9Nse8uhppn4jk1N886FP8JFSL2/6t8789XN/PefPt809/RAWsVAGpmOftau13vdjd/6pdec\n8UJIpy780paXNE/23rdw73SQVjGQRqYrets/97nP/bvvenzhhYn/evr3nHxy700vhPTDC/+g\n/+IDvWsX7m0AaRUDaWQ6+hzpb05++8ILv3Dyb33pK3/z6heFdE/vIwv33g7SKgbSyPTNTzb8\nRu/zTfNI7+L+3dnvelFID/f+88K9nwJpFQNpZPompH3/4l8dah7sXdUsfAnp3zbNRb3ZJZBm\nX3F6/859PtmwmoE0Mh379Pf23u80h1/7Lz/7V+9/85tffuf+D/eu+vQ/hdRc1rvg85/4kTeB\ntIqBNDIdg3T4daf8/+b+nz31+//jxC2v/N6HHn/9S1+3BNLMe1552hn3bvzuoV7umAXSCduZ\nPzjsKxinQDoB2/62/tOm517xq8O+jnEKpBOwP+39+8/e9LMn3THs6xinQDoR+9PXn3bqz902\n7KsYq0CSCgJJKggkqSCQpIJAkgoCSSoIJKkgkKSC/gEJVLLCKLRAUwAAAABJRU5ErkJggg=="
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "ggplot(data = dados) + geom_bar(mapping = aes(x = Category), stat = \"count\") + coord_flip()"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:24.241816Z",
          "iopub.execute_input": "2024-04-14T16:57:24.243427Z",
          "iopub.status.idle": "2024-04-14T16:57:24.595436Z"
        },
        "trusted": true,
        "id": "SGFOZ-H5k-jb",
        "outputId": "3dfe6663-1eae-4fa1-f943-ff9bc597178a",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 14,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAAC7lBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBASEhITExMUFBQVFRUWFhYX\nFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8hISEiIiIjIyMkJCQmJiYnJycoKCgpKSkqKior\nKyssLCwtLS0uLi4vLy8xMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9PT0+\nPj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlLS0tNTU1OTk5PT09QUFBRUVFS\nUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2Nk\nZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29wcHBxcXFycnJzc3N0dHR1dXV2\ndnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eI\niIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OUlJSVlZWWlpaXl5eYmJiZmZma\nmpqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWmpqanp6eoqKipqamqqqqrq6us\nrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4uLi5ubm6urq7u7u8vLy9vb2+\nvr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnKysrLy8vMzMzNzc3Ozs7Pz8/Q\n0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7f39/g4ODh4eHi\n4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P0\n9PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7///8QuYHtAAAACXBIWXMAABJ0AAAS\ndAHeZh94AAAgAElEQVR4nO29e2BU133vq9RNX0l6bk/bc5qex32ctrfp4/j0nN6T5t6mPbft\nuTPSIMmKHgjzEBiDQiakhmJSYRODjKOAE8dJ5OBgTBXb2MF1ZOoEDH4QKRiDHZvwsIwtC5BB\n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\nONgbODE4OOItUpbZW8ny40IkqaA0x35+J+rLaUGkXIBIHAWRbj2VfHz6D5REcu5GdeK0rL6+\n5C1BXiKpZW8l/ya6UzB9jsCJ+nJaECkXIBJHQaSKY+ZD9J5fylEkJ04rC5HUsrfSRWJzSI76\ncloQKRcgEidrkSocZg7RdxKx5OgrJ04rXSRnuE222Vs+Ijlz7Od3or6cFtGbKw3envYjNssi\n+T4xI0rx7Af7Eo9qKEIJDUViMQ1FEqShSFTLgSV+ZKe8RHrzwYrKpYJl/3ieZsJJxJKir6Q4\nrXSRnOEWWWdvJR3sYyLZc6ToLSvqS27lHMelhxkPJShdfOK4/vad5OONd2as4HlqJ8VpzXxq\nl3X2VtLBKSZS2hwbEfUlt6LXDYav+DHbp3a+T8y4RpPZD/Zl8rqGIomYhiI3xzUUmaar+RcZ\nmcq/xpVx4kf2mrdIFgd/IyeR5DitGUVSzd7ip3buOQZO1JcU+pUC10hK4BqJo/L2d3fjZz79\n6U//+Sd+U0kkK/pKjtMy+4YziKSaveUhkjXHen4n6ksK/YJIuQCROAoifb/iF/9dxSd/peKz\nM4dD8l/IBs7LcVpmz9YMIqlmb3mJ5MxJRm85UV9OCyLlAkTiqPwe6e9G6Za3o1//y/L7u+YQ\nSQmIxFEQ6RPGf/O3vEX0hVVzvtBnG4ikBETiqNyP9C9Ev/4K0aufnLUFPSfZWx5AJCUgEkcl\nsrhmiv7wbqJ/zi2uuJiBSEpAJI6CSI9X/DV9+ZaWe343twD9YgYiKQGROCpvf39/K439vxUV\n//7YXK/zWQfhJ0pAJI7abRQGfaem53CFzxEQSQmIxMlepA/NjwNQ79U5XuRzAURSAiJxshbp\nh/9qu/n4e7/1xlwv89mncNdI5U2mlTdPRXrnY7+b/LuxP/m3v5PVTbIlBUSaHTKtvHkq0uc/\nejrVeuOWe+d4mc8+EGl2yLTy5qlIv/c5u1n5+3O6yOcCiDQ7ZFp581Skj91nN+/55Tld5HMB\nRJodMq28+SrSVrvZVvR/PzbyrWWhxnXmDbBOqlfgnHiIL3T+GHOLPQEizQ6ZVt48FelTC+zm\nX/7xLHuQLwMNq3sGzuwJicQHJ9WrqVM8HGsQIkkRYSYQaXbItPLmqUh33fJ6qvXDio2z70Je\nrG81/4JTb1dCTvXa3ih629uFSGm3n0OkWSLTypunIl36jd/8vog4GN/+q79V5L+SHQ4cdr6Q\n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"
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "category.Freq <- data.frame(table(dados$Category))\n",
        "category.Freq"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:24.59858Z",
          "iopub.execute_input": "2024-04-14T16:57:24.600218Z",
          "iopub.status.idle": "2024-04-14T16:57:24.639429Z"
        },
        "trusted": true,
        "id": "NFdzfBAFk-jc",
        "outputId": "85bc022b-ee8c-4783-a292-6fa335f26380",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 15,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 34 × 2</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>Var1</th><th scope=col>Freq</th></tr>\n",
              "\t<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td>1.9                </td><td>   1</td></tr>\n",
              "\t<tr><td>ART_AND_DESIGN     </td><td>  65</td></tr>\n",
              "\t<tr><td>AUTO_AND_VEHICLES  </td><td>  85</td></tr>\n",
              "\t<tr><td>BEAUTY             </td><td>  53</td></tr>\n",
              "\t<tr><td>BOOKS_AND_REFERENCE</td><td> 231</td></tr>\n",
              "\t<tr><td>BUSINESS           </td><td> 460</td></tr>\n",
              "\t<tr><td>COMICS             </td><td>  60</td></tr>\n",
              "\t<tr><td>COMMUNICATION      </td><td> 387</td></tr>\n",
              "\t<tr><td>DATING             </td><td> 234</td></tr>\n",
              "\t<tr><td>EDUCATION          </td><td> 156</td></tr>\n",
              "\t<tr><td>ENTERTAINMENT      </td><td> 149</td></tr>\n",
              "\t<tr><td>EVENTS             </td><td>  64</td></tr>\n",
              "\t<tr><td>FAMILY             </td><td>1972</td></tr>\n",
              "\t<tr><td>FINANCE            </td><td> 366</td></tr>\n",
              "\t<tr><td>FOOD_AND_DRINK     </td><td> 127</td></tr>\n",
              "\t<tr><td>GAME               </td><td>1144</td></tr>\n",
              "\t<tr><td>HEALTH_AND_FITNESS </td><td> 341</td></tr>\n",
              "\t<tr><td>HOUSE_AND_HOME     </td><td>  88</td></tr>\n",
              "\t<tr><td>LIBRARIES_AND_DEMO </td><td>  85</td></tr>\n",
              "\t<tr><td>LIFESTYLE          </td><td> 382</td></tr>\n",
              "\t<tr><td>MAPS_AND_NAVIGATION</td><td> 137</td></tr>\n",
              "\t<tr><td>MEDICAL            </td><td> 463</td></tr>\n",
              "\t<tr><td>NEWS_AND_MAGAZINES </td><td> 283</td></tr>\n",
              "\t<tr><td>PARENTING          </td><td>  60</td></tr>\n",
              "\t<tr><td>PERSONALIZATION    </td><td> 392</td></tr>\n",
              "\t<tr><td>PHOTOGRAPHY        </td><td> 335</td></tr>\n",
              "\t<tr><td>PRODUCTIVITY       </td><td> 424</td></tr>\n",
              "\t<tr><td>SHOPPING           </td><td> 260</td></tr>\n",
              "\t<tr><td>SOCIAL             </td><td> 295</td></tr>\n",
              "\t<tr><td>SPORTS             </td><td> 384</td></tr>\n",
              "\t<tr><td>TOOLS              </td><td> 843</td></tr>\n",
              "\t<tr><td>TRAVEL_AND_LOCAL   </td><td> 258</td></tr>\n",
              "\t<tr><td>VIDEO_PLAYERS      </td><td> 175</td></tr>\n",
              "\t<tr><td>WEATHER            </td><td>  82</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 34 × 2\n\n| Var1 &lt;fct&gt; | Freq &lt;int&gt; |\n|---|---|\n| 1.9                 |    1 |\n| ART_AND_DESIGN      |   65 |\n| AUTO_AND_VEHICLES   |   85 |\n| BEAUTY              |   53 |\n| BOOKS_AND_REFERENCE |  231 |\n| BUSINESS            |  460 |\n| COMICS              |   60 |\n| COMMUNICATION       |  387 |\n| DATING              |  234 |\n| EDUCATION           |  156 |\n| ENTERTAINMENT       |  149 |\n| EVENTS              |   64 |\n| FAMILY              | 1972 |\n| FINANCE             |  366 |\n| FOOD_AND_DRINK      |  127 |\n| GAME                | 1144 |\n| HEALTH_AND_FITNESS  |  341 |\n| HOUSE_AND_HOME      |   88 |\n| LIBRARIES_AND_DEMO  |   85 |\n| LIFESTYLE           |  382 |\n| MAPS_AND_NAVIGATION |  137 |\n| MEDICAL             |  463 |\n| NEWS_AND_MAGAZINES  |  283 |\n| PARENTING           |   60 |\n| PERSONALIZATION     |  392 |\n| PHOTOGRAPHY         |  335 |\n| PRODUCTIVITY        |  424 |\n| SHOPPING            |  260 |\n| SOCIAL              |  295 |\n| SPORTS              |  384 |\n| TOOLS               |  843 |\n| TRAVEL_AND_LOCAL    |  258 |\n| VIDEO_PLAYERS       |  175 |\n| WEATHER             |   82 |\n\n",
            "text/latex": "A data.frame: 34 × 2\n\\begin{tabular}{ll}\n Var1 & Freq\\\\\n <fct> & <int>\\\\\n\\hline\n\t 1.9                 &    1\\\\\n\t ART\\_AND\\_DESIGN      &   65\\\\\n\t AUTO\\_AND\\_VEHICLES   &   85\\\\\n\t BEAUTY              &   53\\\\\n\t BOOKS\\_AND\\_REFERENCE &  231\\\\\n\t BUSINESS            &  460\\\\\n\t COMICS              &   60\\\\\n\t COMMUNICATION       &  387\\\\\n\t DATING              &  234\\\\\n\t EDUCATION           &  156\\\\\n\t ENTERTAINMENT       &  149\\\\\n\t EVENTS              &   64\\\\\n\t FAMILY              & 1972\\\\\n\t FINANCE             &  366\\\\\n\t FOOD\\_AND\\_DRINK      &  127\\\\\n\t GAME                & 1144\\\\\n\t HEALTH\\_AND\\_FITNESS  &  341\\\\\n\t HOUSE\\_AND\\_HOME      &   88\\\\\n\t LIBRARIES\\_AND\\_DEMO  &   85\\\\\n\t LIFESTYLE           &  382\\\\\n\t MAPS\\_AND\\_NAVIGATION &  137\\\\\n\t MEDICAL             &  463\\\\\n\t NEWS\\_AND\\_MAGAZINES  &  283\\\\\n\t PARENTING           &   60\\\\\n\t PERSONALIZATION     &  392\\\\\n\t PHOTOGRAPHY         &  335\\\\\n\t PRODUCTIVITY        &  424\\\\\n\t SHOPPING            &  260\\\\\n\t SOCIAL              &  295\\\\\n\t SPORTS              &  384\\\\\n\t TOOLS               &  843\\\\\n\t TRAVEL\\_AND\\_LOCAL    &  258\\\\\n\t VIDEO\\_PLAYERS       &  175\\\\\n\t WEATHER             &   82\\\\\n\\end{tabular}\n",
            "text/plain": [
              "   Var1                Freq\n",
              "1  1.9                    1\n",
              "2  ART_AND_DESIGN        65\n",
              "3  AUTO_AND_VEHICLES     85\n",
              "4  BEAUTY                53\n",
              "5  BOOKS_AND_REFERENCE  231\n",
              "6  BUSINESS             460\n",
              "7  COMICS                60\n",
              "8  COMMUNICATION        387\n",
              "9  DATING               234\n",
              "10 EDUCATION            156\n",
              "11 ENTERTAINMENT        149\n",
              "12 EVENTS                64\n",
              "13 FAMILY              1972\n",
              "14 FINANCE              366\n",
              "15 FOOD_AND_DRINK       127\n",
              "16 GAME                1144\n",
              "17 HEALTH_AND_FITNESS   341\n",
              "18 HOUSE_AND_HOME        88\n",
              "19 LIBRARIES_AND_DEMO    85\n",
              "20 LIFESTYLE            382\n",
              "21 MAPS_AND_NAVIGATION  137\n",
              "22 MEDICAL              463\n",
              "23 NEWS_AND_MAGAZINES   283\n",
              "24 PARENTING             60\n",
              "25 PERSONALIZATION      392\n",
              "26 PHOTOGRAPHY          335\n",
              "27 PRODUCTIVITY         424\n",
              "28 SHOPPING             260\n",
              "29 SOCIAL               295\n",
              "30 SPORTS               384\n",
              "31 TOOLS                843\n",
              "32 TRAVEL_AND_LOCAL     258\n",
              "33 VIDEO_PLAYERS        175\n",
              "34 WEATHER               82"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "ggplot(data = category.Freq) + geom_bar(mapping = aes(x = reorder(Var1, -Freq), y = Freq), stat = \"identity\") + coord_flip()"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:24.642455Z",
          "iopub.execute_input": "2024-04-14T16:57:24.644095Z",
          "iopub.status.idle": "2024-04-14T16:57:24.931339Z"
        },
        "trusted": true,
        "id": "j9PSSNddk-jc",
        "outputId": "b0cf19d9-ea36-4c3b-d69b-2055e552e59f",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 16,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAAC61BMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhIUFBQVFRUWFhYX\nFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAiIiIjIyMkJCQlJSUmJiYnJycoKCgpKSkq\nKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9PT0+\nPj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhLS0tNTU1OTk5PT09QUFBRUVFSUlJT\nU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2NkZGRl\nZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29wcHBxcXFycnJzc3N0dHR1dXV2dnZ3\nd3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eIiIiJ\niYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OUlJSVlZWWlpaXl5eYmJiZmZmampqb\nm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWmpqanp6eoqKipqamqqqqrq6usrKyt\nra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4uLi5ubm6urq7u7u8vLy9vb2+vr6/\nv7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnKysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR\n0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7f39/g4ODh4eHi4uLj\n4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P09PT1\n9fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7///+iJ7V0AAAACXBIWXMAABJ0AAASdAHe\nZh94AAAgAElEQVR4nO29e3wU55nvqUwuM3Nyktkzl7OTye6c3ezcJydzPDsz2ZkzSeZk93RL\njdTW6IIwF3FXiEImMJiMsHFAxpbBiWMnsrEBEw1GsXGITJyAAdtEMsbgxCZcLGOwABmpoREC\n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\nAABJRU5ErkJggg=="
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "category.Top10 <- category.Freq[(order(-category.Freq$Freq)), ]\n",
        "category.Top10 <- category.Top10[1:10, ]\n",
        "category.Top10"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:24.934353Z",
          "iopub.execute_input": "2024-04-14T16:57:24.935986Z",
          "iopub.status.idle": "2024-04-14T16:57:24.966583Z"
        },
        "trusted": true,
        "id": "vIgUFD4bk-jc",
        "outputId": "60351ed6-578b-4a1b-c1d4-dd42f9b378a3",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 412
        }
      },
      "execution_count": 17,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 10 × 2</caption>\n",
              "<thead>\n",
              "\t<tr><th></th><th scope=col>Var1</th><th scope=col>Freq</th></tr>\n",
              "\t<tr><th></th><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><th scope=row>13</th><td>FAMILY         </td><td>1972</td></tr>\n",
              "\t<tr><th scope=row>16</th><td>GAME           </td><td>1144</td></tr>\n",
              "\t<tr><th scope=row>31</th><td>TOOLS          </td><td> 843</td></tr>\n",
              "\t<tr><th scope=row>22</th><td>MEDICAL        </td><td> 463</td></tr>\n",
              "\t<tr><th scope=row>6</th><td>BUSINESS       </td><td> 460</td></tr>\n",
              "\t<tr><th scope=row>27</th><td>PRODUCTIVITY   </td><td> 424</td></tr>\n",
              "\t<tr><th scope=row>25</th><td>PERSONALIZATION</td><td> 392</td></tr>\n",
              "\t<tr><th scope=row>8</th><td>COMMUNICATION  </td><td> 387</td></tr>\n",
              "\t<tr><th scope=row>30</th><td>SPORTS         </td><td> 384</td></tr>\n",
              "\t<tr><th scope=row>20</th><td>LIFESTYLE      </td><td> 382</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 10 × 2\n\n| <!--/--> | Var1 &lt;fct&gt; | Freq &lt;int&gt; |\n|---|---|---|\n| 13 | FAMILY          | 1972 |\n| 16 | GAME            | 1144 |\n| 31 | TOOLS           |  843 |\n| 22 | MEDICAL         |  463 |\n| 6 | BUSINESS        |  460 |\n| 27 | PRODUCTIVITY    |  424 |\n| 25 | PERSONALIZATION |  392 |\n| 8 | COMMUNICATION   |  387 |\n| 30 | SPORTS          |  384 |\n| 20 | LIFESTYLE       |  382 |\n\n",
            "text/latex": "A data.frame: 10 × 2\n\\begin{tabular}{r|ll}\n  & Var1 & Freq\\\\\n  & <fct> & <int>\\\\\n\\hline\n\t13 & FAMILY          & 1972\\\\\n\t16 & GAME            & 1144\\\\\n\t31 & TOOLS           &  843\\\\\n\t22 & MEDICAL         &  463\\\\\n\t6 & BUSINESS        &  460\\\\\n\t27 & PRODUCTIVITY    &  424\\\\\n\t25 & PERSONALIZATION &  392\\\\\n\t8 & COMMUNICATION   &  387\\\\\n\t30 & SPORTS          &  384\\\\\n\t20 & LIFESTYLE       &  382\\\\\n\\end{tabular}\n",
            "text/plain": [
              "   Var1            Freq\n",
              "13 FAMILY          1972\n",
              "16 GAME            1144\n",
              "31 TOOLS            843\n",
              "22 MEDICAL          463\n",
              "6  BUSINESS         460\n",
              "27 PRODUCTIVITY     424\n",
              "25 PERSONALIZATION  392\n",
              "8  COMMUNICATION    387\n",
              "30 SPORTS           384\n",
              "20 LIFESTYLE        382"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "freq.Category.Plot <- ggplot(data = category.Top10) + geom_bar(mapping = aes(x = reorder(Var1, Freq), y = Freq), stat = \"identity\") + coord_flip()\n",
        "freq.Category.Plot"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T17:03:35.492969Z",
          "iopub.execute_input": "2024-04-14T17:03:35.495789Z",
          "iopub.status.idle": "2024-04-14T17:03:35.759707Z"
        },
        "trusted": true,
        "id": "e8fhkK_dk-jc",
        "outputId": "b77a1a93-0a1d-4334-a28a-38f51bd2000b",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 18,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAAC7lBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhIUFBQVFRUWFhYX\nFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAiIiIjIyMkJCQlJSUmJiYnJycoKCgpKSkq\nKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9\nPT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhLS0tNTU1OTk5PT09QUFBRUVFS\nUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2Nk\nZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29wcHBxcXFycnJzc3N0dHR1dXV2\ndnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eI\niIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OUlJSVlZWWlpaXl5eYmJiZmZma\nmpqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWmpqanp6eoqKipqamqqqqrq6us\nrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4uLi5ubm6urq7u7u8vLy9vb2+\nvr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnKysrLy8vMzMzNzc3Ozs7Pz8/Q\n0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7f39/g4ODh4eHi\n4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P0\n9PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7///+HvUH9AAAACXBIWXMAABJ0AAAS\ndAHeZh94AAAgAElEQVR4nO3df3yV9X338dNZbbdOd68/dtf1vnfft/fara1rx917W+91a+16\nb+ckAdIsIaCCCAIZTdkKU7xDpYUUTdHWWhZFAR1TqMViYLYgUKXEQMFOKWJTFBM4kkRiDOYH\n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\nYM9yAAAAAElFTkSuQmCC"
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2 <- dados %>% filter(Category != \"1.9\")"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.228326Z",
          "iopub.execute_input": "2024-04-14T16:57:25.229881Z",
          "iopub.status.idle": "2024-04-14T16:57:25.24726Z"
        },
        "trusted": true,
        "id": "HqbnwxOKk-jc"
      },
      "execution_count": 19,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "min(dados_2$Rating)\n",
        "max(dados_2$Rating)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.250144Z",
          "iopub.execute_input": "2024-04-14T16:57:25.251628Z",
          "iopub.status.idle": "2024-04-14T16:57:25.273069Z"
        },
        "trusted": true,
        "id": "MyWj-Xifk-jc",
        "outputId": "7b8d2306-5d73-470a-edec-da2211787f7b",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 52
        }
      },
      "execution_count": 20,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "NaN"
            ],
            "text/markdown": "NaN",
            "text/latex": "NaN",
            "text/plain": [
              "[1] NaN"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "NaN"
            ],
            "text/markdown": "NaN",
            "text/latex": "NaN",
            "text/plain": [
              "[1] NaN"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2 %>% filter(is.na(Rating)) %>% count()"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.275847Z",
          "iopub.execute_input": "2024-04-14T16:57:25.277314Z",
          "iopub.status.idle": "2024-04-14T16:57:25.301831Z"
        },
        "trusted": true,
        "id": "prjBUzhnk-jd",
        "outputId": "fb5e1b41-b07c-46f8-fafb-d00e90ddc5a5",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 164
        }
      },
      "execution_count": 21,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 1 × 1</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>n</th></tr>\n",
              "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td>1474</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 1 × 1\n\n| n &lt;int&gt; |\n|---|\n| 1474 |\n\n",
            "text/latex": "A data.frame: 1 × 1\n\\begin{tabular}{l}\n n\\\\\n <int>\\\\\n\\hline\n\t 1474\\\\\n\\end{tabular}\n",
            "text/plain": [
              "  n   \n",
              "1 1474"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "summary(dados_2$Rating)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.304713Z",
          "iopub.execute_input": "2024-04-14T16:57:25.306267Z",
          "iopub.status.idle": "2024-04-14T16:57:25.323388Z"
        },
        "trusted": true,
        "id": "5LaM_gnsk-jd",
        "outputId": "2b8c0e9c-cece-4585-e44e-66e070df81a3",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 52
        }
      },
      "execution_count": 22,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's \n",
              "  1.000   4.000   4.300   4.192   4.500   5.000    1474 "
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2 %>% filter(is.na(Rating)) %>% group_by(Category) %>% count()"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.327928Z",
          "iopub.execute_input": "2024-04-14T16:57:25.329626Z",
          "iopub.status.idle": "2024-04-14T16:57:25.393826Z"
        },
        "trusted": true,
        "id": "9F9401p-k-jd",
        "outputId": "d86ce33e-ec3b-4e34-d1ce-042b83b03ebe",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 23,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A grouped_df: 32 × 2</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>Category</th><th scope=col>n</th></tr>\n",
              "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td>ART_AND_DESIGN     </td><td>  3</td></tr>\n",
              "\t<tr><td>AUTO_AND_VEHICLES  </td><td> 12</td></tr>\n",
              "\t<tr><td>BEAUTY             </td><td> 11</td></tr>\n",
              "\t<tr><td>BOOKS_AND_REFERENCE</td><td> 53</td></tr>\n",
              "\t<tr><td>BUSINESS           </td><td>157</td></tr>\n",
              "\t<tr><td>COMICS             </td><td>  2</td></tr>\n",
              "\t<tr><td>COMMUNICATION      </td><td> 59</td></tr>\n",
              "\t<tr><td>DATING             </td><td> 39</td></tr>\n",
              "\t<tr><td>EDUCATION          </td><td>  1</td></tr>\n",
              "\t<tr><td>EVENTS             </td><td> 19</td></tr>\n",
              "\t<tr><td>FAMILY             </td><td>225</td></tr>\n",
              "\t<tr><td>FINANCE            </td><td> 43</td></tr>\n",
              "\t<tr><td>FOOD_AND_DRINK     </td><td> 18</td></tr>\n",
              "\t<tr><td>GAME               </td><td> 47</td></tr>\n",
              "\t<tr><td>HEALTH_AND_FITNESS </td><td> 44</td></tr>\n",
              "\t<tr><td>HOUSE_AND_HOME     </td><td> 12</td></tr>\n",
              "\t<tr><td>LIBRARIES_AND_DEMO </td><td> 20</td></tr>\n",
              "\t<tr><td>LIFESTYLE          </td><td> 68</td></tr>\n",
              "\t<tr><td>MAPS_AND_NAVIGATION</td><td> 13</td></tr>\n",
              "\t<tr><td>MEDICAL            </td><td>113</td></tr>\n",
              "\t<tr><td>NEWS_AND_MAGAZINES </td><td> 50</td></tr>\n",
              "\t<tr><td>PARENTING          </td><td> 10</td></tr>\n",
              "\t<tr><td>PERSONALIZATION    </td><td> 78</td></tr>\n",
              "\t<tr><td>PHOTOGRAPHY        </td><td> 18</td></tr>\n",
              "\t<tr><td>PRODUCTIVITY       </td><td> 73</td></tr>\n",
              "\t<tr><td>SHOPPING           </td><td> 22</td></tr>\n",
              "\t<tr><td>SOCIAL             </td><td> 36</td></tr>\n",
              "\t<tr><td>SPORTS             </td><td> 65</td></tr>\n",
              "\t<tr><td>TOOLS              </td><td>109</td></tr>\n",
              "\t<tr><td>TRAVEL_AND_LOCAL   </td><td> 32</td></tr>\n",
              "\t<tr><td>VIDEO_PLAYERS      </td><td> 15</td></tr>\n",
              "\t<tr><td>WEATHER            </td><td>  7</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA grouped_df: 32 × 2\n\n| Category &lt;chr&gt; | n &lt;int&gt; |\n|---|---|\n| ART_AND_DESIGN      |   3 |\n| AUTO_AND_VEHICLES   |  12 |\n| BEAUTY              |  11 |\n| BOOKS_AND_REFERENCE |  53 |\n| BUSINESS            | 157 |\n| COMICS              |   2 |\n| COMMUNICATION       |  59 |\n| DATING              |  39 |\n| EDUCATION           |   1 |\n| EVENTS              |  19 |\n| FAMILY              | 225 |\n| FINANCE             |  43 |\n| FOOD_AND_DRINK      |  18 |\n| GAME                |  47 |\n| HEALTH_AND_FITNESS  |  44 |\n| HOUSE_AND_HOME      |  12 |\n| LIBRARIES_AND_DEMO  |  20 |\n| LIFESTYLE           |  68 |\n| MAPS_AND_NAVIGATION |  13 |\n| MEDICAL             | 113 |\n| NEWS_AND_MAGAZINES  |  50 |\n| PARENTING           |  10 |\n| PERSONALIZATION     |  78 |\n| PHOTOGRAPHY         |  18 |\n| PRODUCTIVITY        |  73 |\n| SHOPPING            |  22 |\n| SOCIAL              |  36 |\n| SPORTS              |  65 |\n| TOOLS               | 109 |\n| TRAVEL_AND_LOCAL    |  32 |\n| VIDEO_PLAYERS       |  15 |\n| WEATHER             |   7 |\n\n",
            "text/latex": "A grouped\\_df: 32 × 2\n\\begin{tabular}{ll}\n Category & n\\\\\n <chr> & <int>\\\\\n\\hline\n\t ART\\_AND\\_DESIGN      &   3\\\\\n\t AUTO\\_AND\\_VEHICLES   &  12\\\\\n\t BEAUTY              &  11\\\\\n\t BOOKS\\_AND\\_REFERENCE &  53\\\\\n\t BUSINESS            & 157\\\\\n\t COMICS              &   2\\\\\n\t COMMUNICATION       &  59\\\\\n\t DATING              &  39\\\\\n\t EDUCATION           &   1\\\\\n\t EVENTS              &  19\\\\\n\t FAMILY              & 225\\\\\n\t FINANCE             &  43\\\\\n\t FOOD\\_AND\\_DRINK      &  18\\\\\n\t GAME                &  47\\\\\n\t HEALTH\\_AND\\_FITNESS  &  44\\\\\n\t HOUSE\\_AND\\_HOME      &  12\\\\\n\t LIBRARIES\\_AND\\_DEMO  &  20\\\\\n\t LIFESTYLE           &  68\\\\\n\t MAPS\\_AND\\_NAVIGATION &  13\\\\\n\t MEDICAL             & 113\\\\\n\t NEWS\\_AND\\_MAGAZINES  &  50\\\\\n\t PARENTING           &  10\\\\\n\t PERSONALIZATION     &  78\\\\\n\t PHOTOGRAPHY         &  18\\\\\n\t PRODUCTIVITY        &  73\\\\\n\t SHOPPING            &  22\\\\\n\t SOCIAL              &  36\\\\\n\t SPORTS              &  65\\\\\n\t TOOLS               & 109\\\\\n\t TRAVEL\\_AND\\_LOCAL    &  32\\\\\n\t VIDEO\\_PLAYERS       &  15\\\\\n\t WEATHER             &   7\\\\\n\\end{tabular}\n",
            "text/plain": [
              "   Category            n  \n",
              "1  ART_AND_DESIGN        3\n",
              "2  AUTO_AND_VEHICLES    12\n",
              "3  BEAUTY               11\n",
              "4  BOOKS_AND_REFERENCE  53\n",
              "5  BUSINESS            157\n",
              "6  COMICS                2\n",
              "7  COMMUNICATION        59\n",
              "8  DATING               39\n",
              "9  EDUCATION             1\n",
              "10 EVENTS               19\n",
              "11 FAMILY              225\n",
              "12 FINANCE              43\n",
              "13 FOOD_AND_DRINK       18\n",
              "14 GAME                 47\n",
              "15 HEALTH_AND_FITNESS   44\n",
              "16 HOUSE_AND_HOME       12\n",
              "17 LIBRARIES_AND_DEMO   20\n",
              "18 LIFESTYLE            68\n",
              "19 MAPS_AND_NAVIGATION  13\n",
              "20 MEDICAL             113\n",
              "21 NEWS_AND_MAGAZINES   50\n",
              "22 PARENTING            10\n",
              "23 PERSONALIZATION      78\n",
              "24 PHOTOGRAPHY          18\n",
              "25 PRODUCTIVITY         73\n",
              "26 SHOPPING             22\n",
              "27 SOCIAL               36\n",
              "28 SPORTS               65\n",
              "29 TOOLS               109\n",
              "30 TRAVEL_AND_LOCAL     32\n",
              "31 VIDEO_PLAYERS        15\n",
              "32 WEATHER               7"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "mean.Category <- dados_2 %>% filter(!is.na(Rating)) %>% group_by(Category) %>% summarize(media = mean(Rating))\n",
        "mean.Category"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.398177Z",
          "iopub.execute_input": "2024-04-14T16:57:25.399743Z",
          "iopub.status.idle": "2024-04-14T16:57:25.451607Z"
        },
        "trusted": true,
        "id": "sHWvbT6uk-jd",
        "outputId": "b5f6d518-0fbb-41fa-8538-b7a7c2beb238",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 24,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A tibble: 33 × 2</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>Category</th><th scope=col>media</th></tr>\n",
              "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td>ART_AND_DESIGN     </td><td>4.358065</td></tr>\n",
              "\t<tr><td>AUTO_AND_VEHICLES  </td><td>4.190411</td></tr>\n",
              "\t<tr><td>BEAUTY             </td><td>4.278571</td></tr>\n",
              "\t<tr><td>BOOKS_AND_REFERENCE</td><td>4.346067</td></tr>\n",
              "\t<tr><td>BUSINESS           </td><td>4.121452</td></tr>\n",
              "\t<tr><td>COMICS             </td><td>4.155172</td></tr>\n",
              "\t<tr><td>COMMUNICATION      </td><td>4.158537</td></tr>\n",
              "\t<tr><td>DATING             </td><td>3.970769</td></tr>\n",
              "\t<tr><td>EDUCATION          </td><td>4.389032</td></tr>\n",
              "\t<tr><td>ENTERTAINMENT      </td><td>4.126174</td></tr>\n",
              "\t<tr><td>EVENTS             </td><td>4.435556</td></tr>\n",
              "\t<tr><td>FAMILY             </td><td>4.192272</td></tr>\n",
              "\t<tr><td>FINANCE            </td><td>4.131889</td></tr>\n",
              "\t<tr><td>FOOD_AND_DRINK     </td><td>4.166972</td></tr>\n",
              "\t<tr><td>GAME               </td><td>4.286326</td></tr>\n",
              "\t<tr><td>HEALTH_AND_FITNESS </td><td>4.277104</td></tr>\n",
              "\t<tr><td>HOUSE_AND_HOME     </td><td>4.197368</td></tr>\n",
              "\t<tr><td>LIBRARIES_AND_DEMO </td><td>4.178462</td></tr>\n",
              "\t<tr><td>LIFESTYLE          </td><td>4.094904</td></tr>\n",
              "\t<tr><td>MAPS_AND_NAVIGATION</td><td>4.051613</td></tr>\n",
              "\t<tr><td>MEDICAL            </td><td>4.189143</td></tr>\n",
              "\t<tr><td>NEWS_AND_MAGAZINES </td><td>4.132189</td></tr>\n",
              "\t<tr><td>PARENTING          </td><td>4.300000</td></tr>\n",
              "\t<tr><td>PERSONALIZATION    </td><td>4.335987</td></tr>\n",
              "\t<tr><td>PHOTOGRAPHY        </td><td>4.192114</td></tr>\n",
              "\t<tr><td>PRODUCTIVITY       </td><td>4.211396</td></tr>\n",
              "\t<tr><td>SHOPPING           </td><td>4.259664</td></tr>\n",
              "\t<tr><td>SOCIAL             </td><td>4.255598</td></tr>\n",
              "\t<tr><td>SPORTS             </td><td>4.223511</td></tr>\n",
              "\t<tr><td>TOOLS              </td><td>4.047411</td></tr>\n",
              "\t<tr><td>TRAVEL_AND_LOCAL   </td><td>4.109292</td></tr>\n",
              "\t<tr><td>VIDEO_PLAYERS      </td><td>4.063750</td></tr>\n",
              "\t<tr><td>WEATHER            </td><td>4.244000</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA tibble: 33 × 2\n\n| Category &lt;chr&gt; | media &lt;dbl&gt; |\n|---|---|\n| ART_AND_DESIGN      | 4.358065 |\n| AUTO_AND_VEHICLES   | 4.190411 |\n| BEAUTY              | 4.278571 |\n| BOOKS_AND_REFERENCE | 4.346067 |\n| BUSINESS            | 4.121452 |\n| COMICS              | 4.155172 |\n| COMMUNICATION       | 4.158537 |\n| DATING              | 3.970769 |\n| EDUCATION           | 4.389032 |\n| ENTERTAINMENT       | 4.126174 |\n| EVENTS              | 4.435556 |\n| FAMILY              | 4.192272 |\n| FINANCE             | 4.131889 |\n| FOOD_AND_DRINK      | 4.166972 |\n| GAME                | 4.286326 |\n| HEALTH_AND_FITNESS  | 4.277104 |\n| HOUSE_AND_HOME      | 4.197368 |\n| LIBRARIES_AND_DEMO  | 4.178462 |\n| LIFESTYLE           | 4.094904 |\n| MAPS_AND_NAVIGATION | 4.051613 |\n| MEDICAL             | 4.189143 |\n| NEWS_AND_MAGAZINES  | 4.132189 |\n| PARENTING           | 4.300000 |\n| PERSONALIZATION     | 4.335987 |\n| PHOTOGRAPHY         | 4.192114 |\n| PRODUCTIVITY        | 4.211396 |\n| SHOPPING            | 4.259664 |\n| SOCIAL              | 4.255598 |\n| SPORTS              | 4.223511 |\n| TOOLS               | 4.047411 |\n| TRAVEL_AND_LOCAL    | 4.109292 |\n| VIDEO_PLAYERS       | 4.063750 |\n| WEATHER             | 4.244000 |\n\n",
            "text/latex": "A tibble: 33 × 2\n\\begin{tabular}{ll}\n Category & media\\\\\n <chr> & <dbl>\\\\\n\\hline\n\t ART\\_AND\\_DESIGN      & 4.358065\\\\\n\t AUTO\\_AND\\_VEHICLES   & 4.190411\\\\\n\t BEAUTY              & 4.278571\\\\\n\t BOOKS\\_AND\\_REFERENCE & 4.346067\\\\\n\t BUSINESS            & 4.121452\\\\\n\t COMICS              & 4.155172\\\\\n\t COMMUNICATION       & 4.158537\\\\\n\t DATING              & 3.970769\\\\\n\t EDUCATION           & 4.389032\\\\\n\t ENTERTAINMENT       & 4.126174\\\\\n\t EVENTS              & 4.435556\\\\\n\t FAMILY              & 4.192272\\\\\n\t FINANCE             & 4.131889\\\\\n\t FOOD\\_AND\\_DRINK      & 4.166972\\\\\n\t GAME                & 4.286326\\\\\n\t HEALTH\\_AND\\_FITNESS  & 4.277104\\\\\n\t HOUSE\\_AND\\_HOME      & 4.197368\\\\\n\t LIBRARIES\\_AND\\_DEMO  & 4.178462\\\\\n\t LIFESTYLE           & 4.094904\\\\\n\t MAPS\\_AND\\_NAVIGATION & 4.051613\\\\\n\t MEDICAL             & 4.189143\\\\\n\t NEWS\\_AND\\_MAGAZINES  & 4.132189\\\\\n\t PARENTING           & 4.300000\\\\\n\t PERSONALIZATION     & 4.335987\\\\\n\t PHOTOGRAPHY         & 4.192114\\\\\n\t PRODUCTIVITY        & 4.211396\\\\\n\t SHOPPING            & 4.259664\\\\\n\t SOCIAL              & 4.255598\\\\\n\t SPORTS              & 4.223511\\\\\n\t TOOLS               & 4.047411\\\\\n\t TRAVEL\\_AND\\_LOCAL    & 4.109292\\\\\n\t VIDEO\\_PLAYERS       & 4.063750\\\\\n\t WEATHER             & 4.244000\\\\\n\\end{tabular}\n",
            "text/plain": [
              "   Category            media   \n",
              "1  ART_AND_DESIGN      4.358065\n",
              "2  AUTO_AND_VEHICLES   4.190411\n",
              "3  BEAUTY              4.278571\n",
              "4  BOOKS_AND_REFERENCE 4.346067\n",
              "5  BUSINESS            4.121452\n",
              "6  COMICS              4.155172\n",
              "7  COMMUNICATION       4.158537\n",
              "8  DATING              3.970769\n",
              "9  EDUCATION           4.389032\n",
              "10 ENTERTAINMENT       4.126174\n",
              "11 EVENTS              4.435556\n",
              "12 FAMILY              4.192272\n",
              "13 FINANCE             4.131889\n",
              "14 FOOD_AND_DRINK      4.166972\n",
              "15 GAME                4.286326\n",
              "16 HEALTH_AND_FITNESS  4.277104\n",
              "17 HOUSE_AND_HOME      4.197368\n",
              "18 LIBRARIES_AND_DEMO  4.178462\n",
              "19 LIFESTYLE           4.094904\n",
              "20 MAPS_AND_NAVIGATION 4.051613\n",
              "21 MEDICAL             4.189143\n",
              "22 NEWS_AND_MAGAZINES  4.132189\n",
              "23 PARENTING           4.300000\n",
              "24 PERSONALIZATION     4.335987\n",
              "25 PHOTOGRAPHY         4.192114\n",
              "26 PRODUCTIVITY        4.211396\n",
              "27 SHOPPING            4.259664\n",
              "28 SOCIAL              4.255598\n",
              "29 SPORTS              4.223511\n",
              "30 TOOLS               4.047411\n",
              "31 TRAVEL_AND_LOCAL    4.109292\n",
              "32 VIDEO_PLAYERS       4.063750\n",
              "33 WEATHER             4.244000"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "for(i in 1:nrow(dados_2)){\n",
        "    if(is.na(dados_2[i, \"Rating\"])){\n",
        "        dados_2[i, \"newRating\"] <- mean.Category[mean.Category$Category == dados_2[i, \"Category\"], \"media\"]\n",
        "    }else{\n",
        "        dados_2[i, \"newRating\"] <- dados_2[i, \"Rating\"]\n",
        "    }\n",
        "}"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:25.454397Z",
          "iopub.execute_input": "2024-04-14T16:57:25.455905Z",
          "iopub.status.idle": "2024-04-14T16:57:27.044269Z"
        },
        "trusted": true,
        "id": "5H7rCsx4k-jd"
      },
      "execution_count": 25,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "View(dados_2)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.048642Z",
          "iopub.execute_input": "2024-04-14T16:57:27.050302Z",
          "iopub.status.idle": "2024-04-14T16:57:27.203177Z"
        },
        "trusted": true,
        "id": "SH0hxLSJk-jd",
        "outputId": "e0fe98a5-6d0d-4fa5-e797-f9185ac72dce",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 26,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "      App                                                Category           \n",
              "1     Photo Editor & Candy Camera & Grid & ScrapBook     ART_AND_DESIGN     \n",
              "2     Coloring book moana                                ART_AND_DESIGN     \n",
              "3     U Launcher Lite – FREE Live Cool Themes, Hide Apps ART_AND_DESIGN     \n",
              "4     Sketch - Draw & Paint                              ART_AND_DESIGN     \n",
              "5     Pixel Draw - Number Art Coloring Book              ART_AND_DESIGN     \n",
              "6     Paper flowers instructions                         ART_AND_DESIGN     \n",
              "7     Smoke Effect Photo Maker - Smoke Editor            ART_AND_DESIGN     \n",
              "8     Infinite Painter                                   ART_AND_DESIGN     \n",
              "9     Garden Coloring Book                               ART_AND_DESIGN     \n",
              "10    Kids Paint Free - Drawing Fun                      ART_AND_DESIGN     \n",
              "11    Text on Photo - Fonteee                            ART_AND_DESIGN     \n",
              "12    Name Art Photo Editor - Focus n Filters            ART_AND_DESIGN     \n",
              "13    Tattoo Name On My Photo Editor                     ART_AND_DESIGN     \n",
              "14    Mandala Coloring Book                              ART_AND_DESIGN     \n",
              "15    3D Color Pixel by Number - Sandbox Art Coloring    ART_AND_DESIGN     \n",
              "16    Learn To Draw Kawaii Characters                    ART_AND_DESIGN     \n",
              "17    Photo Designer - Write your name with shapes       ART_AND_DESIGN     \n",
              "18    350 Diy Room Decor Ideas                           ART_AND_DESIGN     \n",
              "19    FlipaClip - Cartoon animation                      ART_AND_DESIGN     \n",
              "20    ibis Paint X                                       ART_AND_DESIGN     \n",
              "21    Logo Maker - Small Business                        ART_AND_DESIGN     \n",
              "22    Boys Photo Editor - Six Pack & Men's Suit          ART_AND_DESIGN     \n",
              "23    Superheroes Wallpapers | 4K Backgrounds            ART_AND_DESIGN     \n",
              "24    Mcqueen Coloring pages                             ART_AND_DESIGN     \n",
              "25    HD Mickey Minnie Wallpapers                        ART_AND_DESIGN     \n",
              "26    Harley Quinn wallpapers HD                         ART_AND_DESIGN     \n",
              "27    Colorfit - Drawing & Coloring                      ART_AND_DESIGN     \n",
              "28    Animated Photo Editor                              ART_AND_DESIGN     \n",
              "29    Pencil Sketch Drawing                              ART_AND_DESIGN     \n",
              "30    Easy Realistic Drawing Tutorial                    ART_AND_DESIGN     \n",
              "⋮     ⋮                                                  ⋮                  \n",
              "10811 FR Plus 1.6                                        AUTO_AND_VEHICLES  \n",
              "10812 Fr Agnel Pune                                      FAMILY             \n",
              "10813 DICT.fr Mobile                                     BUSINESS           \n",
              "10814 FR: My Secret Pets!                                FAMILY             \n",
              "10815 Golden Dictionary (FR-AR)                          BOOKS_AND_REFERENCE\n",
              "10816 FieldBi FR Offline                                 BUSINESS           \n",
              "10817 HTC Sense Input - FR                               TOOLS              \n",
              "10818 Gold Quote - Gold.fr                               FINANCE            \n",
              "10819 Fanfic-FR                                          BOOKS_AND_REFERENCE\n",
              "10820 Fr. Daoud Lamei                                    FAMILY             \n",
              "10821 Poop FR                                            FAMILY             \n",
              "10822 PLMGSS FR                                          PRODUCTIVITY       \n",
              "10823 List iptv FR                                       VIDEO_PLAYERS      \n",
              "10824 Cardio-FR                                          MEDICAL            \n",
              "10825 Naruto & Boruto FR                                 SOCIAL             \n",
              "10826 Frim: get new friends on local chat rooms          SOCIAL             \n",
              "10827 Fr Agnel Ambarnath                                 FAMILY             \n",
              "10828 Manga-FR - Anime Vostfr                            COMICS             \n",
              "10829 Bulgarian French Dictionary Fr                     BOOKS_AND_REFERENCE\n",
              "10830 News Minecraft.fr                                  NEWS_AND_MAGAZINES \n",
              "10831 payermonstationnement.fr                           MAPS_AND_NAVIGATION\n",
              "10832 FR Tides                                           WEATHER            \n",
              "10833 Chemin (fr)                                        BOOKS_AND_REFERENCE\n",
              "10834 FR Calculator                                      FAMILY             \n",
              "10835 FR Forms                                           BUSINESS           \n",
              "10836 Sya9a Maroc - FR                                   FAMILY             \n",
              "10837 Fr. Mike Schmitz Audio Teachings                   FAMILY             \n",
              "10838 Parkinson Exercices FR                             MEDICAL            \n",
              "10839 The SCP Foundation DB fr nn5n                      BOOKS_AND_REFERENCE\n",
              "10840 iHoroscope - 2018 Daily Horoscope & Astrology      LIFESTYLE          \n",
              "      Rating Reviews Size               Installs    Type Price Content.Rating\n",
              "1     4.1    159     19M                10,000+     Free 0     Everyone      \n",
              "2     3.9    967     14M                500,000+    Free 0     Everyone      \n",
              "3     4.7    87510   8.7M               5,000,000+  Free 0     Everyone      \n",
              "4     4.5    215644  25M                50,000,000+ Free 0     Teen          \n",
              "5     4.3    967     2.8M               100,000+    Free 0     Everyone      \n",
              "6     4.4    167     5.6M               50,000+     Free 0     Everyone      \n",
              "7     3.8    178     19M                50,000+     Free 0     Everyone      \n",
              "8     4.1    36815   29M                1,000,000+  Free 0     Everyone      \n",
              "9     4.4    13791   33M                1,000,000+  Free 0     Everyone      \n",
              "10    4.7    121     3.1M               10,000+     Free 0     Everyone      \n",
              "11    4.4    13880   28M                1,000,000+  Free 0     Everyone      \n",
              "12    4.4    8788    12M                1,000,000+  Free 0     Everyone      \n",
              "13    4.2    44829   20M                10,000,000+ Free 0     Teen          \n",
              "14    4.6    4326    21M                100,000+    Free 0     Everyone      \n",
              "15    4.4    1518    37M                100,000+    Free 0     Everyone      \n",
              "16    3.2    55      2.7M               5,000+      Free 0     Everyone      \n",
              "17    4.7    3632    5.5M               500,000+    Free 0     Everyone      \n",
              "18    4.5    27      17M                10,000+     Free 0     Everyone      \n",
              "19    4.3    194216  39M                5,000,000+  Free 0     Everyone      \n",
              "20    4.6    224399  31M                10,000,000+ Free 0     Everyone      \n",
              "21    4.0    450     14M                100,000+    Free 0     Everyone      \n",
              "22    4.1    654     12M                100,000+    Free 0     Everyone      \n",
              "23    4.7    7699    4.2M               500,000+    Free 0     Everyone 10+  \n",
              "24    NaN    61      7.0M               100,000+    Free 0     Everyone      \n",
              "25    4.7    118     23M                50,000+     Free 0     Everyone      \n",
              "26    4.8    192     6.0M               10,000+     Free 0     Everyone      \n",
              "27    4.7    20260   25M                500,000+    Free 0     Everyone      \n",
              "28    4.1    203     6.1M               100,000+    Free 0     Everyone      \n",
              "29    3.9    136     4.6M               10,000+     Free 0     Everyone      \n",
              "30    4.1    223     4.2M               100,000+    Free 0     Everyone      \n",
              "⋮     ⋮      ⋮       ⋮                  ⋮           ⋮    ⋮     ⋮             \n",
              "10811 NaN    4       3.9M               100+        Free 0     Everyone      \n",
              "10812 4.1    80      13M                1,000+      Free 0     Everyone      \n",
              "10813 NaN    20      2.7M               10,000+     Free 0     Everyone      \n",
              "10814 4.0    785     31M                50,000+     Free 0     Teen          \n",
              "10815 4.2    5775    4.9M               500,000+    Free 0     Everyone      \n",
              "10816 NaN    2       6.8M               100+        Free 0     Everyone      \n",
              "10817 4.0    885     8.0M               100,000+    Free 0     Everyone      \n",
              "10818 NaN    96      1.5M               10,000+     Free 0     Everyone      \n",
              "10819 3.3    52      3.6M               5,000+      Free 0     Teen          \n",
              "10820 5.0    22      8.6M               1,000+      Free 0     Teen          \n",
              "10821 NaN    6       2.5M               50+         Free 0     Everyone      \n",
              "10822 NaN    0       3.1M               10+         Free 0     Everyone      \n",
              "10823 NaN    1       2.9M               100+        Free 0     Everyone      \n",
              "10824 NaN    67      82M                10,000+     Free 0     Everyone      \n",
              "10825 NaN    7       7.7M               100+        Free 0     Teen          \n",
              "10826 4.0    88486   Varies with device 5,000,000+  Free 0     Mature 17+    \n",
              "10827 4.2    117     13M                5,000+      Free 0     Everyone      \n",
              "10828 3.4    291     13M                10,000+     Free 0     Everyone      \n",
              "10829 4.6    603     7.4M               10,000+     Free 0     Everyone      \n",
              "10830 3.8    881     2.3M               100,000+    Free 0     Everyone      \n",
              "10831 NaN    38      9.8M               5,000+      Free 0     Everyone      \n",
              "10832 3.8    1195    582k               100,000+    Free 0     Everyone      \n",
              "10833 4.8    44      619k               1,000+      Free 0     Everyone      \n",
              "10834 4.0    7       2.6M               500+        Free 0     Everyone      \n",
              "10835 NaN    0       9.6M               10+         Free 0     Everyone      \n",
              "10836 4.5    38      53M                5,000+      Free 0     Everyone      \n",
              "10837 5.0    4       3.6M               100+        Free 0     Everyone      \n",
              "10838 NaN    3       9.5M               1,000+      Free 0     Everyone      \n",
              "10839 4.5    114     Varies with device 1,000+      Free 0     Mature 17+    \n",
              "10840 4.5    398307  19M                10,000,000+ Free 0     Everyone      \n",
              "      Genres                          Last.Updated       Current.Ver       \n",
              "1     Art & Design                    January 7, 2018    1.0.0             \n",
              "2     Art & Design;Pretend Play       January 15, 2018   2.0.0             \n",
              "3     Art & Design                    August 1, 2018     1.2.4             \n",
              "4     Art & Design                    June 8, 2018       Varies with device\n",
              "5     Art & Design;Creativity         June 20, 2018      1.1               \n",
              "6     Art & Design                    March 26, 2017     1.0               \n",
              "7     Art & Design                    April 26, 2018     1.1               \n",
              "8     Art & Design                    June 14, 2018      6.1.61.1          \n",
              "9     Art & Design                    September 20, 2017 2.9.2             \n",
              "10    Art & Design;Creativity         July 3, 2018       2.8               \n",
              "11    Art & Design                    October 27, 2017   1.0.4             \n",
              "12    Art & Design                    July 31, 2018      1.0.15            \n",
              "13    Art & Design                    April 2, 2018      3.8               \n",
              "14    Art & Design                    June 26, 2018      1.0.4             \n",
              "15    Art & Design                    August 3, 2018     1.2.3             \n",
              "16    Art & Design                    June 6, 2018       NaN               \n",
              "17    Art & Design                    July 31, 2018      3.1               \n",
              "18    Art & Design                    November 7, 2017   1.0               \n",
              "19    Art & Design                    August 3, 2018     2.2.5             \n",
              "20    Art & Design                    July 30, 2018      5.5.4             \n",
              "21    Art & Design                    April 20, 2018     4.0               \n",
              "22    Art & Design                    March 20, 2018     1.1               \n",
              "23    Art & Design                    July 12, 2018      2.2.6.2           \n",
              "24    Art & Design;Action & Adventure March 7, 2018      1.0.0             \n",
              "25    Art & Design                    July 7, 2018       1.1.3             \n",
              "26    Art & Design                    April 25, 2018     1.5               \n",
              "27    Art & Design;Creativity         October 11, 2017   1.0.8             \n",
              "28    Art & Design                    March 21, 2018     1.03              \n",
              "29    Art & Design                    July 12, 2018      6.0               \n",
              "30    Art & Design                    August 22, 2017    1.0               \n",
              "⋮     ⋮                               ⋮                  ⋮                 \n",
              "10811 Auto & Vehicles                 July 24, 2018      1.3.6             \n",
              "10812 Education                       June 13, 2018      2.0.20            \n",
              "10813 Business                        July 17, 2018      2.1.10            \n",
              "10814 Entertainment                   June 3, 2015       1.3.1             \n",
              "10815 Books & Reference               July 19, 2018      7.0.4.6           \n",
              "10816 Business                        August 6, 2018     2.1.8             \n",
              "10817 Tools                           October 30, 2015   1.0.612928        \n",
              "10818 Finance                         May 19, 2016       2.3               \n",
              "10819 Books & Reference               August 5, 2017     0.3.4             \n",
              "10820 Education                       June 27, 2018      3.8.0             \n",
              "10821 Entertainment                   May 29, 2018       1.0               \n",
              "10822 Productivity                    December 1, 2017   1                 \n",
              "10823 Video Players & Editors         April 22, 2018     1.0               \n",
              "10824 Medical                         July 31, 2018      2.2.2             \n",
              "10825 Social                          February 2, 2018   1.0               \n",
              "10826 Social                          March 23, 2018     Varies with device\n",
              "10827 Education                       June 13, 2018      2.0.20            \n",
              "10828 Comics                          May 15, 2017       2.0.1             \n",
              "10829 Books & Reference               June 19, 2016      2.96              \n",
              "10830 News & Magazines                January 20, 2014   1.5               \n",
              "10831 Maps & Navigation               June 13, 2018      2.0.148.0         \n",
              "10832 Weather                         February 16, 2014  6.0               \n",
              "10833 Books & Reference               March 23, 2014     0.8               \n",
              "10834 Education                       June 18, 2017      1.0.0             \n",
              "10835 Business                        September 29, 2016 1.1.5             \n",
              "10836 Education                       July 25, 2017      1.48              \n",
              "10837 Education                       July 6, 2018       1.0               \n",
              "10838 Medical                         January 20, 2017   1.0               \n",
              "10839 Books & Reference               January 19, 2015   Varies with device\n",
              "10840 Lifestyle                       July 25, 2018      Varies with device\n",
              "      Android.Ver        newRating\n",
              "1     4.0.3 and up       4.100000 \n",
              "2     4.0.3 and up       3.900000 \n",
              "3     4.0.3 and up       4.700000 \n",
              "4     4.2 and up         4.500000 \n",
              "5     4.4 and up         4.300000 \n",
              "6     2.3 and up         4.400000 \n",
              "7     4.0.3 and up       3.800000 \n",
              "8     4.2 and up         4.100000 \n",
              "9     3.0 and up         4.400000 \n",
              "10    4.0.3 and up       4.700000 \n",
              "11    4.1 and up         4.400000 \n",
              "12    4.0 and up         4.400000 \n",
              "13    4.1 and up         4.200000 \n",
              "14    4.4 and up         4.600000 \n",
              "15    2.3 and up         4.400000 \n",
              "16    4.2 and up         3.200000 \n",
              "17    4.1 and up         4.700000 \n",
              "18    2.3 and up         4.500000 \n",
              "19    4.0.3 and up       4.300000 \n",
              "20    4.1 and up         4.600000 \n",
              "21    4.1 and up         4.000000 \n",
              "22    4.0.3 and up       4.100000 \n",
              "23    4.0.3 and up       4.700000 \n",
              "24    4.1 and up         4.358065 \n",
              "25    4.1 and up         4.700000 \n",
              "26    3.0 and up         4.800000 \n",
              "27    4.0.3 and up       4.700000 \n",
              "28    4.0.3 and up       4.100000 \n",
              "29    2.3 and up         3.900000 \n",
              "30    2.3 and up         4.100000 \n",
              "⋮     ⋮                  ⋮        \n",
              "10811 4.4W and up        4.190411 \n",
              "10812 4.0.3 and up       4.100000 \n",
              "10813 4.1 and up         4.121452 \n",
              "10814 3.0 and up         4.000000 \n",
              "10815 4.2 and up         4.200000 \n",
              "10816 4.1 and up         4.121452 \n",
              "10817 5.0 and up         4.000000 \n",
              "10818 2.2 and up         4.131889 \n",
              "10819 4.1 and up         3.300000 \n",
              "10820 4.1 and up         5.000000 \n",
              "10821 4.0.3 and up       4.192272 \n",
              "10822 4.4 and up         4.211396 \n",
              "10823 4.0.3 and up       4.063750 \n",
              "10824 4.4 and up         4.189143 \n",
              "10825 4.0 and up         4.255598 \n",
              "10826 Varies with device 4.000000 \n",
              "10827 4.0.3 and up       4.200000 \n",
              "10828 4.0 and up         3.400000 \n",
              "10829 4.1 and up         4.600000 \n",
              "10830 1.6 and up         3.800000 \n",
              "10831 4.0 and up         4.051613 \n",
              "10832 2.1 and up         3.800000 \n",
              "10833 2.2 and up         4.800000 \n",
              "10834 4.1 and up         4.000000 \n",
              "10835 4.0 and up         4.121452 \n",
              "10836 4.1 and up         4.500000 \n",
              "10837 4.1 and up         5.000000 \n",
              "10838 2.2 and up         4.189143 \n",
              "10839 Varies with device 4.500000 \n",
              "10840 Varies with device 4.500000 "
            ],
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 10840 × 14</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>App</th><th scope=col>Category</th><th scope=col>Rating</th><th scope=col>Reviews</th><th scope=col>Size</th><th scope=col>Installs</th><th scope=col>Type</th><th scope=col>Price</th><th scope=col>Content.Rating</th><th scope=col>Genres</th><th scope=col>Last.Updated</th><th scope=col>Current.Ver</th><th scope=col>Android.Ver</th><th scope=col>newRating</th></tr>\n",
              "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook    </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>159   </span></td><td>19M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>January 7, 2018   </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td>4.0.3 and up</td><td>4.100000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Coloring book moana                               </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>967   </span></td><td>14M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Pretend Play      </span></td><td><span style=white-space:pre-wrap>January 15, 2018  </span></td><td><span style=white-space:pre-wrap>2.0.0             </span></td><td>4.0.3 and up</td><td>3.900000</td></tr>\n",
              "\t<tr><td>U Launcher Lite – FREE Live Cool Themes, Hide Apps</td><td>ART_AND_DESIGN</td><td>4.7</td><td>87510 </td><td>8.7M</td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 1, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.4             </span></td><td>4.0.3 and up</td><td>4.700000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Sketch - Draw &amp; Paint                             </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td>215644</td><td>25M </td><td>50,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 8, 2018      </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>4.500000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pixel Draw - Number Art Coloring Book             </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td><span style=white-space:pre-wrap>967   </span></td><td>2.8M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>June 20, 2018     </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td><td>4.300000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Paper flowers instructions                        </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>167   </span></td><td>5.6M</td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 26, 2017    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.400000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Smoke Effect Photo Maker - Smoke Editor           </span></td><td>ART_AND_DESIGN</td><td>3.8</td><td><span style=white-space:pre-wrap>178   </span></td><td>19M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 26, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td><td>3.800000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Infinite Painter                                  </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td>36815 </td><td>29M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 14, 2018     </span></td><td><span style=white-space:pre-wrap>6.1.61.1          </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>4.100000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Garden Coloring Book                              </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13791 </td><td>33M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td>September 20, 2017</td><td><span style=white-space:pre-wrap>2.9.2             </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td><td>4.400000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Kids Paint Free - Drawing Fun                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>121   </span></td><td>3.1M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>July 3, 2018      </span></td><td><span style=white-space:pre-wrap>2.8               </span></td><td>4.0.3 and up</td><td>4.700000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Text on Photo - Fonteee                           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13880 </td><td>28M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>October 27, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.400000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Name Art Photo Editor - Focus n Filters           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>8788  </span></td><td>12M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.15            </span></td><td><span style=white-space:pre-wrap>4.0 and up  </span></td><td>4.400000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Tattoo Name On My Photo Editor                    </span></td><td>ART_AND_DESIGN</td><td>4.2</td><td>44829 </td><td>20M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 2, 2018     </span></td><td><span style=white-space:pre-wrap>3.8               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.200000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mandala Coloring Book                             </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td><span style=white-space:pre-wrap>4326  </span></td><td>21M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 26, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td><td>4.600000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>3D Color Pixel by Number - Sandbox Art Coloring   </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>1518  </span></td><td>37M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.3             </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.400000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Learn To Draw Kawaii Characters                   </span></td><td>ART_AND_DESIGN</td><td>3.2</td><td><span style=white-space:pre-wrap>55    </span></td><td>2.7M</td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 6, 2018      </span></td><td><span style=white-space:pre-wrap>NaN               </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>3.200000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Designer - Write your name with shapes      </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>3632  </span></td><td>5.5M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>3.1               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.700000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>350 Diy Room Decor Ideas                          </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td><span style=white-space:pre-wrap>27    </span></td><td>17M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>November 7, 2017  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.500000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FlipaClip - Cartoon animation                     </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td>194216</td><td>39M </td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>2.2.5             </span></td><td>4.0.3 and up</td><td>4.300000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>ibis Paint X                                      </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td>224399</td><td>31M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 30, 2018     </span></td><td><span style=white-space:pre-wrap>5.5.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.600000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Logo Maker - Small Business                       </span></td><td>ART_AND_DESIGN</td><td>4.0</td><td><span style=white-space:pre-wrap>450   </span></td><td>14M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 20, 2018    </span></td><td><span style=white-space:pre-wrap>4.0               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.000000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Boys Photo Editor - Six Pack &amp; Men's Suit         </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>654   </span></td><td>12M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 20, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td><td>4.100000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Superheroes Wallpapers | 4K Backgrounds           </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>7699  </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td>Everyone 10+</td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>2.2.6.2           </span></td><td>4.0.3 and up</td><td>4.700000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mcqueen Coloring pages                            </span></td><td>ART_AND_DESIGN</td><td>NaN</td><td><span style=white-space:pre-wrap>61    </span></td><td>7.0M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td>Art &amp; Design;Action &amp; Adventure</td><td><span style=white-space:pre-wrap>March 7, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.358065</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>HD Mickey Minnie Wallpapers                       </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>118   </span></td><td>23M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 7, 2018      </span></td><td><span style=white-space:pre-wrap>1.1.3             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.700000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Harley Quinn wallpapers HD                        </span></td><td>ART_AND_DESIGN</td><td>4.8</td><td><span style=white-space:pre-wrap>192   </span></td><td>6.0M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 25, 2018    </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td><td>4.800000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Colorfit - Drawing &amp; Coloring                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td>20260 </td><td>25M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>October 11, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.8             </span></td><td>4.0.3 and up</td><td>4.700000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Animated Photo Editor                             </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>203   </span></td><td>6.1M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 21, 2018    </span></td><td><span style=white-space:pre-wrap>1.03              </span></td><td>4.0.3 and up</td><td>4.100000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pencil Sketch Drawing                             </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>136   </span></td><td>4.6M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>6.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>3.900000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Easy Realistic Drawing Tutorial                   </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>223   </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 22, 2017   </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.100000</td></tr>\n",
              "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FR Plus 1.6                                  </span></td><td><span style=white-space:pre-wrap>AUTO_AND_VEHICLES  </span></td><td>NaN</td><td><span style=white-space:pre-wrap>4     </span></td><td><span style=white-space:pre-wrap>3.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Auto &amp; Vehicles        </span></td><td><span style=white-space:pre-wrap>July 24, 2018     </span></td><td><span style=white-space:pre-wrap>1.3.6             </span></td><td><span style=white-space:pre-wrap>4.4W and up       </span></td><td>4.190411</td></tr>\n",
              "\t<tr><td>Fr Agnel Pune                                </td><td>FAMILY             </td><td>4.1</td><td>80    </td><td>13M               </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td><td>4.100000</td></tr>\n",
              "\t<tr><td>DICT.fr Mobile                               </td><td>BUSINESS           </td><td>NaN</td><td>20    </td><td>2.7M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>July 17, 2018     </td><td>2.1.10            </td><td>4.1 and up        </td><td>4.121452</td></tr>\n",
              "\t<tr><td>FR: My Secret Pets!                          </td><td>FAMILY             </td><td>4.0</td><td>785   </td><td>31M               </td><td>50,000+    </td><td>Free</td><td>0</td><td>Teen      </td><td>Entertainment          </td><td>June 3, 2015      </td><td>1.3.1             </td><td>3.0 and up        </td><td>4.000000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Golden Dictionary (FR-AR)                    </span></td><td>BOOKS_AND_REFERENCE</td><td>4.2</td><td><span style=white-space:pre-wrap>5775  </span></td><td><span style=white-space:pre-wrap>4.9M              </span></td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>July 19, 2018     </span></td><td><span style=white-space:pre-wrap>7.0.4.6           </span></td><td><span style=white-space:pre-wrap>4.2 and up        </span></td><td>4.200000</td></tr>\n",
              "\t<tr><td>FieldBi FR Offline                           </td><td>BUSINESS           </td><td>NaN</td><td>2     </td><td>6.8M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>August 6, 2018    </td><td>2.1.8             </td><td>4.1 and up        </td><td>4.121452</td></tr>\n",
              "\t<tr><td>HTC Sense Input - FR                         </td><td>TOOLS              </td><td>4.0</td><td>885   </td><td>8.0M              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Tools                  </td><td>October 30, 2015  </td><td>1.0.612928        </td><td>5.0 and up        </td><td>4.000000</td></tr>\n",
              "\t<tr><td>Gold Quote - Gold.fr                         </td><td>FINANCE            </td><td>NaN</td><td>96    </td><td>1.5M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Finance                </td><td>May 19, 2016      </td><td>2.3               </td><td>2.2 and up        </td><td>4.131889</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Fanfic-FR                                    </span></td><td>BOOKS_AND_REFERENCE</td><td>3.3</td><td><span style=white-space:pre-wrap>52    </span></td><td><span style=white-space:pre-wrap>3.6M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>August 5, 2017    </span></td><td><span style=white-space:pre-wrap>0.3.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td><td>3.300000</td></tr>\n",
              "\t<tr><td>Fr. Daoud Lamei                              </td><td>FAMILY             </td><td>5.0</td><td>22    </td><td>8.6M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Teen      </td><td>Education              </td><td>June 27, 2018     </td><td>3.8.0             </td><td>4.1 and up        </td><td>5.000000</td></tr>\n",
              "\t<tr><td>Poop FR                                      </td><td>FAMILY             </td><td>NaN</td><td>6     </td><td>2.5M              </td><td>50+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Entertainment          </td><td>May 29, 2018      </td><td>1.0               </td><td>4.0.3 and up      </td><td>4.192272</td></tr>\n",
              "\t<tr><td>PLMGSS FR                                    </td><td>PRODUCTIVITY       </td><td>NaN</td><td>0     </td><td>3.1M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Productivity           </td><td>December 1, 2017  </td><td>1                 </td><td>4.4 and up        </td><td>4.211396</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>List iptv FR                                 </span></td><td><span style=white-space:pre-wrap>VIDEO_PLAYERS      </span></td><td>NaN</td><td><span style=white-space:pre-wrap>1     </span></td><td><span style=white-space:pre-wrap>2.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td>Video Players &amp; Editors</td><td><span style=white-space:pre-wrap>April 22, 2018    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0.3 and up      </span></td><td>4.063750</td></tr>\n",
              "\t<tr><td>Cardio-FR                                    </td><td>MEDICAL            </td><td>NaN</td><td>67    </td><td>82M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>July 31, 2018     </td><td>2.2.2             </td><td>4.4 and up        </td><td>4.189143</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Naruto &amp; Boruto FR                           </span></td><td><span style=white-space:pre-wrap>SOCIAL             </span></td><td>NaN</td><td><span style=white-space:pre-wrap>7     </span></td><td><span style=white-space:pre-wrap>7.7M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Social                 </span></td><td><span style=white-space:pre-wrap>February 2, 2018  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td><td>4.255598</td></tr>\n",
              "\t<tr><td>Frim: get new friends on local chat rooms    </td><td>SOCIAL             </td><td>4.0</td><td>88486 </td><td>Varies with device</td><td>5,000,000+ </td><td>Free</td><td>0</td><td>Mature 17+</td><td>Social                 </td><td>March 23, 2018    </td><td>Varies with device</td><td>Varies with device</td><td>4.000000</td></tr>\n",
              "\t<tr><td>Fr Agnel Ambarnath                           </td><td>FAMILY             </td><td>4.2</td><td>117   </td><td>13M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td><td>4.200000</td></tr>\n",
              "\t<tr><td>Manga-FR - Anime Vostfr                      </td><td>COMICS             </td><td>3.4</td><td>291   </td><td>13M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Comics                 </td><td>May 15, 2017      </td><td>2.0.1             </td><td>4.0 and up        </td><td>3.400000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Bulgarian French Dictionary Fr               </span></td><td>BOOKS_AND_REFERENCE</td><td>4.6</td><td><span style=white-space:pre-wrap>603   </span></td><td><span style=white-space:pre-wrap>7.4M              </span></td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>June 19, 2016     </span></td><td><span style=white-space:pre-wrap>2.96              </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td><td>4.600000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>News Minecraft.fr                            </span></td><td>NEWS_AND_MAGAZINES </td><td>3.8</td><td><span style=white-space:pre-wrap>881   </span></td><td><span style=white-space:pre-wrap>2.3M              </span></td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>News &amp; Magazines       </span></td><td><span style=white-space:pre-wrap>January 20, 2014  </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>1.6 and up        </span></td><td>3.800000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>payermonstationnement.fr                     </span></td><td>MAPS_AND_NAVIGATION</td><td>NaN</td><td><span style=white-space:pre-wrap>38    </span></td><td><span style=white-space:pre-wrap>9.8M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Maps &amp; Navigation      </span></td><td><span style=white-space:pre-wrap>June 13, 2018     </span></td><td><span style=white-space:pre-wrap>2.0.148.0         </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td><td>4.051613</td></tr>\n",
              "\t<tr><td>FR Tides                                     </td><td>WEATHER            </td><td>3.8</td><td>1195  </td><td>582k              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Weather                </td><td>February 16, 2014 </td><td>6.0               </td><td>2.1 and up        </td><td>3.800000</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Chemin (fr)                                  </span></td><td>BOOKS_AND_REFERENCE</td><td>4.8</td><td><span style=white-space:pre-wrap>44    </span></td><td><span style=white-space:pre-wrap>619k              </span></td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>March 23, 2014    </span></td><td><span style=white-space:pre-wrap>0.8               </span></td><td><span style=white-space:pre-wrap>2.2 and up        </span></td><td>4.800000</td></tr>\n",
              "\t<tr><td>FR Calculator                                </td><td>FAMILY             </td><td>4.0</td><td>7     </td><td>2.6M              </td><td>500+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 18, 2017     </td><td>1.0.0             </td><td>4.1 and up        </td><td>4.000000</td></tr>\n",
              "\t<tr><td>FR Forms                                     </td><td>BUSINESS           </td><td>NaN</td><td>0     </td><td>9.6M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>September 29, 2016</td><td>1.1.5             </td><td>4.0 and up        </td><td>4.121452</td></tr>\n",
              "\t<tr><td>Sya9a Maroc - FR                             </td><td>FAMILY             </td><td>4.5</td><td>38    </td><td>53M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 25, 2017     </td><td>1.48              </td><td>4.1 and up        </td><td>4.500000</td></tr>\n",
              "\t<tr><td>Fr. Mike Schmitz Audio Teachings             </td><td>FAMILY             </td><td>5.0</td><td>4     </td><td>3.6M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 6, 2018      </td><td>1.0               </td><td>4.1 and up        </td><td>5.000000</td></tr>\n",
              "\t<tr><td>Parkinson Exercices FR                       </td><td>MEDICAL            </td><td>NaN</td><td>3     </td><td>9.5M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>January 20, 2017  </td><td>1.0               </td><td>2.2 and up        </td><td>4.189143</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>The SCP Foundation DB fr nn5n                </span></td><td>BOOKS_AND_REFERENCE</td><td>4.5</td><td><span style=white-space:pre-wrap>114   </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td>Mature 17+</td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>January 19, 2015  </span></td><td>Varies with device</td><td>Varies with device</td><td>4.500000</td></tr>\n",
              "\t<tr><td>iHoroscope - 2018 Daily Horoscope &amp; Astrology</td><td><span style=white-space:pre-wrap>LIFESTYLE          </span></td><td>4.5</td><td>398307</td><td><span style=white-space:pre-wrap>19M               </span></td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Lifestyle              </span></td><td><span style=white-space:pre-wrap>July 25, 2018     </span></td><td>Varies with device</td><td>Varies with device</td><td>4.500000</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 10840 × 14\n\n| App &lt;chr&gt; | Category &lt;chr&gt; | Rating &lt;dbl&gt; | Reviews &lt;chr&gt; | Size &lt;chr&gt; | Installs &lt;chr&gt; | Type &lt;chr&gt; | Price &lt;chr&gt; | Content.Rating &lt;chr&gt; | Genres &lt;chr&gt; | Last.Updated &lt;chr&gt; | Current.Ver &lt;chr&gt; | Android.Ver &lt;chr&gt; | newRating &lt;dbl&gt; |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n| Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook     | ART_AND_DESIGN | 4.1 | 159    | 19M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | January 7, 2018    | 1.0.0              | 4.0.3 and up | 4.100000 |\n| Coloring book moana                                | ART_AND_DESIGN | 3.9 | 967    | 14M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Pretend Play       | January 15, 2018   | 2.0.0              | 4.0.3 and up | 3.900000 |\n| U Launcher Lite – FREE Live Cool Themes, Hide Apps | ART_AND_DESIGN | 4.7 | 87510  | 8.7M | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 1, 2018     | 1.2.4              | 4.0.3 and up | 4.700000 |\n| Sketch - Draw &amp; Paint                              | ART_AND_DESIGN | 4.5 | 215644 | 25M  | 50,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | June 8, 2018       | Varies with device | 4.2 and up   | 4.500000 |\n| Pixel Draw - Number Art Coloring Book              | ART_AND_DESIGN | 4.3 | 967    | 2.8M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | June 20, 2018      | 1.1                | 4.4 and up   | 4.300000 |\n| Paper flowers instructions                         | ART_AND_DESIGN | 4.4 | 167    | 5.6M | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | March 26, 2017     | 1.0                | 2.3 and up   | 4.400000 |\n| Smoke Effect Photo Maker - Smoke Editor            | ART_AND_DESIGN | 3.8 | 178    | 19M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 26, 2018     | 1.1                | 4.0.3 and up | 3.800000 |\n| Infinite Painter                                   | ART_AND_DESIGN | 4.1 | 36815  | 29M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | June 14, 2018      | 6.1.61.1           | 4.2 and up   | 4.100000 |\n| Garden Coloring Book                               | ART_AND_DESIGN | 4.4 | 13791  | 33M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | September 20, 2017 | 2.9.2              | 3.0 and up   | 4.400000 |\n| Kids Paint Free - Drawing Fun                      | ART_AND_DESIGN | 4.7 | 121    | 3.1M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design;Creativity         | July 3, 2018       | 2.8                | 4.0.3 and up | 4.700000 |\n| Text on Photo - Fonteee                            | ART_AND_DESIGN | 4.4 | 13880  | 28M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | October 27, 2017   | 1.0.4              | 4.1 and up   | 4.400000 |\n| Name Art Photo Editor - Focus n Filters            | ART_AND_DESIGN | 4.4 | 8788   | 12M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 1.0.15             | 4.0 and up   | 4.400000 |\n| Tattoo Name On My Photo Editor                     | ART_AND_DESIGN | 4.2 | 44829  | 20M  | 10,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | April 2, 2018      | 3.8                | 4.1 and up   | 4.200000 |\n| Mandala Coloring Book                              | ART_AND_DESIGN | 4.6 | 4326   | 21M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | June 26, 2018      | 1.0.4              | 4.4 and up   | 4.600000 |\n| 3D Color Pixel by Number - Sandbox Art Coloring    | ART_AND_DESIGN | 4.4 | 1518   | 37M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 1.2.3              | 2.3 and up   | 4.400000 |\n| Learn To Draw Kawaii Characters                    | ART_AND_DESIGN | 3.2 | 55     | 2.7M | 5,000+      | Free | 0 | Everyone     | Art &amp; Design                    | June 6, 2018       | NaN                | 4.2 and up   | 3.200000 |\n| Photo Designer - Write your name with shapes       | ART_AND_DESIGN | 4.7 | 3632   | 5.5M | 500,000+    | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 3.1                | 4.1 and up   | 4.700000 |\n| 350 Diy Room Decor Ideas                           | ART_AND_DESIGN | 4.5 | 27     | 17M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | November 7, 2017   | 1.0                | 2.3 and up   | 4.500000 |\n| FlipaClip - Cartoon animation                      | ART_AND_DESIGN | 4.3 | 194216 | 39M  | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 2.2.5              | 4.0.3 and up | 4.300000 |\n| ibis Paint X                                       | ART_AND_DESIGN | 4.6 | 224399 | 31M  | 10,000,000+ | Free | 0 | Everyone     | Art &amp; Design                    | July 30, 2018      | 5.5.4              | 4.1 and up   | 4.600000 |\n| Logo Maker - Small Business                        | ART_AND_DESIGN | 4.0 | 450    | 14M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | April 20, 2018     | 4.0                | 4.1 and up   | 4.000000 |\n| Boys Photo Editor - Six Pack &amp; Men's Suit          | ART_AND_DESIGN | 4.1 | 654    | 12M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 20, 2018     | 1.1                | 4.0.3 and up | 4.100000 |\n| Superheroes Wallpapers | 4K Backgrounds            | ART_AND_DESIGN | 4.7 | 7699   | 4.2M | 500,000+    | Free | 0 | Everyone 10+ | Art &amp; Design                    | July 12, 2018      | 2.2.6.2            | 4.0.3 and up | 4.700000 |\n| Mcqueen Coloring pages                             | ART_AND_DESIGN | NaN | 61     | 7.0M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Action &amp; Adventure | March 7, 2018      | 1.0.0              | 4.1 and up   | 4.358065 |\n| HD Mickey Minnie Wallpapers                        | ART_AND_DESIGN | 4.7 | 118    | 23M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 7, 2018       | 1.1.3              | 4.1 and up   | 4.700000 |\n| Harley Quinn wallpapers HD                         | ART_AND_DESIGN | 4.8 | 192    | 6.0M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 25, 2018     | 1.5                | 3.0 and up   | 4.800000 |\n| Colorfit - Drawing &amp; Coloring                      | ART_AND_DESIGN | 4.7 | 20260  | 25M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | October 11, 2017   | 1.0.8              | 4.0.3 and up | 4.700000 |\n| Animated Photo Editor                              | ART_AND_DESIGN | 4.1 | 203    | 6.1M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 21, 2018     | 1.03               | 4.0.3 and up | 4.100000 |\n| Pencil Sketch Drawing                              | ART_AND_DESIGN | 3.9 | 136    | 4.6M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 12, 2018      | 6.0                | 2.3 and up   | 3.900000 |\n| Easy Realistic Drawing Tutorial                    | ART_AND_DESIGN | 4.1 | 223    | 4.2M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 22, 2017    | 1.0                | 2.3 and up   | 4.100000 |\n| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n| FR Plus 1.6                                   | AUTO_AND_VEHICLES   | NaN | 4      | 3.9M               | 100+        | Free | 0 | Everyone   | Auto &amp; Vehicles         | July 24, 2018      | 1.3.6              | 4.4W and up        | 4.190411 |\n| Fr Agnel Pune                                 | FAMILY              | 4.1 | 80     | 13M                | 1,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       | 4.100000 |\n| DICT.fr Mobile                                | BUSINESS            | NaN | 20     | 2.7M               | 10,000+     | Free | 0 | Everyone   | Business                | July 17, 2018      | 2.1.10             | 4.1 and up         | 4.121452 |\n| FR: My Secret Pets!                           | FAMILY              | 4.0 | 785    | 31M                | 50,000+     | Free | 0 | Teen       | Entertainment           | June 3, 2015       | 1.3.1              | 3.0 and up         | 4.000000 |\n| Golden Dictionary (FR-AR)                     | BOOKS_AND_REFERENCE | 4.2 | 5775   | 4.9M               | 500,000+    | Free | 0 | Everyone   | Books &amp; Reference       | July 19, 2018      | 7.0.4.6            | 4.2 and up         | 4.200000 |\n| FieldBi FR Offline                            | BUSINESS            | NaN | 2      | 6.8M               | 100+        | Free | 0 | Everyone   | Business                | August 6, 2018     | 2.1.8              | 4.1 and up         | 4.121452 |\n| HTC Sense Input - FR                          | TOOLS               | 4.0 | 885    | 8.0M               | 100,000+    | Free | 0 | Everyone   | Tools                   | October 30, 2015   | 1.0.612928         | 5.0 and up         | 4.000000 |\n| Gold Quote - Gold.fr                          | FINANCE             | NaN | 96     | 1.5M               | 10,000+     | Free | 0 | Everyone   | Finance                 | May 19, 2016       | 2.3                | 2.2 and up         | 4.131889 |\n| Fanfic-FR                                     | BOOKS_AND_REFERENCE | 3.3 | 52     | 3.6M               | 5,000+      | Free | 0 | Teen       | Books &amp; Reference       | August 5, 2017     | 0.3.4              | 4.1 and up         | 3.300000 |\n| Fr. Daoud Lamei                               | FAMILY              | 5.0 | 22     | 8.6M               | 1,000+      | Free | 0 | Teen       | Education               | June 27, 2018      | 3.8.0              | 4.1 and up         | 5.000000 |\n| Poop FR                                       | FAMILY              | NaN | 6      | 2.5M               | 50+         | Free | 0 | Everyone   | Entertainment           | May 29, 2018       | 1.0                | 4.0.3 and up       | 4.192272 |\n| PLMGSS FR                                     | PRODUCTIVITY        | NaN | 0      | 3.1M               | 10+         | Free | 0 | Everyone   | Productivity            | December 1, 2017   | 1                  | 4.4 and up         | 4.211396 |\n| List iptv FR                                  | VIDEO_PLAYERS       | NaN | 1      | 2.9M               | 100+        | Free | 0 | Everyone   | Video Players &amp; Editors | April 22, 2018     | 1.0                | 4.0.3 and up       | 4.063750 |\n| Cardio-FR                                     | MEDICAL             | NaN | 67     | 82M                | 10,000+     | Free | 0 | Everyone   | Medical                 | July 31, 2018      | 2.2.2              | 4.4 and up         | 4.189143 |\n| Naruto &amp; Boruto FR                            | SOCIAL              | NaN | 7      | 7.7M               | 100+        | Free | 0 | Teen       | Social                  | February 2, 2018   | 1.0                | 4.0 and up         | 4.255598 |\n| Frim: get new friends on local chat rooms     | SOCIAL              | 4.0 | 88486  | Varies with device | 5,000,000+  | Free | 0 | Mature 17+ | Social                  | March 23, 2018     | Varies with device | Varies with device | 4.000000 |\n| Fr Agnel Ambarnath                            | FAMILY              | 4.2 | 117    | 13M                | 5,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       | 4.200000 |\n| Manga-FR - Anime Vostfr                       | COMICS              | 3.4 | 291    | 13M                | 10,000+     | Free | 0 | Everyone   | Comics                  | May 15, 2017       | 2.0.1              | 4.0 and up         | 3.400000 |\n| Bulgarian French Dictionary Fr                | BOOKS_AND_REFERENCE | 4.6 | 603    | 7.4M               | 10,000+     | Free | 0 | Everyone   | Books &amp; Reference       | June 19, 2016      | 2.96               | 4.1 and up         | 4.600000 |\n| News Minecraft.fr                             | NEWS_AND_MAGAZINES  | 3.8 | 881    | 2.3M               | 100,000+    | Free | 0 | Everyone   | News &amp; Magazines        | January 20, 2014   | 1.5                | 1.6 and up         | 3.800000 |\n| payermonstationnement.fr                      | MAPS_AND_NAVIGATION | NaN | 38     | 9.8M               | 5,000+      | Free | 0 | Everyone   | Maps &amp; Navigation       | June 13, 2018      | 2.0.148.0          | 4.0 and up         | 4.051613 |\n| FR Tides                                      | WEATHER             | 3.8 | 1195   | 582k               | 100,000+    | Free | 0 | Everyone   | Weather                 | February 16, 2014  | 6.0                | 2.1 and up         | 3.800000 |\n| Chemin (fr)                                   | BOOKS_AND_REFERENCE | 4.8 | 44     | 619k               | 1,000+      | Free | 0 | Everyone   | Books &amp; Reference       | March 23, 2014     | 0.8                | 2.2 and up         | 4.800000 |\n| FR Calculator                                 | FAMILY              | 4.0 | 7      | 2.6M               | 500+        | Free | 0 | Everyone   | Education               | June 18, 2017      | 1.0.0              | 4.1 and up         | 4.000000 |\n| FR Forms                                      | BUSINESS            | NaN | 0      | 9.6M               | 10+         | Free | 0 | Everyone   | Business                | September 29, 2016 | 1.1.5              | 4.0 and up         | 4.121452 |\n| Sya9a Maroc - FR                              | FAMILY              | 4.5 | 38     | 53M                | 5,000+      | Free | 0 | Everyone   | Education               | July 25, 2017      | 1.48               | 4.1 and up         | 4.500000 |\n| Fr. Mike Schmitz Audio Teachings              | FAMILY              | 5.0 | 4      | 3.6M               | 100+        | Free | 0 | Everyone   | Education               | July 6, 2018       | 1.0                | 4.1 and up         | 5.000000 |\n| Parkinson Exercices FR                        | MEDICAL             | NaN | 3      | 9.5M               | 1,000+      | Free | 0 | Everyone   | Medical                 | January 20, 2017   | 1.0                | 2.2 and up         | 4.189143 |\n| The SCP Foundation DB fr nn5n                 | BOOKS_AND_REFERENCE | 4.5 | 114    | Varies with device | 1,000+      | Free | 0 | Mature 17+ | Books &amp; Reference       | January 19, 2015   | Varies with device | Varies with device | 4.500000 |\n| iHoroscope - 2018 Daily Horoscope &amp; Astrology | LIFESTYLE           | 4.5 | 398307 | 19M                | 10,000,000+ | Free | 0 | Everyone   | Lifestyle               | July 25, 2018      | Varies with device | Varies with device | 4.500000 |\n\n",
            "text/latex": "A data.frame: 10840 × 14\n\\begin{tabular}{llllllllllllll}\n App & Category & Rating & Reviews & Size & Installs & Type & Price & Content.Rating & Genres & Last.Updated & Current.Ver & Android.Ver & newRating\\\\\n <chr> & <chr> & <dbl> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <dbl>\\\\\n\\hline\n\t Photo Editor \\& Candy Camera \\& Grid \\& ScrapBook     & ART\\_AND\\_DESIGN & 4.1 & 159    & 19M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & January 7, 2018    & 1.0.0              & 4.0.3 and up & 4.100000\\\\\n\t Coloring book moana                                & ART\\_AND\\_DESIGN & 3.9 & 967    & 14M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Pretend Play       & January 15, 2018   & 2.0.0              & 4.0.3 and up & 3.900000\\\\\n\t U Launcher Lite – FREE Live Cool Themes, Hide Apps & ART\\_AND\\_DESIGN & 4.7 & 87510  & 8.7M & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 1, 2018     & 1.2.4              & 4.0.3 and up & 4.700000\\\\\n\t Sketch - Draw \\& Paint                              & ART\\_AND\\_DESIGN & 4.5 & 215644 & 25M  & 50,000,000+ & Free & 0 & Teen         & Art \\& Design                    & June 8, 2018       & Varies with device & 4.2 and up   & 4.500000\\\\\n\t Pixel Draw - Number Art Coloring Book              & ART\\_AND\\_DESIGN & 4.3 & 967    & 2.8M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & June 20, 2018      & 1.1                & 4.4 and up   & 4.300000\\\\\n\t Paper flowers instructions                         & ART\\_AND\\_DESIGN & 4.4 & 167    & 5.6M & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & March 26, 2017     & 1.0                & 2.3 and up   & 4.400000\\\\\n\t Smoke Effect Photo Maker - Smoke Editor            & ART\\_AND\\_DESIGN & 3.8 & 178    & 19M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 26, 2018     & 1.1                & 4.0.3 and up & 3.800000\\\\\n\t Infinite Painter                                   & ART\\_AND\\_DESIGN & 4.1 & 36815  & 29M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & June 14, 2018      & 6.1.61.1           & 4.2 and up   & 4.100000\\\\\n\t Garden Coloring Book                               & ART\\_AND\\_DESIGN & 4.4 & 13791  & 33M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & September 20, 2017 & 2.9.2              & 3.0 and up   & 4.400000\\\\\n\t Kids Paint Free - Drawing Fun                      & ART\\_AND\\_DESIGN & 4.7 & 121    & 3.1M & 10,000+     & Free & 0 & Everyone     & Art \\& Design;Creativity         & July 3, 2018       & 2.8                & 4.0.3 and up & 4.700000\\\\\n\t Text on Photo - Fonteee                            & ART\\_AND\\_DESIGN & 4.4 & 13880  & 28M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & October 27, 2017   & 1.0.4              & 4.1 and up   & 4.400000\\\\\n\t Name Art Photo Editor - Focus n Filters            & ART\\_AND\\_DESIGN & 4.4 & 8788   & 12M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 1.0.15             & 4.0 and up   & 4.400000\\\\\n\t Tattoo Name On My Photo Editor                     & ART\\_AND\\_DESIGN & 4.2 & 44829  & 20M  & 10,000,000+ & Free & 0 & Teen         & Art \\& Design                    & April 2, 2018      & 3.8                & 4.1 and up   & 4.200000\\\\\n\t Mandala Coloring Book                              & ART\\_AND\\_DESIGN & 4.6 & 4326   & 21M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & June 26, 2018      & 1.0.4              & 4.4 and up   & 4.600000\\\\\n\t 3D Color Pixel by Number - Sandbox Art Coloring    & ART\\_AND\\_DESIGN & 4.4 & 1518   & 37M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 1.2.3              & 2.3 and up   & 4.400000\\\\\n\t Learn To Draw Kawaii Characters                    & ART\\_AND\\_DESIGN & 3.2 & 55     & 2.7M & 5,000+      & Free & 0 & Everyone     & Art \\& Design                    & June 6, 2018       & NaN                & 4.2 and up   & 3.200000\\\\\n\t Photo Designer - Write your name with shapes       & ART\\_AND\\_DESIGN & 4.7 & 3632   & 5.5M & 500,000+    & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 3.1                & 4.1 and up   & 4.700000\\\\\n\t 350 Diy Room Decor Ideas                           & ART\\_AND\\_DESIGN & 4.5 & 27     & 17M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & November 7, 2017   & 1.0                & 2.3 and up   & 4.500000\\\\\n\t FlipaClip - Cartoon animation                      & ART\\_AND\\_DESIGN & 4.3 & 194216 & 39M  & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 2.2.5              & 4.0.3 and up & 4.300000\\\\\n\t ibis Paint X                                       & ART\\_AND\\_DESIGN & 4.6 & 224399 & 31M  & 10,000,000+ & Free & 0 & Everyone     & Art \\& Design                    & July 30, 2018      & 5.5.4              & 4.1 and up   & 4.600000\\\\\n\t Logo Maker - Small Business                        & ART\\_AND\\_DESIGN & 4.0 & 450    & 14M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & April 20, 2018     & 4.0                & 4.1 and up   & 4.000000\\\\\n\t Boys Photo Editor - Six Pack \\& Men's Suit          & ART\\_AND\\_DESIGN & 4.1 & 654    & 12M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 20, 2018     & 1.1                & 4.0.3 and up & 4.100000\\\\\n\t Superheroes Wallpapers \\textbar{} 4K Backgrounds            & ART\\_AND\\_DESIGN & 4.7 & 7699   & 4.2M & 500,000+    & Free & 0 & Everyone 10+ & Art \\& Design                    & July 12, 2018      & 2.2.6.2            & 4.0.3 and up & 4.700000\\\\\n\t Mcqueen Coloring pages                             & ART\\_AND\\_DESIGN & NaN & 61     & 7.0M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Action \\& Adventure & March 7, 2018      & 1.0.0              & 4.1 and up   & 4.358065\\\\\n\t HD Mickey Minnie Wallpapers                        & ART\\_AND\\_DESIGN & 4.7 & 118    & 23M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 7, 2018       & 1.1.3              & 4.1 and up   & 4.700000\\\\\n\t Harley Quinn wallpapers HD                         & ART\\_AND\\_DESIGN & 4.8 & 192    & 6.0M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 25, 2018     & 1.5                & 3.0 and up   & 4.800000\\\\\n\t Colorfit - Drawing \\& Coloring                      & ART\\_AND\\_DESIGN & 4.7 & 20260  & 25M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & October 11, 2017   & 1.0.8              & 4.0.3 and up & 4.700000\\\\\n\t Animated Photo Editor                              & ART\\_AND\\_DESIGN & 4.1 & 203    & 6.1M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 21, 2018     & 1.03               & 4.0.3 and up & 4.100000\\\\\n\t Pencil Sketch Drawing                              & ART\\_AND\\_DESIGN & 3.9 & 136    & 4.6M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 12, 2018      & 6.0                & 2.3 and up   & 3.900000\\\\\n\t Easy Realistic Drawing Tutorial                    & ART\\_AND\\_DESIGN & 4.1 & 223    & 4.2M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 22, 2017    & 1.0                & 2.3 and up   & 4.100000\\\\\n\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n\t FR Plus 1.6                                   & AUTO\\_AND\\_VEHICLES   & NaN & 4      & 3.9M               & 100+        & Free & 0 & Everyone   & Auto \\& Vehicles         & July 24, 2018      & 1.3.6              & 4.4W and up        & 4.190411\\\\\n\t Fr Agnel Pune                                 & FAMILY              & 4.1 & 80     & 13M                & 1,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up       & 4.100000\\\\\n\t DICT.fr Mobile                                & BUSINESS            & NaN & 20     & 2.7M               & 10,000+     & Free & 0 & Everyone   & Business                & July 17, 2018      & 2.1.10             & 4.1 and up         & 4.121452\\\\\n\t FR: My Secret Pets!                           & FAMILY              & 4.0 & 785    & 31M                & 50,000+     & Free & 0 & Teen       & Entertainment           & June 3, 2015       & 1.3.1              & 3.0 and up         & 4.000000\\\\\n\t Golden Dictionary (FR-AR)                     & BOOKS\\_AND\\_REFERENCE & 4.2 & 5775   & 4.9M               & 500,000+    & Free & 0 & Everyone   & Books \\& Reference       & July 19, 2018      & 7.0.4.6            & 4.2 and up         & 4.200000\\\\\n\t FieldBi FR Offline                            & BUSINESS            & NaN & 2      & 6.8M               & 100+        & Free & 0 & Everyone   & Business                & August 6, 2018     & 2.1.8              & 4.1 and up         & 4.121452\\\\\n\t HTC Sense Input - FR                          & TOOLS               & 4.0 & 885    & 8.0M               & 100,000+    & Free & 0 & Everyone   & Tools                   & October 30, 2015   & 1.0.612928         & 5.0 and up         & 4.000000\\\\\n\t Gold Quote - Gold.fr                          & FINANCE             & NaN & 96     & 1.5M               & 10,000+     & Free & 0 & Everyone   & Finance                 & May 19, 2016       & 2.3                & 2.2 and up         & 4.131889\\\\\n\t Fanfic-FR                                     & BOOKS\\_AND\\_REFERENCE & 3.3 & 52     & 3.6M               & 5,000+      & Free & 0 & Teen       & Books \\& Reference       & August 5, 2017     & 0.3.4              & 4.1 and up         & 3.300000\\\\\n\t Fr. Daoud Lamei                               & FAMILY              & 5.0 & 22     & 8.6M               & 1,000+      & Free & 0 & Teen       & Education               & June 27, 2018      & 3.8.0              & 4.1 and up         & 5.000000\\\\\n\t Poop FR                                       & FAMILY              & NaN & 6      & 2.5M               & 50+         & Free & 0 & Everyone   & Entertainment           & May 29, 2018       & 1.0                & 4.0.3 and up       & 4.192272\\\\\n\t PLMGSS FR                                     & PRODUCTIVITY        & NaN & 0      & 3.1M               & 10+         & Free & 0 & Everyone   & Productivity            & December 1, 2017   & 1                  & 4.4 and up         & 4.211396\\\\\n\t List iptv FR                                  & VIDEO\\_PLAYERS       & NaN & 1      & 2.9M               & 100+        & Free & 0 & Everyone   & Video Players \\& Editors & April 22, 2018     & 1.0                & 4.0.3 and up       & 4.063750\\\\\n\t Cardio-FR                                     & MEDICAL             & NaN & 67     & 82M                & 10,000+     & Free & 0 & Everyone   & Medical                 & July 31, 2018      & 2.2.2              & 4.4 and up         & 4.189143\\\\\n\t Naruto \\& Boruto FR                            & SOCIAL              & NaN & 7      & 7.7M               & 100+        & Free & 0 & Teen       & Social                  & February 2, 2018   & 1.0                & 4.0 and up         & 4.255598\\\\\n\t Frim: get new friends on local chat rooms     & SOCIAL              & 4.0 & 88486  & Varies with device & 5,000,000+  & Free & 0 & Mature 17+ & Social                  & March 23, 2018     & Varies with device & Varies with device & 4.000000\\\\\n\t Fr Agnel Ambarnath                            & FAMILY              & 4.2 & 117    & 13M                & 5,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up       & 4.200000\\\\\n\t Manga-FR - Anime Vostfr                       & COMICS              & 3.4 & 291    & 13M                & 10,000+     & Free & 0 & Everyone   & Comics                  & May 15, 2017       & 2.0.1              & 4.0 and up         & 3.400000\\\\\n\t Bulgarian French Dictionary Fr                & BOOKS\\_AND\\_REFERENCE & 4.6 & 603    & 7.4M               & 10,000+     & Free & 0 & Everyone   & Books \\& Reference       & June 19, 2016      & 2.96               & 4.1 and up         & 4.600000\\\\\n\t News Minecraft.fr                             & NEWS\\_AND\\_MAGAZINES  & 3.8 & 881    & 2.3M               & 100,000+    & Free & 0 & Everyone   & News \\& Magazines        & January 20, 2014   & 1.5                & 1.6 and up         & 3.800000\\\\\n\t payermonstationnement.fr                      & MAPS\\_AND\\_NAVIGATION & NaN & 38     & 9.8M               & 5,000+      & Free & 0 & Everyone   & Maps \\& Navigation       & June 13, 2018      & 2.0.148.0          & 4.0 and up         & 4.051613\\\\\n\t FR Tides                                      & WEATHER             & 3.8 & 1195   & 582k               & 100,000+    & Free & 0 & Everyone   & Weather                 & February 16, 2014  & 6.0                & 2.1 and up         & 3.800000\\\\\n\t Chemin (fr)                                   & BOOKS\\_AND\\_REFERENCE & 4.8 & 44     & 619k               & 1,000+      & Free & 0 & Everyone   & Books \\& Reference       & March 23, 2014     & 0.8                & 2.2 and up         & 4.800000\\\\\n\t FR Calculator                                 & FAMILY              & 4.0 & 7      & 2.6M               & 500+        & Free & 0 & Everyone   & Education               & June 18, 2017      & 1.0.0              & 4.1 and up         & 4.000000\\\\\n\t FR Forms                                      & BUSINESS            & NaN & 0      & 9.6M               & 10+         & Free & 0 & Everyone   & Business                & September 29, 2016 & 1.1.5              & 4.0 and up         & 4.121452\\\\\n\t Sya9a Maroc - FR                              & FAMILY              & 4.5 & 38     & 53M                & 5,000+      & Free & 0 & Everyone   & Education               & July 25, 2017      & 1.48               & 4.1 and up         & 4.500000\\\\\n\t Fr. Mike Schmitz Audio Teachings              & FAMILY              & 5.0 & 4      & 3.6M               & 100+        & Free & 0 & Everyone   & Education               & July 6, 2018       & 1.0                & 4.1 and up         & 5.000000\\\\\n\t Parkinson Exercices FR                        & MEDICAL             & NaN & 3      & 9.5M               & 1,000+      & Free & 0 & Everyone   & Medical                 & January 20, 2017   & 1.0                & 2.2 and up         & 4.189143\\\\\n\t The SCP Foundation DB fr nn5n                 & BOOKS\\_AND\\_REFERENCE & 4.5 & 114    & Varies with device & 1,000+      & Free & 0 & Mature 17+ & Books \\& Reference       & January 19, 2015   & Varies with device & Varies with device & 4.500000\\\\\n\t iHoroscope - 2018 Daily Horoscope \\& Astrology & LIFESTYLE           & 4.5 & 398307 & 19M                & 10,000,000+ & Free & 0 & Everyone   & Lifestyle               & July 25, 2018      & Varies with device & Varies with device & 4.500000\\\\\n\\end{tabular}\n"
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "summary(dados_2$newRating)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.207788Z",
          "iopub.execute_input": "2024-04-14T16:57:27.209346Z",
          "iopub.status.idle": "2024-04-14T16:57:27.228988Z"
        },
        "trusted": true,
        "id": "sUBvueM0k-jd",
        "outputId": "436af7cb-c7a0-4f38-a84a-a0bbf7975ed0",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 52
        }
      },
      "execution_count": 27,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n",
              "  1.000   4.047   4.260   4.190   4.500   5.000 "
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2 <-dados_2 %>% mutate(rating_class = if_else(newRating < 2,  \"ruim\", if_else(newRating > 4, \"bom\", \"regular\")))"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.232304Z",
          "iopub.execute_input": "2024-04-14T16:57:27.233823Z",
          "iopub.status.idle": "2024-04-14T16:57:27.250961Z"
        },
        "trusted": true,
        "id": "tL_dtLLJk-je"
      },
      "execution_count": 28,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.2538Z",
          "iopub.execute_input": "2024-04-14T16:57:27.255321Z",
          "iopub.status.idle": "2024-04-14T16:57:27.420588Z"
        },
        "trusted": true,
        "id": "xGd9OXcPk-je",
        "outputId": "47ff7207-c857-466b-c64b-edba6fd55c01",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 29,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 10840 × 15</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>App</th><th scope=col>Category</th><th scope=col>Rating</th><th scope=col>Reviews</th><th scope=col>Size</th><th scope=col>Installs</th><th scope=col>Type</th><th scope=col>Price</th><th scope=col>Content.Rating</th><th scope=col>Genres</th><th scope=col>Last.Updated</th><th scope=col>Current.Ver</th><th scope=col>Android.Ver</th><th scope=col>newRating</th><th scope=col>rating_class</th></tr>\n",
              "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook    </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>159   </span></td><td>19M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>January 7, 2018   </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td>4.0.3 and up</td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Coloring book moana                               </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>967   </span></td><td>14M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Pretend Play      </span></td><td><span style=white-space:pre-wrap>January 15, 2018  </span></td><td><span style=white-space:pre-wrap>2.0.0             </span></td><td>4.0.3 and up</td><td>3.900000</td><td>regular</td></tr>\n",
              "\t<tr><td>U Launcher Lite – FREE Live Cool Themes, Hide Apps</td><td>ART_AND_DESIGN</td><td>4.7</td><td>87510 </td><td>8.7M</td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 1, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.4             </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Sketch - Draw &amp; Paint                             </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td>215644</td><td>25M </td><td>50,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 8, 2018      </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pixel Draw - Number Art Coloring Book             </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td><span style=white-space:pre-wrap>967   </span></td><td>2.8M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>June 20, 2018     </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td><td>4.300000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Paper flowers instructions                        </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>167   </span></td><td>5.6M</td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 26, 2017    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Smoke Effect Photo Maker - Smoke Editor           </span></td><td>ART_AND_DESIGN</td><td>3.8</td><td><span style=white-space:pre-wrap>178   </span></td><td>19M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 26, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td><td>3.800000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Infinite Painter                                  </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td>36815 </td><td>29M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 14, 2018     </span></td><td><span style=white-space:pre-wrap>6.1.61.1          </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Garden Coloring Book                              </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13791 </td><td>33M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td>September 20, 2017</td><td><span style=white-space:pre-wrap>2.9.2             </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Kids Paint Free - Drawing Fun                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>121   </span></td><td>3.1M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>July 3, 2018      </span></td><td><span style=white-space:pre-wrap>2.8               </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Text on Photo - Fonteee                           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13880 </td><td>28M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>October 27, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Name Art Photo Editor - Focus n Filters           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>8788  </span></td><td>12M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.15            </span></td><td><span style=white-space:pre-wrap>4.0 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Tattoo Name On My Photo Editor                    </span></td><td>ART_AND_DESIGN</td><td>4.2</td><td>44829 </td><td>20M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 2, 2018     </span></td><td><span style=white-space:pre-wrap>3.8               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.200000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mandala Coloring Book                             </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td><span style=white-space:pre-wrap>4326  </span></td><td>21M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 26, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td><td>4.600000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>3D Color Pixel by Number - Sandbox Art Coloring   </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>1518  </span></td><td>37M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.3             </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Learn To Draw Kawaii Characters                   </span></td><td>ART_AND_DESIGN</td><td>3.2</td><td><span style=white-space:pre-wrap>55    </span></td><td>2.7M</td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 6, 2018      </span></td><td><span style=white-space:pre-wrap>NaN               </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>3.200000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Designer - Write your name with shapes      </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>3632  </span></td><td>5.5M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>3.1               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>350 Diy Room Decor Ideas                          </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td><span style=white-space:pre-wrap>27    </span></td><td>17M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>November 7, 2017  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FlipaClip - Cartoon animation                     </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td>194216</td><td>39M </td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>2.2.5             </span></td><td>4.0.3 and up</td><td>4.300000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>ibis Paint X                                      </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td>224399</td><td>31M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 30, 2018     </span></td><td><span style=white-space:pre-wrap>5.5.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.600000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Logo Maker - Small Business                       </span></td><td>ART_AND_DESIGN</td><td>4.0</td><td><span style=white-space:pre-wrap>450   </span></td><td>14M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 20, 2018    </span></td><td><span style=white-space:pre-wrap>4.0               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.000000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Boys Photo Editor - Six Pack &amp; Men's Suit         </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>654   </span></td><td>12M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 20, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Superheroes Wallpapers | 4K Backgrounds           </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>7699  </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td>Everyone 10+</td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>2.2.6.2           </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mcqueen Coloring pages                            </span></td><td>ART_AND_DESIGN</td><td>NaN</td><td><span style=white-space:pre-wrap>61    </span></td><td>7.0M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td>Art &amp; Design;Action &amp; Adventure</td><td><span style=white-space:pre-wrap>March 7, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.358065</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>HD Mickey Minnie Wallpapers                       </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>118   </span></td><td>23M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 7, 2018      </span></td><td><span style=white-space:pre-wrap>1.1.3             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Harley Quinn wallpapers HD                        </span></td><td>ART_AND_DESIGN</td><td>4.8</td><td><span style=white-space:pre-wrap>192   </span></td><td>6.0M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 25, 2018    </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td><td>4.800000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Colorfit - Drawing &amp; Coloring                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td>20260 </td><td>25M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>October 11, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.8             </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Animated Photo Editor                             </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>203   </span></td><td>6.1M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 21, 2018    </span></td><td><span style=white-space:pre-wrap>1.03              </span></td><td>4.0.3 and up</td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pencil Sketch Drawing                             </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>136   </span></td><td>4.6M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>6.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>3.900000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Easy Realistic Drawing Tutorial                   </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>223   </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 22, 2017   </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FR Plus 1.6                                  </span></td><td><span style=white-space:pre-wrap>AUTO_AND_VEHICLES  </span></td><td>NaN</td><td><span style=white-space:pre-wrap>4     </span></td><td><span style=white-space:pre-wrap>3.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Auto &amp; Vehicles        </span></td><td><span style=white-space:pre-wrap>July 24, 2018     </span></td><td><span style=white-space:pre-wrap>1.3.6             </span></td><td><span style=white-space:pre-wrap>4.4W and up       </span></td><td>4.190411</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>Fr Agnel Pune                                </td><td>FAMILY             </td><td>4.1</td><td>80    </td><td>13M               </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td><td>4.100000</td><td>bom    </td></tr>\n",
              "\t<tr><td>DICT.fr Mobile                               </td><td>BUSINESS           </td><td>NaN</td><td>20    </td><td>2.7M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>July 17, 2018     </td><td>2.1.10            </td><td>4.1 and up        </td><td>4.121452</td><td>bom    </td></tr>\n",
              "\t<tr><td>FR: My Secret Pets!                          </td><td>FAMILY             </td><td>4.0</td><td>785   </td><td>31M               </td><td>50,000+    </td><td>Free</td><td>0</td><td>Teen      </td><td>Entertainment          </td><td>June 3, 2015      </td><td>1.3.1             </td><td>3.0 and up        </td><td>4.000000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Golden Dictionary (FR-AR)                    </span></td><td>BOOKS_AND_REFERENCE</td><td>4.2</td><td><span style=white-space:pre-wrap>5775  </span></td><td><span style=white-space:pre-wrap>4.9M              </span></td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>July 19, 2018     </span></td><td><span style=white-space:pre-wrap>7.0.4.6           </span></td><td><span style=white-space:pre-wrap>4.2 and up        </span></td><td>4.200000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>FieldBi FR Offline                           </td><td>BUSINESS           </td><td>NaN</td><td>2     </td><td>6.8M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>August 6, 2018    </td><td>2.1.8             </td><td>4.1 and up        </td><td>4.121452</td><td>bom    </td></tr>\n",
              "\t<tr><td>HTC Sense Input - FR                         </td><td>TOOLS              </td><td>4.0</td><td>885   </td><td>8.0M              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Tools                  </td><td>October 30, 2015  </td><td>1.0.612928        </td><td>5.0 and up        </td><td>4.000000</td><td>regular</td></tr>\n",
              "\t<tr><td>Gold Quote - Gold.fr                         </td><td>FINANCE            </td><td>NaN</td><td>96    </td><td>1.5M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Finance                </td><td>May 19, 2016      </td><td>2.3               </td><td>2.2 and up        </td><td>4.131889</td><td>bom    </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Fanfic-FR                                    </span></td><td>BOOKS_AND_REFERENCE</td><td>3.3</td><td><span style=white-space:pre-wrap>52    </span></td><td><span style=white-space:pre-wrap>3.6M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>August 5, 2017    </span></td><td><span style=white-space:pre-wrap>0.3.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td><td>3.300000</td><td>regular</td></tr>\n",
              "\t<tr><td>Fr. Daoud Lamei                              </td><td>FAMILY             </td><td>5.0</td><td>22    </td><td>8.6M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Teen      </td><td>Education              </td><td>June 27, 2018     </td><td>3.8.0             </td><td>4.1 and up        </td><td>5.000000</td><td>bom    </td></tr>\n",
              "\t<tr><td>Poop FR                                      </td><td>FAMILY             </td><td>NaN</td><td>6     </td><td>2.5M              </td><td>50+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Entertainment          </td><td>May 29, 2018      </td><td>1.0               </td><td>4.0.3 and up      </td><td>4.192272</td><td>bom    </td></tr>\n",
              "\t<tr><td>PLMGSS FR                                    </td><td>PRODUCTIVITY       </td><td>NaN</td><td>0     </td><td>3.1M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Productivity           </td><td>December 1, 2017  </td><td>1                 </td><td>4.4 and up        </td><td>4.211396</td><td>bom    </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>List iptv FR                                 </span></td><td><span style=white-space:pre-wrap>VIDEO_PLAYERS      </span></td><td>NaN</td><td><span style=white-space:pre-wrap>1     </span></td><td><span style=white-space:pre-wrap>2.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td>Video Players &amp; Editors</td><td><span style=white-space:pre-wrap>April 22, 2018    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0.3 and up      </span></td><td>4.063750</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>Cardio-FR                                    </td><td>MEDICAL            </td><td>NaN</td><td>67    </td><td>82M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>July 31, 2018     </td><td>2.2.2             </td><td>4.4 and up        </td><td>4.189143</td><td>bom    </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Naruto &amp; Boruto FR                           </span></td><td><span style=white-space:pre-wrap>SOCIAL             </span></td><td>NaN</td><td><span style=white-space:pre-wrap>7     </span></td><td><span style=white-space:pre-wrap>7.7M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Social                 </span></td><td><span style=white-space:pre-wrap>February 2, 2018  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td><td>4.255598</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>Frim: get new friends on local chat rooms    </td><td>SOCIAL             </td><td>4.0</td><td>88486 </td><td>Varies with device</td><td>5,000,000+ </td><td>Free</td><td>0</td><td>Mature 17+</td><td>Social                 </td><td>March 23, 2018    </td><td>Varies with device</td><td>Varies with device</td><td>4.000000</td><td>regular</td></tr>\n",
              "\t<tr><td>Fr Agnel Ambarnath                           </td><td>FAMILY             </td><td>4.2</td><td>117   </td><td>13M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td><td>4.200000</td><td>bom    </td></tr>\n",
              "\t<tr><td>Manga-FR - Anime Vostfr                      </td><td>COMICS             </td><td>3.4</td><td>291   </td><td>13M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Comics                 </td><td>May 15, 2017      </td><td>2.0.1             </td><td>4.0 and up        </td><td>3.400000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Bulgarian French Dictionary Fr               </span></td><td>BOOKS_AND_REFERENCE</td><td>4.6</td><td><span style=white-space:pre-wrap>603   </span></td><td><span style=white-space:pre-wrap>7.4M              </span></td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>June 19, 2016     </span></td><td><span style=white-space:pre-wrap>2.96              </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td><td>4.600000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>News Minecraft.fr                            </span></td><td>NEWS_AND_MAGAZINES </td><td>3.8</td><td><span style=white-space:pre-wrap>881   </span></td><td><span style=white-space:pre-wrap>2.3M              </span></td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>News &amp; Magazines       </span></td><td><span style=white-space:pre-wrap>January 20, 2014  </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>1.6 and up        </span></td><td>3.800000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>payermonstationnement.fr                     </span></td><td>MAPS_AND_NAVIGATION</td><td>NaN</td><td><span style=white-space:pre-wrap>38    </span></td><td><span style=white-space:pre-wrap>9.8M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Maps &amp; Navigation      </span></td><td><span style=white-space:pre-wrap>June 13, 2018     </span></td><td><span style=white-space:pre-wrap>2.0.148.0         </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td><td>4.051613</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>FR Tides                                     </td><td>WEATHER            </td><td>3.8</td><td>1195  </td><td>582k              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Weather                </td><td>February 16, 2014 </td><td>6.0               </td><td>2.1 and up        </td><td>3.800000</td><td>regular</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Chemin (fr)                                  </span></td><td>BOOKS_AND_REFERENCE</td><td>4.8</td><td><span style=white-space:pre-wrap>44    </span></td><td><span style=white-space:pre-wrap>619k              </span></td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>March 23, 2014    </span></td><td><span style=white-space:pre-wrap>0.8               </span></td><td><span style=white-space:pre-wrap>2.2 and up        </span></td><td>4.800000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>FR Calculator                                </td><td>FAMILY             </td><td>4.0</td><td>7     </td><td>2.6M              </td><td>500+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 18, 2017     </td><td>1.0.0             </td><td>4.1 and up        </td><td>4.000000</td><td>regular</td></tr>\n",
              "\t<tr><td>FR Forms                                     </td><td>BUSINESS           </td><td>NaN</td><td>0     </td><td>9.6M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>September 29, 2016</td><td>1.1.5             </td><td>4.0 and up        </td><td>4.121452</td><td>bom    </td></tr>\n",
              "\t<tr><td>Sya9a Maroc - FR                             </td><td>FAMILY             </td><td>4.5</td><td>38    </td><td>53M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 25, 2017     </td><td>1.48              </td><td>4.1 and up        </td><td>4.500000</td><td>bom    </td></tr>\n",
              "\t<tr><td>Fr. Mike Schmitz Audio Teachings             </td><td>FAMILY             </td><td>5.0</td><td>4     </td><td>3.6M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 6, 2018      </td><td>1.0               </td><td>4.1 and up        </td><td>5.000000</td><td>bom    </td></tr>\n",
              "\t<tr><td>Parkinson Exercices FR                       </td><td>MEDICAL            </td><td>NaN</td><td>3     </td><td>9.5M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>January 20, 2017  </td><td>1.0               </td><td>2.2 and up        </td><td>4.189143</td><td>bom    </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>The SCP Foundation DB fr nn5n                </span></td><td>BOOKS_AND_REFERENCE</td><td>4.5</td><td><span style=white-space:pre-wrap>114   </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td>Mature 17+</td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>January 19, 2015  </span></td><td>Varies with device</td><td>Varies with device</td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "\t<tr><td>iHoroscope - 2018 Daily Horoscope &amp; Astrology</td><td><span style=white-space:pre-wrap>LIFESTYLE          </span></td><td>4.5</td><td>398307</td><td><span style=white-space:pre-wrap>19M               </span></td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Lifestyle              </span></td><td><span style=white-space:pre-wrap>July 25, 2018     </span></td><td>Varies with device</td><td>Varies with device</td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 10840 × 15\n\n| App &lt;chr&gt; | Category &lt;chr&gt; | Rating &lt;dbl&gt; | Reviews &lt;chr&gt; | Size &lt;chr&gt; | Installs &lt;chr&gt; | Type &lt;chr&gt; | Price &lt;chr&gt; | Content.Rating &lt;chr&gt; | Genres &lt;chr&gt; | Last.Updated &lt;chr&gt; | Current.Ver &lt;chr&gt; | Android.Ver &lt;chr&gt; | newRating &lt;dbl&gt; | rating_class &lt;chr&gt; |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n| Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook     | ART_AND_DESIGN | 4.1 | 159    | 19M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | January 7, 2018    | 1.0.0              | 4.0.3 and up | 4.100000 | bom     |\n| Coloring book moana                                | ART_AND_DESIGN | 3.9 | 967    | 14M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Pretend Play       | January 15, 2018   | 2.0.0              | 4.0.3 and up | 3.900000 | regular |\n| U Launcher Lite – FREE Live Cool Themes, Hide Apps | ART_AND_DESIGN | 4.7 | 87510  | 8.7M | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 1, 2018     | 1.2.4              | 4.0.3 and up | 4.700000 | bom     |\n| Sketch - Draw &amp; Paint                              | ART_AND_DESIGN | 4.5 | 215644 | 25M  | 50,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | June 8, 2018       | Varies with device | 4.2 and up   | 4.500000 | bom     |\n| Pixel Draw - Number Art Coloring Book              | ART_AND_DESIGN | 4.3 | 967    | 2.8M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | June 20, 2018      | 1.1                | 4.4 and up   | 4.300000 | bom     |\n| Paper flowers instructions                         | ART_AND_DESIGN | 4.4 | 167    | 5.6M | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | March 26, 2017     | 1.0                | 2.3 and up   | 4.400000 | bom     |\n| Smoke Effect Photo Maker - Smoke Editor            | ART_AND_DESIGN | 3.8 | 178    | 19M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 26, 2018     | 1.1                | 4.0.3 and up | 3.800000 | regular |\n| Infinite Painter                                   | ART_AND_DESIGN | 4.1 | 36815  | 29M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | June 14, 2018      | 6.1.61.1           | 4.2 and up   | 4.100000 | bom     |\n| Garden Coloring Book                               | ART_AND_DESIGN | 4.4 | 13791  | 33M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | September 20, 2017 | 2.9.2              | 3.0 and up   | 4.400000 | bom     |\n| Kids Paint Free - Drawing Fun                      | ART_AND_DESIGN | 4.7 | 121    | 3.1M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design;Creativity         | July 3, 2018       | 2.8                | 4.0.3 and up | 4.700000 | bom     |\n| Text on Photo - Fonteee                            | ART_AND_DESIGN | 4.4 | 13880  | 28M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | October 27, 2017   | 1.0.4              | 4.1 and up   | 4.400000 | bom     |\n| Name Art Photo Editor - Focus n Filters            | ART_AND_DESIGN | 4.4 | 8788   | 12M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 1.0.15             | 4.0 and up   | 4.400000 | bom     |\n| Tattoo Name On My Photo Editor                     | ART_AND_DESIGN | 4.2 | 44829  | 20M  | 10,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | April 2, 2018      | 3.8                | 4.1 and up   | 4.200000 | bom     |\n| Mandala Coloring Book                              | ART_AND_DESIGN | 4.6 | 4326   | 21M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | June 26, 2018      | 1.0.4              | 4.4 and up   | 4.600000 | bom     |\n| 3D Color Pixel by Number - Sandbox Art Coloring    | ART_AND_DESIGN | 4.4 | 1518   | 37M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 1.2.3              | 2.3 and up   | 4.400000 | bom     |\n| Learn To Draw Kawaii Characters                    | ART_AND_DESIGN | 3.2 | 55     | 2.7M | 5,000+      | Free | 0 | Everyone     | Art &amp; Design                    | June 6, 2018       | NaN                | 4.2 and up   | 3.200000 | regular |\n| Photo Designer - Write your name with shapes       | ART_AND_DESIGN | 4.7 | 3632   | 5.5M | 500,000+    | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 3.1                | 4.1 and up   | 4.700000 | bom     |\n| 350 Diy Room Decor Ideas                           | ART_AND_DESIGN | 4.5 | 27     | 17M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | November 7, 2017   | 1.0                | 2.3 and up   | 4.500000 | bom     |\n| FlipaClip - Cartoon animation                      | ART_AND_DESIGN | 4.3 | 194216 | 39M  | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 2.2.5              | 4.0.3 and up | 4.300000 | bom     |\n| ibis Paint X                                       | ART_AND_DESIGN | 4.6 | 224399 | 31M  | 10,000,000+ | Free | 0 | Everyone     | Art &amp; Design                    | July 30, 2018      | 5.5.4              | 4.1 and up   | 4.600000 | bom     |\n| Logo Maker - Small Business                        | ART_AND_DESIGN | 4.0 | 450    | 14M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | April 20, 2018     | 4.0                | 4.1 and up   | 4.000000 | regular |\n| Boys Photo Editor - Six Pack &amp; Men's Suit          | ART_AND_DESIGN | 4.1 | 654    | 12M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 20, 2018     | 1.1                | 4.0.3 and up | 4.100000 | bom     |\n| Superheroes Wallpapers | 4K Backgrounds            | ART_AND_DESIGN | 4.7 | 7699   | 4.2M | 500,000+    | Free | 0 | Everyone 10+ | Art &amp; Design                    | July 12, 2018      | 2.2.6.2            | 4.0.3 and up | 4.700000 | bom     |\n| Mcqueen Coloring pages                             | ART_AND_DESIGN | NaN | 61     | 7.0M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Action &amp; Adventure | March 7, 2018      | 1.0.0              | 4.1 and up   | 4.358065 | bom     |\n| HD Mickey Minnie Wallpapers                        | ART_AND_DESIGN | 4.7 | 118    | 23M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 7, 2018       | 1.1.3              | 4.1 and up   | 4.700000 | bom     |\n| Harley Quinn wallpapers HD                         | ART_AND_DESIGN | 4.8 | 192    | 6.0M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 25, 2018     | 1.5                | 3.0 and up   | 4.800000 | bom     |\n| Colorfit - Drawing &amp; Coloring                      | ART_AND_DESIGN | 4.7 | 20260  | 25M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | October 11, 2017   | 1.0.8              | 4.0.3 and up | 4.700000 | bom     |\n| Animated Photo Editor                              | ART_AND_DESIGN | 4.1 | 203    | 6.1M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 21, 2018     | 1.03               | 4.0.3 and up | 4.100000 | bom     |\n| Pencil Sketch Drawing                              | ART_AND_DESIGN | 3.9 | 136    | 4.6M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 12, 2018      | 6.0                | 2.3 and up   | 3.900000 | regular |\n| Easy Realistic Drawing Tutorial                    | ART_AND_DESIGN | 4.1 | 223    | 4.2M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 22, 2017    | 1.0                | 2.3 and up   | 4.100000 | bom     |\n| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n| FR Plus 1.6                                   | AUTO_AND_VEHICLES   | NaN | 4      | 3.9M               | 100+        | Free | 0 | Everyone   | Auto &amp; Vehicles         | July 24, 2018      | 1.3.6              | 4.4W and up        | 4.190411 | bom     |\n| Fr Agnel Pune                                 | FAMILY              | 4.1 | 80     | 13M                | 1,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       | 4.100000 | bom     |\n| DICT.fr Mobile                                | BUSINESS            | NaN | 20     | 2.7M               | 10,000+     | Free | 0 | Everyone   | Business                | July 17, 2018      | 2.1.10             | 4.1 and up         | 4.121452 | bom     |\n| FR: My Secret Pets!                           | FAMILY              | 4.0 | 785    | 31M                | 50,000+     | Free | 0 | Teen       | Entertainment           | June 3, 2015       | 1.3.1              | 3.0 and up         | 4.000000 | regular |\n| Golden Dictionary (FR-AR)                     | BOOKS_AND_REFERENCE | 4.2 | 5775   | 4.9M               | 500,000+    | Free | 0 | Everyone   | Books &amp; Reference       | July 19, 2018      | 7.0.4.6            | 4.2 and up         | 4.200000 | bom     |\n| FieldBi FR Offline                            | BUSINESS            | NaN | 2      | 6.8M               | 100+        | Free | 0 | Everyone   | Business                | August 6, 2018     | 2.1.8              | 4.1 and up         | 4.121452 | bom     |\n| HTC Sense Input - FR                          | TOOLS               | 4.0 | 885    | 8.0M               | 100,000+    | Free | 0 | Everyone   | Tools                   | October 30, 2015   | 1.0.612928         | 5.0 and up         | 4.000000 | regular |\n| Gold Quote - Gold.fr                          | FINANCE             | NaN | 96     | 1.5M               | 10,000+     | Free | 0 | Everyone   | Finance                 | May 19, 2016       | 2.3                | 2.2 and up         | 4.131889 | bom     |\n| Fanfic-FR                                     | BOOKS_AND_REFERENCE | 3.3 | 52     | 3.6M               | 5,000+      | Free | 0 | Teen       | Books &amp; Reference       | August 5, 2017     | 0.3.4              | 4.1 and up         | 3.300000 | regular |\n| Fr. Daoud Lamei                               | FAMILY              | 5.0 | 22     | 8.6M               | 1,000+      | Free | 0 | Teen       | Education               | June 27, 2018      | 3.8.0              | 4.1 and up         | 5.000000 | bom     |\n| Poop FR                                       | FAMILY              | NaN | 6      | 2.5M               | 50+         | Free | 0 | Everyone   | Entertainment           | May 29, 2018       | 1.0                | 4.0.3 and up       | 4.192272 | bom     |\n| PLMGSS FR                                     | PRODUCTIVITY        | NaN | 0      | 3.1M               | 10+         | Free | 0 | Everyone   | Productivity            | December 1, 2017   | 1                  | 4.4 and up         | 4.211396 | bom     |\n| List iptv FR                                  | VIDEO_PLAYERS       | NaN | 1      | 2.9M               | 100+        | Free | 0 | Everyone   | Video Players &amp; Editors | April 22, 2018     | 1.0                | 4.0.3 and up       | 4.063750 | bom     |\n| Cardio-FR                                     | MEDICAL             | NaN | 67     | 82M                | 10,000+     | Free | 0 | Everyone   | Medical                 | July 31, 2018      | 2.2.2              | 4.4 and up         | 4.189143 | bom     |\n| Naruto &amp; Boruto FR                            | SOCIAL              | NaN | 7      | 7.7M               | 100+        | Free | 0 | Teen       | Social                  | February 2, 2018   | 1.0                | 4.0 and up         | 4.255598 | bom     |\n| Frim: get new friends on local chat rooms     | SOCIAL              | 4.0 | 88486  | Varies with device | 5,000,000+  | Free | 0 | Mature 17+ | Social                  | March 23, 2018     | Varies with device | Varies with device | 4.000000 | regular |\n| Fr Agnel Ambarnath                            | FAMILY              | 4.2 | 117    | 13M                | 5,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       | 4.200000 | bom     |\n| Manga-FR - Anime Vostfr                       | COMICS              | 3.4 | 291    | 13M                | 10,000+     | Free | 0 | Everyone   | Comics                  | May 15, 2017       | 2.0.1              | 4.0 and up         | 3.400000 | regular |\n| Bulgarian French Dictionary Fr                | BOOKS_AND_REFERENCE | 4.6 | 603    | 7.4M               | 10,000+     | Free | 0 | Everyone   | Books &amp; Reference       | June 19, 2016      | 2.96               | 4.1 and up         | 4.600000 | bom     |\n| News Minecraft.fr                             | NEWS_AND_MAGAZINES  | 3.8 | 881    | 2.3M               | 100,000+    | Free | 0 | Everyone   | News &amp; Magazines        | January 20, 2014   | 1.5                | 1.6 and up         | 3.800000 | regular |\n| payermonstationnement.fr                      | MAPS_AND_NAVIGATION | NaN | 38     | 9.8M               | 5,000+      | Free | 0 | Everyone   | Maps &amp; Navigation       | June 13, 2018      | 2.0.148.0          | 4.0 and up         | 4.051613 | bom     |\n| FR Tides                                      | WEATHER             | 3.8 | 1195   | 582k               | 100,000+    | Free | 0 | Everyone   | Weather                 | February 16, 2014  | 6.0                | 2.1 and up         | 3.800000 | regular |\n| Chemin (fr)                                   | BOOKS_AND_REFERENCE | 4.8 | 44     | 619k               | 1,000+      | Free | 0 | Everyone   | Books &amp; Reference       | March 23, 2014     | 0.8                | 2.2 and up         | 4.800000 | bom     |\n| FR Calculator                                 | FAMILY              | 4.0 | 7      | 2.6M               | 500+        | Free | 0 | Everyone   | Education               | June 18, 2017      | 1.0.0              | 4.1 and up         | 4.000000 | regular |\n| FR Forms                                      | BUSINESS            | NaN | 0      | 9.6M               | 10+         | Free | 0 | Everyone   | Business                | September 29, 2016 | 1.1.5              | 4.0 and up         | 4.121452 | bom     |\n| Sya9a Maroc - FR                              | FAMILY              | 4.5 | 38     | 53M                | 5,000+      | Free | 0 | Everyone   | Education               | July 25, 2017      | 1.48               | 4.1 and up         | 4.500000 | bom     |\n| Fr. Mike Schmitz Audio Teachings              | FAMILY              | 5.0 | 4      | 3.6M               | 100+        | Free | 0 | Everyone   | Education               | July 6, 2018       | 1.0                | 4.1 and up         | 5.000000 | bom     |\n| Parkinson Exercices FR                        | MEDICAL             | NaN | 3      | 9.5M               | 1,000+      | Free | 0 | Everyone   | Medical                 | January 20, 2017   | 1.0                | 2.2 and up         | 4.189143 | bom     |\n| The SCP Foundation DB fr nn5n                 | BOOKS_AND_REFERENCE | 4.5 | 114    | Varies with device | 1,000+      | Free | 0 | Mature 17+ | Books &amp; Reference       | January 19, 2015   | Varies with device | Varies with device | 4.500000 | bom     |\n| iHoroscope - 2018 Daily Horoscope &amp; Astrology | LIFESTYLE           | 4.5 | 398307 | 19M                | 10,000,000+ | Free | 0 | Everyone   | Lifestyle               | July 25, 2018      | Varies with device | Varies with device | 4.500000 | bom     |\n\n",
            "text/latex": "A data.frame: 10840 × 15\n\\begin{tabular}{lllllllllllllll}\n App & Category & Rating & Reviews & Size & Installs & Type & Price & Content.Rating & Genres & Last.Updated & Current.Ver & Android.Ver & newRating & rating\\_class\\\\\n <chr> & <chr> & <dbl> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <dbl> & <chr>\\\\\n\\hline\n\t Photo Editor \\& Candy Camera \\& Grid \\& ScrapBook     & ART\\_AND\\_DESIGN & 4.1 & 159    & 19M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & January 7, 2018    & 1.0.0              & 4.0.3 and up & 4.100000 & bom    \\\\\n\t Coloring book moana                                & ART\\_AND\\_DESIGN & 3.9 & 967    & 14M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Pretend Play       & January 15, 2018   & 2.0.0              & 4.0.3 and up & 3.900000 & regular\\\\\n\t U Launcher Lite – FREE Live Cool Themes, Hide Apps & ART\\_AND\\_DESIGN & 4.7 & 87510  & 8.7M & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 1, 2018     & 1.2.4              & 4.0.3 and up & 4.700000 & bom    \\\\\n\t Sketch - Draw \\& Paint                              & ART\\_AND\\_DESIGN & 4.5 & 215644 & 25M  & 50,000,000+ & Free & 0 & Teen         & Art \\& Design                    & June 8, 2018       & Varies with device & 4.2 and up   & 4.500000 & bom    \\\\\n\t Pixel Draw - Number Art Coloring Book              & ART\\_AND\\_DESIGN & 4.3 & 967    & 2.8M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & June 20, 2018      & 1.1                & 4.4 and up   & 4.300000 & bom    \\\\\n\t Paper flowers instructions                         & ART\\_AND\\_DESIGN & 4.4 & 167    & 5.6M & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & March 26, 2017     & 1.0                & 2.3 and up   & 4.400000 & bom    \\\\\n\t Smoke Effect Photo Maker - Smoke Editor            & ART\\_AND\\_DESIGN & 3.8 & 178    & 19M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 26, 2018     & 1.1                & 4.0.3 and up & 3.800000 & regular\\\\\n\t Infinite Painter                                   & ART\\_AND\\_DESIGN & 4.1 & 36815  & 29M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & June 14, 2018      & 6.1.61.1           & 4.2 and up   & 4.100000 & bom    \\\\\n\t Garden Coloring Book                               & ART\\_AND\\_DESIGN & 4.4 & 13791  & 33M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & September 20, 2017 & 2.9.2              & 3.0 and up   & 4.400000 & bom    \\\\\n\t Kids Paint Free - Drawing Fun                      & ART\\_AND\\_DESIGN & 4.7 & 121    & 3.1M & 10,000+     & Free & 0 & Everyone     & Art \\& Design;Creativity         & July 3, 2018       & 2.8                & 4.0.3 and up & 4.700000 & bom    \\\\\n\t Text on Photo - Fonteee                            & ART\\_AND\\_DESIGN & 4.4 & 13880  & 28M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & October 27, 2017   & 1.0.4              & 4.1 and up   & 4.400000 & bom    \\\\\n\t Name Art Photo Editor - Focus n Filters            & ART\\_AND\\_DESIGN & 4.4 & 8788   & 12M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 1.0.15             & 4.0 and up   & 4.400000 & bom    \\\\\n\t Tattoo Name On My Photo Editor                     & ART\\_AND\\_DESIGN & 4.2 & 44829  & 20M  & 10,000,000+ & Free & 0 & Teen         & Art \\& Design                    & April 2, 2018      & 3.8                & 4.1 and up   & 4.200000 & bom    \\\\\n\t Mandala Coloring Book                              & ART\\_AND\\_DESIGN & 4.6 & 4326   & 21M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & June 26, 2018      & 1.0.4              & 4.4 and up   & 4.600000 & bom    \\\\\n\t 3D Color Pixel by Number - Sandbox Art Coloring    & ART\\_AND\\_DESIGN & 4.4 & 1518   & 37M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 1.2.3              & 2.3 and up   & 4.400000 & bom    \\\\\n\t Learn To Draw Kawaii Characters                    & ART\\_AND\\_DESIGN & 3.2 & 55     & 2.7M & 5,000+      & Free & 0 & Everyone     & Art \\& Design                    & June 6, 2018       & NaN                & 4.2 and up   & 3.200000 & regular\\\\\n\t Photo Designer - Write your name with shapes       & ART\\_AND\\_DESIGN & 4.7 & 3632   & 5.5M & 500,000+    & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 3.1                & 4.1 and up   & 4.700000 & bom    \\\\\n\t 350 Diy Room Decor Ideas                           & ART\\_AND\\_DESIGN & 4.5 & 27     & 17M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & November 7, 2017   & 1.0                & 2.3 and up   & 4.500000 & bom    \\\\\n\t FlipaClip - Cartoon animation                      & ART\\_AND\\_DESIGN & 4.3 & 194216 & 39M  & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 2.2.5              & 4.0.3 and up & 4.300000 & bom    \\\\\n\t ibis Paint X                                       & ART\\_AND\\_DESIGN & 4.6 & 224399 & 31M  & 10,000,000+ & Free & 0 & Everyone     & Art \\& Design                    & July 30, 2018      & 5.5.4              & 4.1 and up   & 4.600000 & bom    \\\\\n\t Logo Maker - Small Business                        & ART\\_AND\\_DESIGN & 4.0 & 450    & 14M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & April 20, 2018     & 4.0                & 4.1 and up   & 4.000000 & regular\\\\\n\t Boys Photo Editor - Six Pack \\& Men's Suit          & ART\\_AND\\_DESIGN & 4.1 & 654    & 12M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 20, 2018     & 1.1                & 4.0.3 and up & 4.100000 & bom    \\\\\n\t Superheroes Wallpapers \\textbar{} 4K Backgrounds            & ART\\_AND\\_DESIGN & 4.7 & 7699   & 4.2M & 500,000+    & Free & 0 & Everyone 10+ & Art \\& Design                    & July 12, 2018      & 2.2.6.2            & 4.0.3 and up & 4.700000 & bom    \\\\\n\t Mcqueen Coloring pages                             & ART\\_AND\\_DESIGN & NaN & 61     & 7.0M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Action \\& Adventure & March 7, 2018      & 1.0.0              & 4.1 and up   & 4.358065 & bom    \\\\\n\t HD Mickey Minnie Wallpapers                        & ART\\_AND\\_DESIGN & 4.7 & 118    & 23M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 7, 2018       & 1.1.3              & 4.1 and up   & 4.700000 & bom    \\\\\n\t Harley Quinn wallpapers HD                         & ART\\_AND\\_DESIGN & 4.8 & 192    & 6.0M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 25, 2018     & 1.5                & 3.0 and up   & 4.800000 & bom    \\\\\n\t Colorfit - Drawing \\& Coloring                      & ART\\_AND\\_DESIGN & 4.7 & 20260  & 25M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & October 11, 2017   & 1.0.8              & 4.0.3 and up & 4.700000 & bom    \\\\\n\t Animated Photo Editor                              & ART\\_AND\\_DESIGN & 4.1 & 203    & 6.1M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 21, 2018     & 1.03               & 4.0.3 and up & 4.100000 & bom    \\\\\n\t Pencil Sketch Drawing                              & ART\\_AND\\_DESIGN & 3.9 & 136    & 4.6M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 12, 2018      & 6.0                & 2.3 and up   & 3.900000 & regular\\\\\n\t Easy Realistic Drawing Tutorial                    & ART\\_AND\\_DESIGN & 4.1 & 223    & 4.2M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 22, 2017    & 1.0                & 2.3 and up   & 4.100000 & bom    \\\\\n\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n\t FR Plus 1.6                                   & AUTO\\_AND\\_VEHICLES   & NaN & 4      & 3.9M               & 100+        & Free & 0 & Everyone   & Auto \\& Vehicles         & July 24, 2018      & 1.3.6              & 4.4W and up        & 4.190411 & bom    \\\\\n\t Fr Agnel Pune                                 & FAMILY              & 4.1 & 80     & 13M                & 1,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up       & 4.100000 & bom    \\\\\n\t DICT.fr Mobile                                & BUSINESS            & NaN & 20     & 2.7M               & 10,000+     & Free & 0 & Everyone   & Business                & July 17, 2018      & 2.1.10             & 4.1 and up         & 4.121452 & bom    \\\\\n\t FR: My Secret Pets!                           & FAMILY              & 4.0 & 785    & 31M                & 50,000+     & Free & 0 & Teen       & Entertainment           & June 3, 2015       & 1.3.1              & 3.0 and up         & 4.000000 & regular\\\\\n\t Golden Dictionary (FR-AR)                     & BOOKS\\_AND\\_REFERENCE & 4.2 & 5775   & 4.9M               & 500,000+    & Free & 0 & Everyone   & Books \\& Reference       & July 19, 2018      & 7.0.4.6            & 4.2 and up         & 4.200000 & bom    \\\\\n\t FieldBi FR Offline                            & BUSINESS            & NaN & 2      & 6.8M               & 100+        & Free & 0 & Everyone   & Business                & August 6, 2018     & 2.1.8              & 4.1 and up         & 4.121452 & bom    \\\\\n\t HTC Sense Input - FR                          & TOOLS               & 4.0 & 885    & 8.0M               & 100,000+    & Free & 0 & Everyone   & Tools                   & October 30, 2015   & 1.0.612928         & 5.0 and up         & 4.000000 & regular\\\\\n\t Gold Quote - Gold.fr                          & FINANCE             & NaN & 96     & 1.5M               & 10,000+     & Free & 0 & Everyone   & Finance                 & May 19, 2016       & 2.3                & 2.2 and up         & 4.131889 & bom    \\\\\n\t Fanfic-FR                                     & BOOKS\\_AND\\_REFERENCE & 3.3 & 52     & 3.6M               & 5,000+      & Free & 0 & Teen       & Books \\& Reference       & August 5, 2017     & 0.3.4              & 4.1 and up         & 3.300000 & regular\\\\\n\t Fr. Daoud Lamei                               & FAMILY              & 5.0 & 22     & 8.6M               & 1,000+      & Free & 0 & Teen       & Education               & June 27, 2018      & 3.8.0              & 4.1 and up         & 5.000000 & bom    \\\\\n\t Poop FR                                       & FAMILY              & NaN & 6      & 2.5M               & 50+         & Free & 0 & Everyone   & Entertainment           & May 29, 2018       & 1.0                & 4.0.3 and up       & 4.192272 & bom    \\\\\n\t PLMGSS FR                                     & PRODUCTIVITY        & NaN & 0      & 3.1M               & 10+         & Free & 0 & Everyone   & Productivity            & December 1, 2017   & 1                  & 4.4 and up         & 4.211396 & bom    \\\\\n\t List iptv FR                                  & VIDEO\\_PLAYERS       & NaN & 1      & 2.9M               & 100+        & Free & 0 & Everyone   & Video Players \\& Editors & April 22, 2018     & 1.0                & 4.0.3 and up       & 4.063750 & bom    \\\\\n\t Cardio-FR                                     & MEDICAL             & NaN & 67     & 82M                & 10,000+     & Free & 0 & Everyone   & Medical                 & July 31, 2018      & 2.2.2              & 4.4 and up         & 4.189143 & bom    \\\\\n\t Naruto \\& Boruto FR                            & SOCIAL              & NaN & 7      & 7.7M               & 100+        & Free & 0 & Teen       & Social                  & February 2, 2018   & 1.0                & 4.0 and up         & 4.255598 & bom    \\\\\n\t Frim: get new friends on local chat rooms     & SOCIAL              & 4.0 & 88486  & Varies with device & 5,000,000+  & Free & 0 & Mature 17+ & Social                  & March 23, 2018     & Varies with device & Varies with device & 4.000000 & regular\\\\\n\t Fr Agnel Ambarnath                            & FAMILY              & 4.2 & 117    & 13M                & 5,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up       & 4.200000 & bom    \\\\\n\t Manga-FR - Anime Vostfr                       & COMICS              & 3.4 & 291    & 13M                & 10,000+     & Free & 0 & Everyone   & Comics                  & May 15, 2017       & 2.0.1              & 4.0 and up         & 3.400000 & regular\\\\\n\t Bulgarian French Dictionary Fr                & BOOKS\\_AND\\_REFERENCE & 4.6 & 603    & 7.4M               & 10,000+     & Free & 0 & Everyone   & Books \\& Reference       & June 19, 2016      & 2.96               & 4.1 and up         & 4.600000 & bom    \\\\\n\t News Minecraft.fr                             & NEWS\\_AND\\_MAGAZINES  & 3.8 & 881    & 2.3M               & 100,000+    & Free & 0 & Everyone   & News \\& Magazines        & January 20, 2014   & 1.5                & 1.6 and up         & 3.800000 & regular\\\\\n\t payermonstationnement.fr                      & MAPS\\_AND\\_NAVIGATION & NaN & 38     & 9.8M               & 5,000+      & Free & 0 & Everyone   & Maps \\& Navigation       & June 13, 2018      & 2.0.148.0          & 4.0 and up         & 4.051613 & bom    \\\\\n\t FR Tides                                      & WEATHER             & 3.8 & 1195   & 582k               & 100,000+    & Free & 0 & Everyone   & Weather                 & February 16, 2014  & 6.0                & 2.1 and up         & 3.800000 & regular\\\\\n\t Chemin (fr)                                   & BOOKS\\_AND\\_REFERENCE & 4.8 & 44     & 619k               & 1,000+      & Free & 0 & Everyone   & Books \\& Reference       & March 23, 2014     & 0.8                & 2.2 and up         & 4.800000 & bom    \\\\\n\t FR Calculator                                 & FAMILY              & 4.0 & 7      & 2.6M               & 500+        & Free & 0 & Everyone   & Education               & June 18, 2017      & 1.0.0              & 4.1 and up         & 4.000000 & regular\\\\\n\t FR Forms                                      & BUSINESS            & NaN & 0      & 9.6M               & 10+         & Free & 0 & Everyone   & Business                & September 29, 2016 & 1.1.5              & 4.0 and up         & 4.121452 & bom    \\\\\n\t Sya9a Maroc - FR                              & FAMILY              & 4.5 & 38     & 53M                & 5,000+      & Free & 0 & Everyone   & Education               & July 25, 2017      & 1.48               & 4.1 and up         & 4.500000 & bom    \\\\\n\t Fr. Mike Schmitz Audio Teachings              & FAMILY              & 5.0 & 4      & 3.6M               & 100+        & Free & 0 & Everyone   & Education               & July 6, 2018       & 1.0                & 4.1 and up         & 5.000000 & bom    \\\\\n\t Parkinson Exercices FR                        & MEDICAL             & NaN & 3      & 9.5M               & 1,000+      & Free & 0 & Everyone   & Medical                 & January 20, 2017   & 1.0                & 2.2 and up         & 4.189143 & bom    \\\\\n\t The SCP Foundation DB fr nn5n                 & BOOKS\\_AND\\_REFERENCE & 4.5 & 114    & Varies with device & 1,000+      & Free & 0 & Mature 17+ & Books \\& Reference       & January 19, 2015   & Varies with device & Varies with device & 4.500000 & bom    \\\\\n\t iHoroscope - 2018 Daily Horoscope \\& Astrology & LIFESTYLE           & 4.5 & 398307 & 19M                & 10,000,000+ & Free & 0 & Everyone   & Lifestyle               & July 25, 2018      & Varies with device & Varies with device & 4.500000 & bom    \\\\\n\\end{tabular}\n",
            "text/plain": [
              "      App                                                Category           \n",
              "1     Photo Editor & Candy Camera & Grid & ScrapBook     ART_AND_DESIGN     \n",
              "2     Coloring book moana                                ART_AND_DESIGN     \n",
              "3     U Launcher Lite – FREE Live Cool Themes, Hide Apps ART_AND_DESIGN     \n",
              "4     Sketch - Draw & Paint                              ART_AND_DESIGN     \n",
              "5     Pixel Draw - Number Art Coloring Book              ART_AND_DESIGN     \n",
              "6     Paper flowers instructions                         ART_AND_DESIGN     \n",
              "7     Smoke Effect Photo Maker - Smoke Editor            ART_AND_DESIGN     \n",
              "8     Infinite Painter                                   ART_AND_DESIGN     \n",
              "9     Garden Coloring Book                               ART_AND_DESIGN     \n",
              "10    Kids Paint Free - Drawing Fun                      ART_AND_DESIGN     \n",
              "11    Text on Photo - Fonteee                            ART_AND_DESIGN     \n",
              "12    Name Art Photo Editor - Focus n Filters            ART_AND_DESIGN     \n",
              "13    Tattoo Name On My Photo Editor                     ART_AND_DESIGN     \n",
              "14    Mandala Coloring Book                              ART_AND_DESIGN     \n",
              "15    3D Color Pixel by Number - Sandbox Art Coloring    ART_AND_DESIGN     \n",
              "16    Learn To Draw Kawaii Characters                    ART_AND_DESIGN     \n",
              "17    Photo Designer - Write your name with shapes       ART_AND_DESIGN     \n",
              "18    350 Diy Room Decor Ideas                           ART_AND_DESIGN     \n",
              "19    FlipaClip - Cartoon animation                      ART_AND_DESIGN     \n",
              "20    ibis Paint X                                       ART_AND_DESIGN     \n",
              "21    Logo Maker - Small Business                        ART_AND_DESIGN     \n",
              "22    Boys Photo Editor - Six Pack & Men's Suit          ART_AND_DESIGN     \n",
              "23    Superheroes Wallpapers | 4K Backgrounds            ART_AND_DESIGN     \n",
              "24    Mcqueen Coloring pages                             ART_AND_DESIGN     \n",
              "25    HD Mickey Minnie Wallpapers                        ART_AND_DESIGN     \n",
              "26    Harley Quinn wallpapers HD                         ART_AND_DESIGN     \n",
              "27    Colorfit - Drawing & Coloring                      ART_AND_DESIGN     \n",
              "28    Animated Photo Editor                              ART_AND_DESIGN     \n",
              "29    Pencil Sketch Drawing                              ART_AND_DESIGN     \n",
              "30    Easy Realistic Drawing Tutorial                    ART_AND_DESIGN     \n",
              "⋮     ⋮                                                  ⋮                  \n",
              "10811 FR Plus 1.6                                        AUTO_AND_VEHICLES  \n",
              "10812 Fr Agnel Pune                                      FAMILY             \n",
              "10813 DICT.fr Mobile                                     BUSINESS           \n",
              "10814 FR: My Secret Pets!                                FAMILY             \n",
              "10815 Golden Dictionary (FR-AR)                          BOOKS_AND_REFERENCE\n",
              "10816 FieldBi FR Offline                                 BUSINESS           \n",
              "10817 HTC Sense Input - FR                               TOOLS              \n",
              "10818 Gold Quote - Gold.fr                               FINANCE            \n",
              "10819 Fanfic-FR                                          BOOKS_AND_REFERENCE\n",
              "10820 Fr. Daoud Lamei                                    FAMILY             \n",
              "10821 Poop FR                                            FAMILY             \n",
              "10822 PLMGSS FR                                          PRODUCTIVITY       \n",
              "10823 List iptv FR                                       VIDEO_PLAYERS      \n",
              "10824 Cardio-FR                                          MEDICAL            \n",
              "10825 Naruto & Boruto FR                                 SOCIAL             \n",
              "10826 Frim: get new friends on local chat rooms          SOCIAL             \n",
              "10827 Fr Agnel Ambarnath                                 FAMILY             \n",
              "10828 Manga-FR - Anime Vostfr                            COMICS             \n",
              "10829 Bulgarian French Dictionary Fr                     BOOKS_AND_REFERENCE\n",
              "10830 News Minecraft.fr                                  NEWS_AND_MAGAZINES \n",
              "10831 payermonstationnement.fr                           MAPS_AND_NAVIGATION\n",
              "10832 FR Tides                                           WEATHER            \n",
              "10833 Chemin (fr)                                        BOOKS_AND_REFERENCE\n",
              "10834 FR Calculator                                      FAMILY             \n",
              "10835 FR Forms                                           BUSINESS           \n",
              "10836 Sya9a Maroc - FR                                   FAMILY             \n",
              "10837 Fr. Mike Schmitz Audio Teachings                   FAMILY             \n",
              "10838 Parkinson Exercices FR                             MEDICAL            \n",
              "10839 The SCP Foundation DB fr nn5n                      BOOKS_AND_REFERENCE\n",
              "10840 iHoroscope - 2018 Daily Horoscope & Astrology      LIFESTYLE          \n",
              "      Rating Reviews Size               Installs    Type Price Content.Rating\n",
              "1     4.1    159     19M                10,000+     Free 0     Everyone      \n",
              "2     3.9    967     14M                500,000+    Free 0     Everyone      \n",
              "3     4.7    87510   8.7M               5,000,000+  Free 0     Everyone      \n",
              "4     4.5    215644  25M                50,000,000+ Free 0     Teen          \n",
              "5     4.3    967     2.8M               100,000+    Free 0     Everyone      \n",
              "6     4.4    167     5.6M               50,000+     Free 0     Everyone      \n",
              "7     3.8    178     19M                50,000+     Free 0     Everyone      \n",
              "8     4.1    36815   29M                1,000,000+  Free 0     Everyone      \n",
              "9     4.4    13791   33M                1,000,000+  Free 0     Everyone      \n",
              "10    4.7    121     3.1M               10,000+     Free 0     Everyone      \n",
              "11    4.4    13880   28M                1,000,000+  Free 0     Everyone      \n",
              "12    4.4    8788    12M                1,000,000+  Free 0     Everyone      \n",
              "13    4.2    44829   20M                10,000,000+ Free 0     Teen          \n",
              "14    4.6    4326    21M                100,000+    Free 0     Everyone      \n",
              "15    4.4    1518    37M                100,000+    Free 0     Everyone      \n",
              "16    3.2    55      2.7M               5,000+      Free 0     Everyone      \n",
              "17    4.7    3632    5.5M               500,000+    Free 0     Everyone      \n",
              "18    4.5    27      17M                10,000+     Free 0     Everyone      \n",
              "19    4.3    194216  39M                5,000,000+  Free 0     Everyone      \n",
              "20    4.6    224399  31M                10,000,000+ Free 0     Everyone      \n",
              "21    4.0    450     14M                100,000+    Free 0     Everyone      \n",
              "22    4.1    654     12M                100,000+    Free 0     Everyone      \n",
              "23    4.7    7699    4.2M               500,000+    Free 0     Everyone 10+  \n",
              "24    NaN    61      7.0M               100,000+    Free 0     Everyone      \n",
              "25    4.7    118     23M                50,000+     Free 0     Everyone      \n",
              "26    4.8    192     6.0M               10,000+     Free 0     Everyone      \n",
              "27    4.7    20260   25M                500,000+    Free 0     Everyone      \n",
              "28    4.1    203     6.1M               100,000+    Free 0     Everyone      \n",
              "29    3.9    136     4.6M               10,000+     Free 0     Everyone      \n",
              "30    4.1    223     4.2M               100,000+    Free 0     Everyone      \n",
              "⋮     ⋮      ⋮       ⋮                  ⋮           ⋮    ⋮     ⋮             \n",
              "10811 NaN    4       3.9M               100+        Free 0     Everyone      \n",
              "10812 4.1    80      13M                1,000+      Free 0     Everyone      \n",
              "10813 NaN    20      2.7M               10,000+     Free 0     Everyone      \n",
              "10814 4.0    785     31M                50,000+     Free 0     Teen          \n",
              "10815 4.2    5775    4.9M               500,000+    Free 0     Everyone      \n",
              "10816 NaN    2       6.8M               100+        Free 0     Everyone      \n",
              "10817 4.0    885     8.0M               100,000+    Free 0     Everyone      \n",
              "10818 NaN    96      1.5M               10,000+     Free 0     Everyone      \n",
              "10819 3.3    52      3.6M               5,000+      Free 0     Teen          \n",
              "10820 5.0    22      8.6M               1,000+      Free 0     Teen          \n",
              "10821 NaN    6       2.5M               50+         Free 0     Everyone      \n",
              "10822 NaN    0       3.1M               10+         Free 0     Everyone      \n",
              "10823 NaN    1       2.9M               100+        Free 0     Everyone      \n",
              "10824 NaN    67      82M                10,000+     Free 0     Everyone      \n",
              "10825 NaN    7       7.7M               100+        Free 0     Teen          \n",
              "10826 4.0    88486   Varies with device 5,000,000+  Free 0     Mature 17+    \n",
              "10827 4.2    117     13M                5,000+      Free 0     Everyone      \n",
              "10828 3.4    291     13M                10,000+     Free 0     Everyone      \n",
              "10829 4.6    603     7.4M               10,000+     Free 0     Everyone      \n",
              "10830 3.8    881     2.3M               100,000+    Free 0     Everyone      \n",
              "10831 NaN    38      9.8M               5,000+      Free 0     Everyone      \n",
              "10832 3.8    1195    582k               100,000+    Free 0     Everyone      \n",
              "10833 4.8    44      619k               1,000+      Free 0     Everyone      \n",
              "10834 4.0    7       2.6M               500+        Free 0     Everyone      \n",
              "10835 NaN    0       9.6M               10+         Free 0     Everyone      \n",
              "10836 4.5    38      53M                5,000+      Free 0     Everyone      \n",
              "10837 5.0    4       3.6M               100+        Free 0     Everyone      \n",
              "10838 NaN    3       9.5M               1,000+      Free 0     Everyone      \n",
              "10839 4.5    114     Varies with device 1,000+      Free 0     Mature 17+    \n",
              "10840 4.5    398307  19M                10,000,000+ Free 0     Everyone      \n",
              "      Genres                          Last.Updated       Current.Ver       \n",
              "1     Art & Design                    January 7, 2018    1.0.0             \n",
              "2     Art & Design;Pretend Play       January 15, 2018   2.0.0             \n",
              "3     Art & Design                    August 1, 2018     1.2.4             \n",
              "4     Art & Design                    June 8, 2018       Varies with device\n",
              "5     Art & Design;Creativity         June 20, 2018      1.1               \n",
              "6     Art & Design                    March 26, 2017     1.0               \n",
              "7     Art & Design                    April 26, 2018     1.1               \n",
              "8     Art & Design                    June 14, 2018      6.1.61.1          \n",
              "9     Art & Design                    September 20, 2017 2.9.2             \n",
              "10    Art & Design;Creativity         July 3, 2018       2.8               \n",
              "11    Art & Design                    October 27, 2017   1.0.4             \n",
              "12    Art & Design                    July 31, 2018      1.0.15            \n",
              "13    Art & Design                    April 2, 2018      3.8               \n",
              "14    Art & Design                    June 26, 2018      1.0.4             \n",
              "15    Art & Design                    August 3, 2018     1.2.3             \n",
              "16    Art & Design                    June 6, 2018       NaN               \n",
              "17    Art & Design                    July 31, 2018      3.1               \n",
              "18    Art & Design                    November 7, 2017   1.0               \n",
              "19    Art & Design                    August 3, 2018     2.2.5             \n",
              "20    Art & Design                    July 30, 2018      5.5.4             \n",
              "21    Art & Design                    April 20, 2018     4.0               \n",
              "22    Art & Design                    March 20, 2018     1.1               \n",
              "23    Art & Design                    July 12, 2018      2.2.6.2           \n",
              "24    Art & Design;Action & Adventure March 7, 2018      1.0.0             \n",
              "25    Art & Design                    July 7, 2018       1.1.3             \n",
              "26    Art & Design                    April 25, 2018     1.5               \n",
              "27    Art & Design;Creativity         October 11, 2017   1.0.8             \n",
              "28    Art & Design                    March 21, 2018     1.03              \n",
              "29    Art & Design                    July 12, 2018      6.0               \n",
              "30    Art & Design                    August 22, 2017    1.0               \n",
              "⋮     ⋮                               ⋮                  ⋮                 \n",
              "10811 Auto & Vehicles                 July 24, 2018      1.3.6             \n",
              "10812 Education                       June 13, 2018      2.0.20            \n",
              "10813 Business                        July 17, 2018      2.1.10            \n",
              "10814 Entertainment                   June 3, 2015       1.3.1             \n",
              "10815 Books & Reference               July 19, 2018      7.0.4.6           \n",
              "10816 Business                        August 6, 2018     2.1.8             \n",
              "10817 Tools                           October 30, 2015   1.0.612928        \n",
              "10818 Finance                         May 19, 2016       2.3               \n",
              "10819 Books & Reference               August 5, 2017     0.3.4             \n",
              "10820 Education                       June 27, 2018      3.8.0             \n",
              "10821 Entertainment                   May 29, 2018       1.0               \n",
              "10822 Productivity                    December 1, 2017   1                 \n",
              "10823 Video Players & Editors         April 22, 2018     1.0               \n",
              "10824 Medical                         July 31, 2018      2.2.2             \n",
              "10825 Social                          February 2, 2018   1.0               \n",
              "10826 Social                          March 23, 2018     Varies with device\n",
              "10827 Education                       June 13, 2018      2.0.20            \n",
              "10828 Comics                          May 15, 2017       2.0.1             \n",
              "10829 Books & Reference               June 19, 2016      2.96              \n",
              "10830 News & Magazines                January 20, 2014   1.5               \n",
              "10831 Maps & Navigation               June 13, 2018      2.0.148.0         \n",
              "10832 Weather                         February 16, 2014  6.0               \n",
              "10833 Books & Reference               March 23, 2014     0.8               \n",
              "10834 Education                       June 18, 2017      1.0.0             \n",
              "10835 Business                        September 29, 2016 1.1.5             \n",
              "10836 Education                       July 25, 2017      1.48              \n",
              "10837 Education                       July 6, 2018       1.0               \n",
              "10838 Medical                         January 20, 2017   1.0               \n",
              "10839 Books & Reference               January 19, 2015   Varies with device\n",
              "10840 Lifestyle                       July 25, 2018      Varies with device\n",
              "      Android.Ver        newRating rating_class\n",
              "1     4.0.3 and up       4.100000  bom         \n",
              "2     4.0.3 and up       3.900000  regular     \n",
              "3     4.0.3 and up       4.700000  bom         \n",
              "4     4.2 and up         4.500000  bom         \n",
              "5     4.4 and up         4.300000  bom         \n",
              "6     2.3 and up         4.400000  bom         \n",
              "7     4.0.3 and up       3.800000  regular     \n",
              "8     4.2 and up         4.100000  bom         \n",
              "9     3.0 and up         4.400000  bom         \n",
              "10    4.0.3 and up       4.700000  bom         \n",
              "11    4.1 and up         4.400000  bom         \n",
              "12    4.0 and up         4.400000  bom         \n",
              "13    4.1 and up         4.200000  bom         \n",
              "14    4.4 and up         4.600000  bom         \n",
              "15    2.3 and up         4.400000  bom         \n",
              "16    4.2 and up         3.200000  regular     \n",
              "17    4.1 and up         4.700000  bom         \n",
              "18    2.3 and up         4.500000  bom         \n",
              "19    4.0.3 and up       4.300000  bom         \n",
              "20    4.1 and up         4.600000  bom         \n",
              "21    4.1 and up         4.000000  regular     \n",
              "22    4.0.3 and up       4.100000  bom         \n",
              "23    4.0.3 and up       4.700000  bom         \n",
              "24    4.1 and up         4.358065  bom         \n",
              "25    4.1 and up         4.700000  bom         \n",
              "26    3.0 and up         4.800000  bom         \n",
              "27    4.0.3 and up       4.700000  bom         \n",
              "28    4.0.3 and up       4.100000  bom         \n",
              "29    2.3 and up         3.900000  regular     \n",
              "30    2.3 and up         4.100000  bom         \n",
              "⋮     ⋮                  ⋮         ⋮           \n",
              "10811 4.4W and up        4.190411  bom         \n",
              "10812 4.0.3 and up       4.100000  bom         \n",
              "10813 4.1 and up         4.121452  bom         \n",
              "10814 3.0 and up         4.000000  regular     \n",
              "10815 4.2 and up         4.200000  bom         \n",
              "10816 4.1 and up         4.121452  bom         \n",
              "10817 5.0 and up         4.000000  regular     \n",
              "10818 2.2 and up         4.131889  bom         \n",
              "10819 4.1 and up         3.300000  regular     \n",
              "10820 4.1 and up         5.000000  bom         \n",
              "10821 4.0.3 and up       4.192272  bom         \n",
              "10822 4.4 and up         4.211396  bom         \n",
              "10823 4.0.3 and up       4.063750  bom         \n",
              "10824 4.4 and up         4.189143  bom         \n",
              "10825 4.0 and up         4.255598  bom         \n",
              "10826 Varies with device 4.000000  regular     \n",
              "10827 4.0.3 and up       4.200000  bom         \n",
              "10828 4.0 and up         3.400000  regular     \n",
              "10829 4.1 and up         4.600000  bom         \n",
              "10830 1.6 and up         3.800000  regular     \n",
              "10831 4.0 and up         4.051613  bom         \n",
              "10832 2.1 and up         3.800000  regular     \n",
              "10833 2.2 and up         4.800000  bom         \n",
              "10834 4.1 and up         4.000000  regular     \n",
              "10835 4.0 and up         4.121452  bom         \n",
              "10836 4.1 and up         4.500000  bom         \n",
              "10837 4.1 and up         5.000000  bom         \n",
              "10838 2.2 and up         4.189143  bom         \n",
              "10839 Varies with device 4.500000  bom         \n",
              "10840 Varies with device 4.500000  bom         "
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "ggplot(dados_2) + geom_bar(aes(rating_class), stat = \"count\")"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.423397Z",
          "iopub.execute_input": "2024-04-14T16:57:27.424922Z",
          "iopub.status.idle": "2024-04-14T16:57:27.678329Z"
        },
        "trusted": true,
        "id": "dhO-cIHUk-je",
        "outputId": "ce96dc4e-6359-4486-925c-7817720f455e",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 30,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAACxFBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8RERETExMUFBQVFRUWFhYXFxcY\nGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIkJCQmJiYnJycoKCgpKSkqKiosLCwt\nLS0uLi4vLy8xMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9PT0+Pj5AQEBB\nQUFCQkJDQ0NGRkZHR0dISEhJSUlMTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZX\nV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhp\naWlqampra2tsbGxtbW1ubm5vb29wcHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7\ne3t9fX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eJiYmKioqLi4uMjIyNjY2Pj4+Q\nkJCRkZGSkpKTk5OVlZWWlpaXl5eZmZmampqcnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSl\npaWmpqanp6eoqKipqamrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4\nuLi5ubm6urq7u7u8vLy9vb2+vr6/v7/BwcHCwsLDw8PExMTGxsbHx8fIyMjJycnKysrLy8vM\nzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e\n3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w\n8PDx8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////IDqpSAAAA\nCXBIWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3d+5/edXnn8VutuhJt69nVum237aJrU61K\n1Urt7iRAADGBACtYBdxFKIUVFWQNCwUPW0Xaaj2BbbWAjSJsWZGjREBQgUg5NiAxmRBymMl8\n/om970lIJhPG6+bD9b7fM9/P6/nDfCdxxsd157pej8wkiL0C4BnruQcAuoCQgASEBCQgJCAB\nIQEJCAlIQEhAAkICEiSFNL5+PtmxzT3BCG3asdk9wght2bHBPcJMG7JD2vDofFK2uycYofHy\nuHuEEdpa1rtHmGk9IXUGIRkRUncQkhEhdQchGRFSdxCSESF1ByEZEVJ3EJIRIXUHIRkRUncQ\nkhEhdQchGRFSdxCSESF1ByEZEVJ3EJIRIXUHIRkRUncQkhEhdQchGRFSdxCSESF1ByEZEVJ3\nEJIRIXUHIRkRUncQkhEhdQchGRFSdxCSESF1ByEZEVJ3EJIRIXUHIRkRUncQkhEhdQchGRFS\ndxCSESF1ByEZEVJ3EJIRIXUHIRkRUncQkhEhdQchGRFSdxCSkSWk93SSfFcRQjIipDTyXUUI\nyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmN\nfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEk\no+FDuv/jK959xo9K2XTB0cvPXrfvk5DcCMlo6JCmjv/M5q1fOmy8nHP62gfPP3HHPk9CciMk\no6FD2jB2Zynrx37y6JJ7+r8LHbRm9pOQ5LuKEJLR8F/anXbh+JavHLft2mVT/R+cdMnsZ//N\nEw/0Pbo+5j55jSFeuNbj5Qn3CCO0rWxwjzDThqFDeuzEsbGVd5fVxwx+cOZFs5/9N1cv7rs+\n+K8ZcJ+8xhAvHJ21+3ubKKSJ//GZDZsvXbF+9bGDH/UDmvXsv7n99L47t8bcJ68xxAvX2l4m\n3COM0GTZ5h5hL8OG9IMlW/pv/9s/XbfzS7lLZz+f/Di+R7LheySjob9Hunlsc//tyn96bMld\npWxcevvsJyHJdxUhJKOhQ9q88jObtv39sofKuSevfeCsU6b2eRKSGyEZDf+ndveeveKIv7i1\nX9SFK1esWr/vk5DcCMmIf0QojXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxX\nEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNC\nSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1F\nCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgp\njXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUh\nJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ0\n8l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQ\njAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLI\ndxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIy\nIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPf\nVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmI\nkNLIdxUhJCNCSiPfVYSQjAgpjXxXEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjAgpjXxX\nEUIyIqQ08l1FCMmIkNLIdxUhJCNCSiPfVYSQjNJD2joE98lrDPPKpbaXCfcIIzRZtrlH2Et2\nSJs2xNwnrzHEC9faXLa4Rxih7WXcPcJM49kh8aWdDV/aGfE9Uhr5riKEZERIaeS7ihCSESGl\nke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKE\nZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRG\nvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCS\nESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5\nriKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhG\nhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7\nihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkR\nUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8q\nQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERI\naeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsI\nIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGl\nke8qQkhGhJRGvqsIIRkRUhr5riKEZERIaeS7ihCSESGlke8qQkhGTyOkK447+KQbStl0wdHL\nz16375OQ3AjJaPiQvrvyxnXfOH5zOef0tQ+ef+KOfZ6E5EZIRsOHdPxV049Hl9zT/13ooDWz\nn4Qk31WEkIyGDunnY1d98NBT7yzXLpvq/+ikS2Y/+28mNvat/3nMffIaQ7xwrfGy2T3CCG0t\nv3CPMNMvhg3pJ2P/8/7xi47YsPqYwY/OvGj2s//m6sV91we/sQ24T15jiBeOztr9vU0cUv+r\nt8n3fHf1sYMf9QOa9ey/WfOBvtu2x9wnrzHEC9eaLJPuEUZoR5lwjzDTtmFDenTsrv7bEy+9\nbueXcvs8n/w4vkey4Xsko6G/R9qx8rJSth1+zWNL+kFtXHr77CchyXcVISSj4f/U7tIVtzz6\n6ZVbyrknr33grFOm9nkSkhshGQ0f0o4vHHXwGfeVsvnClStWrd/3SUhuhGTEPyKURr6rCCEZ\nEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHv\nKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRE\nSGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6r\nCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEh\npZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4i\nhGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSU\nRr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQ\nkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa\n+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJI\nRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnk\nu4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZ\nEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHv\nKkJIRukhbRmC++Q1hnnlUtvLhHuEEZosW90j7CU7pMfHY+6T1xjihWs9Uba6Rxih7UOd2shs\nyg6JL+1s+NLOiO+R0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JK\nI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUI\nyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmN\nfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEk\nI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTy\nXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCM\nCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3\nFSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIi\npDTyXUUIyWiOkBbfsfP59d8jpGHJdxUhJKM5QurdOP2YOPt5hDQs+a4ihGT0lCH19vh9QhqW\nfFcRQjJ6ypDWfKq39L0Dx330fkIalnxXEUIymuNLu3f99OkGREjyXUUIyYg/tUsj31WEkIzm\nCGnd0a969s5vkghpWPJdRQjJaI6QDvuVA4+e/i7pvYQ0LPmuIoRkNEdIL/7G0w2IkOS7ihCS\n0Rwh7fcIIT1d8l1FCMlojpDe9n8J6emS7ypCSEZzhHTTm64lpKdJvqsIIRnNEdIBr+nt99pp\nhDQs+a4ihGQ015d2Bz6JkIYl31WEkIz4C9k08l1FCMmIkNLIdxUhJKO5/h7pSS8ipGHJdxUh\nJKM5Qlo67U0v2P9EQhqWfFcRQjL65V/aPfz2ywlpWPJdRQjJKPge6cbFhDQs+a4ihGQUhPTw\nCwhpWPJdRQjJ6JeHNPWJVxPSsOS7ihCS0Rwh/edp+7+k9+eENCz5riKEZPRLQ3rDOz+1jZCG\nJd9VhJCM+AvZNPJdRQjJaM6Qfn75RZ9fPU5Iw5PvKkJIRnOEtOPU5w7+hQ2LziOkocl3FSEk\nozlCOq938MXfuvxz7+p9YebPfnfs+6VsuuDo5Wev2/dJSG6EZDRHSL93ys7n+2b+m1Z/cdSy\nfkjnnL72wfNP3LHPk5DcCMlojpCef9XO5xUz/0L23IuP+n55dMk9/d+FDloz+0lI8l1FCMlo\njpAWXbbz+Y0X7vm5a4/b0g/p2mVT/fdPumT2k5Dku4oQktEcIf3RH0//BdKWP3nH7p/atPKW\n0g9p9TGDH5x50exn/83Vi/uuLzH3yWsM8cLRWbu/t9k7pCue9RvvP+fjx7/q2Vfu/qlPfrJM\nh3Ts4Af9gGY9+29uPLLvhxMx98lrDPHCtSbLDvcIIzRVJt0jzLT9qUMq//i7gz/+ft0Vu3/i\nlpXj0yFdt/NLuUtnP5/8OL60s+FLO6O5/8mGB2+48d9m/PC8ZcuXL19y+KrHltxVysalt89+\nEpJ8VxFCMporpIc/3X/zyIy/HxoffPSR39lYzj157QNnnTK1z5OQ3AjJaI6QfvyKwf/n5b29\nV9yzV179L+3K5gtXrli1ft8nIbkRktEcIR302zcMHnf89iHlaSIkG0IymiOkl/71zufn+LcI\nDU2+qwghGc0R0gu+tPP55f0IaVjyXUUIyWiOkN76rsnBY/yNBxDSsOS7ihCS0RwhrX7Wb514\n1kePfemzVxPSsOS7ihCS0Vx//P2dxYO/kH39FbM7IaQ5yXcVISSjuf9C9ue3/qjifyBLSD6E\nZMS/syGNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ\n0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcR\nQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JK\nI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUI\nyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmN\nfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEk\nI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTy\nXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCM\nCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3\nFSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIi\npDTyXUUIyYiQ0sh3FSEkI0JKI99VhJCMCCmNfFcRQjIipDTyXUUIyYiQ0sh3FSEkI0JKI99V\nhJCMCCmNfFcRQjJKD+mJIbhPXmOYVy61rWx3jzBCk2WLe4S9ZIf0+HjMffIaQ7xwrSfKVvcI\nI7R9qFMbmU3ZIfGlnQ1f2hnxPVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa\n+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJI\nRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnk\nu4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZ\nEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHv\nKkJIRoSURr6rCCEZEVIa+a4ihGRESGnku4oQkhEhpZHvKkJIRoSURr6rCCEZEVIa+a4ihGRE\nSGl4tSNFSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2W\ney6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2d\nlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0it\nnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENI\nrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xD\nSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBus\nQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQb\nrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3E\nG6xDSK2dlnsujcQbrENIrZ2Wey6NxBuss2BDeuz8Iw8/4yelbLrg6OVnr9v3SUi82lFasCF9\n6PR7HvrLFVvKOaevffD8E3fs8yQkXu0oLdSQxlfdV8ojYz99dMk9/d+FDloz+0lIvNqRWqgh\nTbtz6fprl0313znpktlPQuLVjtRCDmn8hL8pq48ZvHfmRbOf/Tf/74/7bpqKuY9Ag1c7UqW4\nJ9jL5NMI6f73/dVUWX3sroBmPftvbjyy74cTMfcRaPBqR2qqTLpHmGn78CGtWX5Z/+11O7+U\nu3T288mP4ku7tl/tyCzYL+1+9J6bBo/HltxVysalt89+EhKvdqQWakjbjv/q4OO3lHNPXvvA\nWadM7fMkJF7tKC3UkNaMTbu8bL5w5YpV/U+b/SQkXu0oLdSQhkVIbb/akSGk1k7LPZdG4g3W\nIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN\n1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0bi\nDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG\n4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2X\nRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9\nl0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7L\nPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZO\nyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTW\nTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk\n1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYh\npNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3W\nIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN\n1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0bi\nDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG\n4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2X\nRuIN1iGk1k7LPZdG4g3WIaTWTss9l0biDdYhpNZOyz2XRuIN1iGk1k7LPZdG4g3W6XpImx+P\nuY9Ag1c7UhPlCfcIM21OD2lTzH0EGrzakZoY6tRG5vHskPjSru1XOzJd/9KOkNp+tSNDSK2d\nlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0it\nnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENI\nrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xD\nSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBus\nQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQb\nrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3E\nG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6N\nxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsu\njcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7\nLo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2W\ney6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2d\nlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0it\nnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENI\nrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xD\nSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBus\nQ0itnZZ7Lo3EG6xDSK2dlnsujcQbrENIrZ2Wey6NxBusQ0itnZZ7Lo3EG6zTuZA2XXD08rPX\nERIhNfdic0M658TXDcgAAAeRSURBVPS1D55/4g5C4tW29mJTQ3p0yT3935UOWkNIvNrWXmxq\nSNcum+q/PekSQuLVtvZiU0Nafczg7ZkX9d98f0nfLZMx96+LBq+2tRc708QzDunYpx/S6JQp\n9wQjtKPscI8wQlPFPcFennFI1+380u7SJ388zJd2o1O2uycYofHyuHuEEeraH38/tuSuUjYu\nvZ2Q7AjJ6Jn/8fe5J6994KxTpgjJjpCMnnlImy9cuWLVnv8aQrIhJCPLPyI0OoTUWYQ0SoTU\nWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTU\nWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTU\nWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTUWYQ0SoTU\nWYQ0SoTUWV0PaV6Z/MQX3SOM0B2fuM49wgh98xOPuUd4al0Mafvi490jjNCVi//OPcIIfWTx\nv7pHeGqEtNAR0rxASAsdIc0LhLTQEdK80MWQgJEjJCABIQEJuhLS5NjN7hHM2vgVmBxb4x7h\nqRFSV7TxKzB16yb3CE+NkLqCXwGr7oT0z6cv+8B1pfzivJXLTrujTI1d9eH3nnDPxf995d+7\nR8uzY+zb7/1kWX/eykPPuLuUtR9cdvKtYz/bMnZrKQ+NPTQI6d6PvOfdH31o18d1xfSr2fMq\n18zP1XYnpPffsfkrB60rp35sw9aL372xLD19y44zjri23Lx0g3u2PEs/dPcT5dTzxrf93ZHb\npo69YPPPPjR278yQ3n/hls3nnrbr4zpj8GpmhDQ/V9udkL5WyvZDv3XP2H2lbDvs6rL0W6X8\n7bGlbBn7sXu2PEsvKeXusfX9bxWOuObOsX8r5cq9Q9q0tZRrD5qa/rjuGLyavUKaj6vtTkjf\n67993xe/t2Sq/zzha2Xp9aV85dTBf3Cre7Y8S68p5ZqxaZdes7T/StfuHdIPP3zUUUeMTU5/\nXHcMXs1eIc3H1XYnpBv6b9//1Z0hfeBLZekN8/BX+5la+v1SrhvbNv3+vxzSf3PvrpAemA7p\noUMu3db/zyenP647Bq9mz6tcMz9X252Q/rGUicOuXDv2r/1f9WVXzc9f7WdqcFL3TX9B83C5\ndeyxUq4au3dyyc2l3Dwd0jVLJ0v5QidD2vMqCUlqcuyEeycuXTZeTjtrfMtnj9w8P3+1n6np\nQM487ZHJbx362MSKz26777Sxe8v7/rps/fh0SD8eu337v5wx9kgHQ9rzKglJatvYVactO+Gm\nUh75X0euOPuBMj9/tZ+p6ZNa/7/fffhpt5dy20mHnb5m7L5yy58d/xc3jd0/+B7pb96z/NOb\nPnTEug6GtPtVEhJyTU6UcufYZvcYmEZIC9XU+z75+PqPneEeAzsR0oL1szMPW7HqUfcU2ImQ\ngASEBCQgJCABIQEJCAlIQEgLxR/+ztAfesDwH4okhLQA3DLY0oWrhv54Qho9QloAPv00t0RI\no0dI89ABb7vs1W8p5atvfMGLFn+1lHf1er3F01/ave2PfvDOF730iHWl7PjYq5//+9856bl7\nfd533v7Clx92166Qnvzs8tBxv/H8lx9y54x3kI+Q5qF3vv53/8/l5Wu9gy+//E97l5efLu3d\neMd0SAe+5o1Xrvv6c44u5RO9w7/9+Ve+adHMT/vOs/7kSxf/1isfng5p92eXN7/i81d/+XUv\n27znHeQjpHnowN4/9N+ueue2Ujb+yopS3jvY0nRIvcH/DvjAV5Wpl+8/Vcp1vUUzP+0PfnOi\nlOuf96npkHZ/9sbe4J/Hu3vVg7vfGf0LagAhzUMHPm/77vdf/baZIe03+Kmjn10e6n1o8N7+\ni2Z81s97J+x6b8/3SP3P3v7i1353x+D93e9AgJDmof5vOX0bP7L/rz7nOb0DZob02sF/0P/h\nLb3zBu8tWzTjs27rnbXrvUFIez77e7/Ze/GyL0/MeAf5CGke2tnL25/z4Wtuve1VTxnSdb2/\nHLx36KIZn/Wj3kd3vTcIac9nl8mr/vw/9f7giRnvIB0hzUPTvdzVG/y/PE38u6cM6ae90wbv\nvW7RjM8a7x07eNz7yCCkGZ897a96fzvrHaQipHloupc7emeXwV8hvbmU43oTs0Ka+LX9++/c\nsPcfNrzupeOl3Nn/Aq8f0p7Pvund6/rv3d07f/c7I341bSCkeWi6l+2v+fff/N6p73jHi65+\n/KO9s7++d0jllN4x3/7cfzhg0cxPu/zZf/iVi/7jy6b/+HvPZ9/9otdffOXX3vqrdz/85DuO\nl9R5hDQP7ezlxrfs9/I/23jZS379J/e/4bm/MyukrR98yaK3Xb/8hXt93hVv3u9lB/905/dI\nez77hwe/7LmvOvgHpex+B/kIaSE78JXuCbALIS1MFx7S/7bpF7/2X9xzYBdCWpi+2Puv37zk\nLc/6rnsO7EJIC9QX37Bov7deUf65t9tn3SM1jZAWtk237bbePUvTCAlIQEhAAkICEhASkICQ\ngASEBCQgJCDB/wcn/DvcSzn5GgAAAABJRU5ErkJggg=="
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "type.Freq <- data.frame(table(dados_2$Type))\n",
        "type.Freq"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.681256Z",
          "iopub.execute_input": "2024-04-14T16:57:27.682749Z",
          "iopub.status.idle": "2024-04-14T16:57:27.706329Z"
        },
        "trusted": true,
        "id": "GRfXPgAIk-je",
        "outputId": "9fd54854-d7c7-4052-eead-24d96840f474",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 178
        }
      },
      "execution_count": 31,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 2 × 2</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>Var1</th><th scope=col>Freq</th></tr>\n",
              "\t<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td>Free</td><td>10039</td></tr>\n",
              "\t<tr><td>Paid</td><td>  800</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 2 × 2\n\n| Var1 &lt;fct&gt; | Freq &lt;int&gt; |\n|---|---|\n| Free | 10039 |\n| Paid |   800 |\n\n",
            "text/latex": "A data.frame: 2 × 2\n\\begin{tabular}{ll}\n Var1 & Freq\\\\\n <fct> & <int>\\\\\n\\hline\n\t Free & 10039\\\\\n\t Paid &   800\\\\\n\\end{tabular}\n",
            "text/plain": [
              "  Var1 Freq \n",
              "1 Free 10039\n",
              "2 Paid   800"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "type.Plot <- ggplot(type.Freq) + geom_bar(aes(x = \"\", y = Freq, fill = Var1), stat = \"identity\", width = 1) + coord_polar(theta = \"y\", start = 0)\n",
        "type.Plot"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:27.709134Z",
          "iopub.execute_input": "2024-04-14T16:57:27.710587Z",
          "iopub.status.idle": "2024-04-14T16:57:28.032134Z"
        },
        "trusted": true,
        "id": "bd7jhCcuk-je",
        "outputId": "a2e2292e-a3ec-4565-8949-6b1a427138b0",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 32,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAAC1lBMVEUAAAAAv8QBAQECAgID\nAwMEBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUW\nFhYXFxcYGBgZGRkaGhobGxscHBwdHR0fHx8gICAiIiIjIyMkJCQlJSUmJiYnJycoKCgqKios\nLCwtLS0uLi4wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9PT0+Pj5A\nQEBBQUFCQkJDQ0NERERFRUVGRkZISEhNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZX\nV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVnZ2doaGhpaWlq\nampra2tsbGxtbW1ubm5vb29wcHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8\nfHx9fX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eIiIiKioqLi4uMjIyNjY2Ojo6P\nj4+QkJCRkZGSkpKTk5OUlJSVlZWWlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKCh\noaGioqKjo6OlpaWmpqanp6eoqKipqamrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1\ntbW2tra3t7e4uLi5ubm6urq7u7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbH\nx8fIyMjJycnKysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ\n2dna2trb29vc3Nzd3d3e3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr\n6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb39/f4dm34+Pj5+fn6+vr7+/v8\n/Pz9/f3+/v7///8DkPpWAAAACXBIWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3d+8MtV13f\n8S2NQeQmarUqarXVKlVaL1BB0DYnMeHSJJATtZiQFFqsxCamHBRDgGrRqq3UgkUIjaAEK6BR\nI4aLIQE8AXI8gSQkEpPZ9+vZ9/kPOrP3c937+zzru2bWd33XzHxeP/DkkHNOnmev9d4zs+ay\n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"
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "str(dados_2)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.035761Z",
          "iopub.execute_input": "2024-04-14T16:57:28.037452Z",
          "iopub.status.idle": "2024-04-14T16:57:28.072079Z"
        },
        "trusted": true,
        "id": "2eNf38e-k-je",
        "outputId": "967ede17-9b89-4070-bc82-c584292d683d",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 33,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "'data.frame':\t10840 obs. of  15 variables:\n",
            " $ App           : chr  \"Photo Editor & Candy Camera & Grid & ScrapBook\" \"Coloring book moana\" \"U Launcher Lite – FREE Live Cool Themes, Hide Apps\" \"Sketch - Draw & Paint\" ...\n",
            " $ Category      : chr  \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" \"ART_AND_DESIGN\" ...\n",
            " $ Rating        : num  4.1 3.9 4.7 4.5 4.3 4.4 3.8 4.1 4.4 4.7 ...\n",
            " $ Reviews       : chr  \"159\" \"967\" \"87510\" \"215644\" ...\n",
            " $ Size          : chr  \"19M\" \"14M\" \"8.7M\" \"25M\" ...\n",
            " $ Installs      : chr  \"10,000+\" \"500,000+\" \"5,000,000+\" \"50,000,000+\" ...\n",
            " $ Type          : chr  \"Free\" \"Free\" \"Free\" \"Free\" ...\n",
            " $ Price         : chr  \"0\" \"0\" \"0\" \"0\" ...\n",
            " $ Content.Rating: chr  \"Everyone\" \"Everyone\" \"Everyone\" \"Teen\" ...\n",
            " $ Genres        : chr  \"Art & Design\" \"Art & Design;Pretend Play\" \"Art & Design\" \"Art & Design\" ...\n",
            " $ Last.Updated  : chr  \"January 7, 2018\" \"January 15, 2018\" \"August 1, 2018\" \"June 8, 2018\" ...\n",
            " $ Current.Ver   : chr  \"1.0.0\" \"2.0.0\" \"1.2.4\" \"Varies with device\" ...\n",
            " $ Android.Ver   : chr  \"4.0.3 and up\" \"4.0.3 and up\" \"4.0.3 and up\" \"4.2 and up\" ...\n",
            " $ newRating     : num  4.1 3.9 4.7 4.5 4.3 4.4 3.8 4.1 4.4 4.7 ...\n",
            " $ rating_class  : chr  \"bom\" \"regular\" \"bom\" \"bom\" ...\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "freq.Size <- data.frame(table(dados_2$Size))\n",
        "freq.Size"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.074835Z",
          "iopub.execute_input": "2024-04-14T16:57:28.076324Z",
          "iopub.status.idle": "2024-04-14T16:57:28.130441Z"
        },
        "trusted": true,
        "id": "-pRDauaLk-jf",
        "outputId": "80da7f48-7c84-4005-e868-12ff04be9a80",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 34,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 461 × 2</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>Var1</th><th scope=col>Freq</th></tr>\n",
              "\t<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td>1.0M </td><td>  7</td></tr>\n",
              "\t<tr><td>1.1M </td><td> 32</td></tr>\n",
              "\t<tr><td>1.2M </td><td> 41</td></tr>\n",
              "\t<tr><td>1.3M </td><td> 35</td></tr>\n",
              "\t<tr><td>1.4M </td><td> 37</td></tr>\n",
              "\t<tr><td>1.5M </td><td> 48</td></tr>\n",
              "\t<tr><td>1.6M </td><td> 39</td></tr>\n",
              "\t<tr><td>1.7M </td><td> 40</td></tr>\n",
              "\t<tr><td>1.8M </td><td> 50</td></tr>\n",
              "\t<tr><td>1.9M </td><td> 32</td></tr>\n",
              "\t<tr><td>10.0M</td><td> 10</td></tr>\n",
              "\t<tr><td>100M </td><td> 16</td></tr>\n",
              "\t<tr><td>1020k</td><td>  1</td></tr>\n",
              "\t<tr><td>103k </td><td>  1</td></tr>\n",
              "\t<tr><td>108k </td><td>  1</td></tr>\n",
              "\t<tr><td>10M  </td><td>136</td></tr>\n",
              "\t<tr><td>116k </td><td>  1</td></tr>\n",
              "\t<tr><td>118k </td><td>  3</td></tr>\n",
              "\t<tr><td>11k  </td><td>  1</td></tr>\n",
              "\t<tr><td>11M  </td><td>198</td></tr>\n",
              "\t<tr><td>121k </td><td>  1</td></tr>\n",
              "\t<tr><td>122k </td><td>  1</td></tr>\n",
              "\t<tr><td>12M  </td><td>196</td></tr>\n",
              "\t<tr><td>13M  </td><td>191</td></tr>\n",
              "\t<tr><td>141k </td><td>  2</td></tr>\n",
              "\t<tr><td>143k </td><td>  1</td></tr>\n",
              "\t<tr><td>144k </td><td>  1</td></tr>\n",
              "\t<tr><td>14k  </td><td>  1</td></tr>\n",
              "\t<tr><td>14M  </td><td>194</td></tr>\n",
              "\t<tr><td>153k </td><td>  1</td></tr>\n",
              "\t<tr><td>⋮</td><td>⋮</td></tr>\n",
              "\t<tr><td>939k              </td><td>   1</td></tr>\n",
              "\t<tr><td>93k               </td><td>   1</td></tr>\n",
              "\t<tr><td>93M               </td><td>  16</td></tr>\n",
              "\t<tr><td>940k              </td><td>   1</td></tr>\n",
              "\t<tr><td>942k              </td><td>   1</td></tr>\n",
              "\t<tr><td>948k              </td><td>   2</td></tr>\n",
              "\t<tr><td>94M               </td><td>  17</td></tr>\n",
              "\t<tr><td>951k              </td><td>   1</td></tr>\n",
              "\t<tr><td>953k              </td><td>   1</td></tr>\n",
              "\t<tr><td>954k              </td><td>   1</td></tr>\n",
              "\t<tr><td>957k              </td><td>   2</td></tr>\n",
              "\t<tr><td>95M               </td><td>  18</td></tr>\n",
              "\t<tr><td>961k              </td><td>   1</td></tr>\n",
              "\t<tr><td>963k              </td><td>   1</td></tr>\n",
              "\t<tr><td>965k              </td><td>   1</td></tr>\n",
              "\t<tr><td>96M               </td><td>  26</td></tr>\n",
              "\t<tr><td>970k              </td><td>   1</td></tr>\n",
              "\t<tr><td>975k              </td><td>   1</td></tr>\n",
              "\t<tr><td>976k              </td><td>   1</td></tr>\n",
              "\t<tr><td>97k               </td><td>   1</td></tr>\n",
              "\t<tr><td>97M               </td><td>  20</td></tr>\n",
              "\t<tr><td>980k              </td><td>   1</td></tr>\n",
              "\t<tr><td>981k              </td><td>   1</td></tr>\n",
              "\t<tr><td>982k              </td><td>   1</td></tr>\n",
              "\t<tr><td>986k              </td><td>   1</td></tr>\n",
              "\t<tr><td>98M               </td><td>  16</td></tr>\n",
              "\t<tr><td>992k              </td><td>   1</td></tr>\n",
              "\t<tr><td>994k              </td><td>   1</td></tr>\n",
              "\t<tr><td>99M               </td><td>  39</td></tr>\n",
              "\t<tr><td>Varies with device</td><td>1695</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 461 × 2\n\n| Var1 &lt;fct&gt; | Freq &lt;int&gt; |\n|---|---|\n| 1.0M  |   7 |\n| 1.1M  |  32 |\n| 1.2M  |  41 |\n| 1.3M  |  35 |\n| 1.4M  |  37 |\n| 1.5M  |  48 |\n| 1.6M  |  39 |\n| 1.7M  |  40 |\n| 1.8M  |  50 |\n| 1.9M  |  32 |\n| 10.0M |  10 |\n| 100M  |  16 |\n| 1020k |   1 |\n| 103k  |   1 |\n| 108k  |   1 |\n| 10M   | 136 |\n| 116k  |   1 |\n| 118k  |   3 |\n| 11k   |   1 |\n| 11M   | 198 |\n| 121k  |   1 |\n| 122k  |   1 |\n| 12M   | 196 |\n| 13M   | 191 |\n| 141k  |   2 |\n| 143k  |   1 |\n| 144k  |   1 |\n| 14k   |   1 |\n| 14M   | 194 |\n| 153k  |   1 |\n| ⋮ | ⋮ |\n| 939k               |    1 |\n| 93k                |    1 |\n| 93M                |   16 |\n| 940k               |    1 |\n| 942k               |    1 |\n| 948k               |    2 |\n| 94M                |   17 |\n| 951k               |    1 |\n| 953k               |    1 |\n| 954k               |    1 |\n| 957k               |    2 |\n| 95M                |   18 |\n| 961k               |    1 |\n| 963k               |    1 |\n| 965k               |    1 |\n| 96M                |   26 |\n| 970k               |    1 |\n| 975k               |    1 |\n| 976k               |    1 |\n| 97k                |    1 |\n| 97M                |   20 |\n| 980k               |    1 |\n| 981k               |    1 |\n| 982k               |    1 |\n| 986k               |    1 |\n| 98M                |   16 |\n| 992k               |    1 |\n| 994k               |    1 |\n| 99M                |   39 |\n| Varies with device | 1695 |\n\n",
            "text/latex": "A data.frame: 461 × 2\n\\begin{tabular}{ll}\n Var1 & Freq\\\\\n <fct> & <int>\\\\\n\\hline\n\t 1.0M  &   7\\\\\n\t 1.1M  &  32\\\\\n\t 1.2M  &  41\\\\\n\t 1.3M  &  35\\\\\n\t 1.4M  &  37\\\\\n\t 1.5M  &  48\\\\\n\t 1.6M  &  39\\\\\n\t 1.7M  &  40\\\\\n\t 1.8M  &  50\\\\\n\t 1.9M  &  32\\\\\n\t 10.0M &  10\\\\\n\t 100M  &  16\\\\\n\t 1020k &   1\\\\\n\t 103k  &   1\\\\\n\t 108k  &   1\\\\\n\t 10M   & 136\\\\\n\t 116k  &   1\\\\\n\t 118k  &   3\\\\\n\t 11k   &   1\\\\\n\t 11M   & 198\\\\\n\t 121k  &   1\\\\\n\t 122k  &   1\\\\\n\t 12M   & 196\\\\\n\t 13M   & 191\\\\\n\t 141k  &   2\\\\\n\t 143k  &   1\\\\\n\t 144k  &   1\\\\\n\t 14k   &   1\\\\\n\t 14M   & 194\\\\\n\t 153k  &   1\\\\\n\t ⋮ & ⋮\\\\\n\t 939k               &    1\\\\\n\t 93k                &    1\\\\\n\t 93M                &   16\\\\\n\t 940k               &    1\\\\\n\t 942k               &    1\\\\\n\t 948k               &    2\\\\\n\t 94M                &   17\\\\\n\t 951k               &    1\\\\\n\t 953k               &    1\\\\\n\t 954k               &    1\\\\\n\t 957k               &    2\\\\\n\t 95M                &   18\\\\\n\t 961k               &    1\\\\\n\t 963k               &    1\\\\\n\t 965k               &    1\\\\\n\t 96M                &   26\\\\\n\t 970k               &    1\\\\\n\t 975k               &    1\\\\\n\t 976k               &    1\\\\\n\t 97k                &    1\\\\\n\t 97M                &   20\\\\\n\t 980k               &    1\\\\\n\t 981k               &    1\\\\\n\t 982k               &    1\\\\\n\t 986k               &    1\\\\\n\t 98M                &   16\\\\\n\t 992k               &    1\\\\\n\t 994k               &    1\\\\\n\t 99M                &   39\\\\\n\t Varies with device & 1695\\\\\n\\end{tabular}\n",
            "text/plain": [
              "    Var1               Freq\n",
              "1   1.0M                 7 \n",
              "2   1.1M                32 \n",
              "3   1.2M                41 \n",
              "4   1.3M                35 \n",
              "5   1.4M                37 \n",
              "6   1.5M                48 \n",
              "7   1.6M                39 \n",
              "8   1.7M                40 \n",
              "9   1.8M                50 \n",
              "10  1.9M                32 \n",
              "11  10.0M               10 \n",
              "12  100M                16 \n",
              "13  1020k                1 \n",
              "14  103k                 1 \n",
              "15  108k                 1 \n",
              "16  10M                136 \n",
              "17  116k                 1 \n",
              "18  118k                 3 \n",
              "19  11k                  1 \n",
              "20  11M                198 \n",
              "21  121k                 1 \n",
              "22  122k                 1 \n",
              "23  12M                196 \n",
              "24  13M                191 \n",
              "25  141k                 2 \n",
              "26  143k                 1 \n",
              "27  144k                 1 \n",
              "28  14k                  1 \n",
              "29  14M                194 \n",
              "30  153k                 1 \n",
              "⋮   ⋮                  ⋮   \n",
              "432 939k                  1\n",
              "433 93k                   1\n",
              "434 93M                  16\n",
              "435 940k                  1\n",
              "436 942k                  1\n",
              "437 948k                  2\n",
              "438 94M                  17\n",
              "439 951k                  1\n",
              "440 953k                  1\n",
              "441 954k                  1\n",
              "442 957k                  2\n",
              "443 95M                  18\n",
              "444 961k                  1\n",
              "445 963k                  1\n",
              "446 965k                  1\n",
              "447 96M                  26\n",
              "448 970k                  1\n",
              "449 975k                  1\n",
              "450 976k                  1\n",
              "451 97k                   1\n",
              "452 97M                  20\n",
              "453 980k                  1\n",
              "454 981k                  1\n",
              "455 982k                  1\n",
              "456 986k                  1\n",
              "457 98M                  16\n",
              "458 992k                  1\n",
              "459 994k                  1\n",
              "460 99M                  39\n",
              "461 Varies with device 1695"
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "teste <- dados_2$Size[1]\n",
        "teste"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.133216Z",
          "iopub.execute_input": "2024-04-14T16:57:28.134693Z",
          "iopub.status.idle": "2024-04-14T16:57:28.152904Z"
        },
        "trusted": true,
        "id": "OBV8tMnQk-jf",
        "outputId": "c26fca9e-40ca-49f0-ef6b-bad35560ac0e",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 34
        }
      },
      "execution_count": 35,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "'19M'"
            ],
            "text/markdown": "'19M'",
            "text/latex": "'19M'",
            "text/plain": [
              "[1] \"19M\""
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "markdown",
      "source": [
        "Verificar ocorrencia de K ou M nos registros e os substituir pelo seu valor"
      ],
      "metadata": {
        "id": "ysA0G-Gck-jf"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2$kb <- sapply(X = dados_2$Size, FUN = function(y){\n",
        "    if(grepl(\"M\", y, ignore.case = T)){\n",
        "        y <-  as.numeric(gsub(pattern = \"M\", replacement = \"\", x = y))*1024\n",
        "    }else if(grepl(\"k|\\\\+\", y, ignore.case = T)){\n",
        "        y <- gsub(pattern = \"k|\\\\+\", replacement = \"\", x = y)\n",
        "    }else{\n",
        "        y <- \"nd\"\n",
        "    }\n",
        "})"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.155588Z",
          "iopub.execute_input": "2024-04-14T16:57:28.157047Z",
          "iopub.status.idle": "2024-04-14T16:57:28.35365Z"
        },
        "trusted": true,
        "id": "5OkZmafkk-jg"
      },
      "execution_count": 36,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "dados_2"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.356495Z",
          "iopub.execute_input": "2024-04-14T16:57:28.358033Z",
          "iopub.status.idle": "2024-04-14T16:57:28.53306Z"
        },
        "trusted": true,
        "id": "lx0PKMZTk-jg",
        "outputId": "601cc6e8-c7b1-4dac-db0e-a035ca052264",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 1000
        }
      },
      "execution_count": 37,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/html": [
              "<table class=\"dataframe\">\n",
              "<caption>A data.frame: 10840 × 16</caption>\n",
              "<thead>\n",
              "\t<tr><th scope=col>App</th><th scope=col>Category</th><th scope=col>Rating</th><th scope=col>Reviews</th><th scope=col>Size</th><th scope=col>Installs</th><th scope=col>Type</th><th scope=col>Price</th><th scope=col>Content.Rating</th><th scope=col>Genres</th><th scope=col>Last.Updated</th><th scope=col>Current.Ver</th><th scope=col>Android.Ver</th><th scope=col>newRating</th><th scope=col>rating_class</th><th scope=col>kb</th></tr>\n",
              "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook    </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>159   </span></td><td>19M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>January 7, 2018   </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td>4.0.3 and up</td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>19456 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Coloring book moana                               </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>967   </span></td><td>14M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Pretend Play      </span></td><td><span style=white-space:pre-wrap>January 15, 2018  </span></td><td><span style=white-space:pre-wrap>2.0.0             </span></td><td>4.0.3 and up</td><td>3.900000</td><td>regular</td><td>14336 </td></tr>\n",
              "\t<tr><td>U Launcher Lite – FREE Live Cool Themes, Hide Apps</td><td>ART_AND_DESIGN</td><td>4.7</td><td>87510 </td><td>8.7M</td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 1, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.4             </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>8908.8</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Sketch - Draw &amp; Paint                             </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td>215644</td><td>25M </td><td>50,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 8, 2018      </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>25600 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pixel Draw - Number Art Coloring Book             </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td><span style=white-space:pre-wrap>967   </span></td><td>2.8M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>June 20, 2018     </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td><td>4.300000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>2867.2</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Paper flowers instructions                        </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>167   </span></td><td>5.6M</td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 26, 2017    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>5734.4</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Smoke Effect Photo Maker - Smoke Editor           </span></td><td>ART_AND_DESIGN</td><td>3.8</td><td><span style=white-space:pre-wrap>178   </span></td><td>19M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 26, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td><td>3.800000</td><td>regular</td><td>19456 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Infinite Painter                                  </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td>36815 </td><td>29M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 14, 2018     </span></td><td><span style=white-space:pre-wrap>6.1.61.1          </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>29696 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Garden Coloring Book                              </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13791 </td><td>33M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td>September 20, 2017</td><td><span style=white-space:pre-wrap>2.9.2             </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>33792 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Kids Paint Free - Drawing Fun                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>121   </span></td><td>3.1M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>July 3, 2018      </span></td><td><span style=white-space:pre-wrap>2.8               </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>3174.4</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Text on Photo - Fonteee                           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td>13880 </td><td>28M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>October 27, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>28672 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Name Art Photo Editor - Focus n Filters           </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>8788  </span></td><td>12M </td><td>1,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.15            </span></td><td><span style=white-space:pre-wrap>4.0 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>12288 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Tattoo Name On My Photo Editor                    </span></td><td>ART_AND_DESIGN</td><td>4.2</td><td>44829 </td><td>20M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen        </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 2, 2018     </span></td><td><span style=white-space:pre-wrap>3.8               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.200000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>20480 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mandala Coloring Book                             </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td><span style=white-space:pre-wrap>4326  </span></td><td>21M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 26, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.4             </span></td><td><span style=white-space:pre-wrap>4.4 and up  </span></td><td>4.600000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>21504 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>3D Color Pixel by Number - Sandbox Art Coloring   </span></td><td>ART_AND_DESIGN</td><td>4.4</td><td><span style=white-space:pre-wrap>1518  </span></td><td>37M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>1.2.3             </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.400000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>37888 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Learn To Draw Kawaii Characters                   </span></td><td>ART_AND_DESIGN</td><td>3.2</td><td><span style=white-space:pre-wrap>55    </span></td><td>2.7M</td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>June 6, 2018      </span></td><td><span style=white-space:pre-wrap>NaN               </span></td><td><span style=white-space:pre-wrap>4.2 and up  </span></td><td>3.200000</td><td>regular</td><td>2764.8</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Photo Designer - Write your name with shapes      </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>3632  </span></td><td>5.5M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 31, 2018     </span></td><td><span style=white-space:pre-wrap>3.1               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td><td><span style=white-space:pre-wrap>5632  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>350 Diy Room Decor Ideas                          </span></td><td>ART_AND_DESIGN</td><td>4.5</td><td><span style=white-space:pre-wrap>27    </span></td><td>17M </td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>November 7, 2017  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>17408 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FlipaClip - Cartoon animation                     </span></td><td>ART_AND_DESIGN</td><td>4.3</td><td>194216</td><td>39M </td><td>5,000,000+ </td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 3, 2018    </span></td><td><span style=white-space:pre-wrap>2.2.5             </span></td><td>4.0.3 and up</td><td>4.300000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>39936 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>ibis Paint X                                      </span></td><td>ART_AND_DESIGN</td><td>4.6</td><td>224399</td><td>31M </td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 30, 2018     </span></td><td><span style=white-space:pre-wrap>5.5.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.600000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>31744 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Logo Maker - Small Business                       </span></td><td>ART_AND_DESIGN</td><td>4.0</td><td><span style=white-space:pre-wrap>450   </span></td><td>14M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 20, 2018    </span></td><td><span style=white-space:pre-wrap>4.0               </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.000000</td><td>regular</td><td>14336 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Boys Photo Editor - Six Pack &amp; Men's Suit         </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>654   </span></td><td>12M </td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 20, 2018    </span></td><td><span style=white-space:pre-wrap>1.1               </span></td><td>4.0.3 and up</td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>12288 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Superheroes Wallpapers | 4K Backgrounds           </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>7699  </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td>Everyone 10+</td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>2.2.6.2           </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>4300.8</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Mcqueen Coloring pages                            </span></td><td>ART_AND_DESIGN</td><td>NaN</td><td><span style=white-space:pre-wrap>61    </span></td><td>7.0M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td>Art &amp; Design;Action &amp; Adventure</td><td><span style=white-space:pre-wrap>March 7, 2018     </span></td><td><span style=white-space:pre-wrap>1.0.0             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.358065</td><td><span style=white-space:pre-wrap>bom    </span></td><td><span style=white-space:pre-wrap>7168  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>HD Mickey Minnie Wallpapers                       </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td><span style=white-space:pre-wrap>118   </span></td><td>23M </td><td><span style=white-space:pre-wrap>50,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 7, 2018      </span></td><td><span style=white-space:pre-wrap>1.1.3             </span></td><td><span style=white-space:pre-wrap>4.1 and up  </span></td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>23552 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Harley Quinn wallpapers HD                        </span></td><td>ART_AND_DESIGN</td><td>4.8</td><td><span style=white-space:pre-wrap>192   </span></td><td>6.0M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>April 25, 2018    </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>3.0 and up  </span></td><td>4.800000</td><td><span style=white-space:pre-wrap>bom    </span></td><td><span style=white-space:pre-wrap>6144  </span></td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Colorfit - Drawing &amp; Coloring                     </span></td><td>ART_AND_DESIGN</td><td>4.7</td><td>20260 </td><td>25M </td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design;Creativity        </span></td><td><span style=white-space:pre-wrap>October 11, 2017  </span></td><td><span style=white-space:pre-wrap>1.0.8             </span></td><td>4.0.3 and up</td><td>4.700000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>25600 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Animated Photo Editor                             </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>203   </span></td><td>6.1M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>March 21, 2018    </span></td><td><span style=white-space:pre-wrap>1.03              </span></td><td>4.0.3 and up</td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>6246.4</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Pencil Sketch Drawing                             </span></td><td>ART_AND_DESIGN</td><td>3.9</td><td><span style=white-space:pre-wrap>136   </span></td><td>4.6M</td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>July 12, 2018     </span></td><td><span style=white-space:pre-wrap>6.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>3.900000</td><td>regular</td><td>4710.4</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Easy Realistic Drawing Tutorial                   </span></td><td>ART_AND_DESIGN</td><td>4.1</td><td><span style=white-space:pre-wrap>223   </span></td><td>4.2M</td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone    </span></td><td><span style=white-space:pre-wrap>Art &amp; Design                   </span></td><td><span style=white-space:pre-wrap>August 22, 2017   </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>2.3 and up  </span></td><td>4.100000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>4300.8</td></tr>\n",
              "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>FR Plus 1.6                                  </span></td><td><span style=white-space:pre-wrap>AUTO_AND_VEHICLES  </span></td><td>NaN</td><td><span style=white-space:pre-wrap>4     </span></td><td><span style=white-space:pre-wrap>3.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Auto &amp; Vehicles        </span></td><td><span style=white-space:pre-wrap>July 24, 2018     </span></td><td><span style=white-space:pre-wrap>1.3.6             </span></td><td><span style=white-space:pre-wrap>4.4W and up       </span></td><td>4.190411</td><td><span style=white-space:pre-wrap>bom    </span></td><td>3993.6 </td></tr>\n",
              "\t<tr><td>Fr Agnel Pune                                </td><td>FAMILY             </td><td>4.1</td><td>80    </td><td>13M               </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td><td>4.100000</td><td>bom    </td><td>13312  </td></tr>\n",
              "\t<tr><td>DICT.fr Mobile                               </td><td>BUSINESS           </td><td>NaN</td><td>20    </td><td>2.7M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>July 17, 2018     </td><td>2.1.10            </td><td>4.1 and up        </td><td>4.121452</td><td>bom    </td><td>2764.8 </td></tr>\n",
              "\t<tr><td>FR: My Secret Pets!                          </td><td>FAMILY             </td><td>4.0</td><td>785   </td><td>31M               </td><td>50,000+    </td><td>Free</td><td>0</td><td>Teen      </td><td>Entertainment          </td><td>June 3, 2015      </td><td>1.3.1             </td><td>3.0 and up        </td><td>4.000000</td><td>regular</td><td>31744  </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Golden Dictionary (FR-AR)                    </span></td><td>BOOKS_AND_REFERENCE</td><td>4.2</td><td><span style=white-space:pre-wrap>5775  </span></td><td><span style=white-space:pre-wrap>4.9M              </span></td><td><span style=white-space:pre-wrap>500,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>July 19, 2018     </span></td><td><span style=white-space:pre-wrap>7.0.4.6           </span></td><td><span style=white-space:pre-wrap>4.2 and up        </span></td><td>4.200000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>5017.6 </td></tr>\n",
              "\t<tr><td>FieldBi FR Offline                           </td><td>BUSINESS           </td><td>NaN</td><td>2     </td><td>6.8M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>August 6, 2018    </td><td>2.1.8             </td><td>4.1 and up        </td><td>4.121452</td><td>bom    </td><td>6963.2 </td></tr>\n",
              "\t<tr><td>HTC Sense Input - FR                         </td><td>TOOLS              </td><td>4.0</td><td>885   </td><td>8.0M              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Tools                  </td><td>October 30, 2015  </td><td>1.0.612928        </td><td>5.0 and up        </td><td>4.000000</td><td>regular</td><td>8192   </td></tr>\n",
              "\t<tr><td>Gold Quote - Gold.fr                         </td><td>FINANCE            </td><td>NaN</td><td>96    </td><td>1.5M              </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Finance                </td><td>May 19, 2016      </td><td>2.3               </td><td>2.2 and up        </td><td>4.131889</td><td>bom    </td><td>1536   </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Fanfic-FR                                    </span></td><td>BOOKS_AND_REFERENCE</td><td>3.3</td><td><span style=white-space:pre-wrap>52    </span></td><td><span style=white-space:pre-wrap>3.6M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>August 5, 2017    </span></td><td><span style=white-space:pre-wrap>0.3.4             </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td><td>3.300000</td><td>regular</td><td>3686.4 </td></tr>\n",
              "\t<tr><td>Fr. Daoud Lamei                              </td><td>FAMILY             </td><td>5.0</td><td>22    </td><td>8.6M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Teen      </td><td>Education              </td><td>June 27, 2018     </td><td>3.8.0             </td><td>4.1 and up        </td><td>5.000000</td><td>bom    </td><td>8806.4 </td></tr>\n",
              "\t<tr><td>Poop FR                                      </td><td>FAMILY             </td><td>NaN</td><td>6     </td><td>2.5M              </td><td>50+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Entertainment          </td><td>May 29, 2018      </td><td>1.0               </td><td>4.0.3 and up      </td><td>4.192272</td><td>bom    </td><td>2560   </td></tr>\n",
              "\t<tr><td>PLMGSS FR                                    </td><td>PRODUCTIVITY       </td><td>NaN</td><td>0     </td><td>3.1M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Productivity           </td><td>December 1, 2017  </td><td>1                 </td><td>4.4 and up        </td><td>4.211396</td><td>bom    </td><td>3174.4 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>List iptv FR                                 </span></td><td><span style=white-space:pre-wrap>VIDEO_PLAYERS      </span></td><td>NaN</td><td><span style=white-space:pre-wrap>1     </span></td><td><span style=white-space:pre-wrap>2.9M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td>Video Players &amp; Editors</td><td><span style=white-space:pre-wrap>April 22, 2018    </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0.3 and up      </span></td><td>4.063750</td><td><span style=white-space:pre-wrap>bom    </span></td><td>2969.6 </td></tr>\n",
              "\t<tr><td>Cardio-FR                                    </td><td>MEDICAL            </td><td>NaN</td><td>67    </td><td>82M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>July 31, 2018     </td><td>2.2.2             </td><td>4.4 and up        </td><td>4.189143</td><td>bom    </td><td>83968  </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Naruto &amp; Boruto FR                           </span></td><td><span style=white-space:pre-wrap>SOCIAL             </span></td><td>NaN</td><td><span style=white-space:pre-wrap>7     </span></td><td><span style=white-space:pre-wrap>7.7M              </span></td><td><span style=white-space:pre-wrap>100+       </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Teen      </span></td><td><span style=white-space:pre-wrap>Social                 </span></td><td><span style=white-space:pre-wrap>February 2, 2018  </span></td><td><span style=white-space:pre-wrap>1.0               </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td><td>4.255598</td><td><span style=white-space:pre-wrap>bom    </span></td><td>7884.8 </td></tr>\n",
              "\t<tr><td>Frim: get new friends on local chat rooms    </td><td>SOCIAL             </td><td>4.0</td><td>88486 </td><td>Varies with device</td><td>5,000,000+ </td><td>Free</td><td>0</td><td>Mature 17+</td><td>Social                 </td><td>March 23, 2018    </td><td>Varies with device</td><td>Varies with device</td><td>4.000000</td><td>regular</td><td>nd     </td></tr>\n",
              "\t<tr><td>Fr Agnel Ambarnath                           </td><td>FAMILY             </td><td>4.2</td><td>117   </td><td>13M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 13, 2018     </td><td>2.0.20            </td><td>4.0.3 and up      </td><td>4.200000</td><td>bom    </td><td>13312  </td></tr>\n",
              "\t<tr><td>Manga-FR - Anime Vostfr                      </td><td>COMICS             </td><td>3.4</td><td>291   </td><td>13M               </td><td>10,000+    </td><td>Free</td><td>0</td><td>Everyone  </td><td>Comics                 </td><td>May 15, 2017      </td><td>2.0.1             </td><td>4.0 and up        </td><td>3.400000</td><td>regular</td><td>13312  </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Bulgarian French Dictionary Fr               </span></td><td>BOOKS_AND_REFERENCE</td><td>4.6</td><td><span style=white-space:pre-wrap>603   </span></td><td><span style=white-space:pre-wrap>7.4M              </span></td><td><span style=white-space:pre-wrap>10,000+    </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>June 19, 2016     </span></td><td><span style=white-space:pre-wrap>2.96              </span></td><td><span style=white-space:pre-wrap>4.1 and up        </span></td><td>4.600000</td><td><span style=white-space:pre-wrap>bom    </span></td><td>7577.6 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>News Minecraft.fr                            </span></td><td>NEWS_AND_MAGAZINES </td><td>3.8</td><td><span style=white-space:pre-wrap>881   </span></td><td><span style=white-space:pre-wrap>2.3M              </span></td><td><span style=white-space:pre-wrap>100,000+   </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>News &amp; Magazines       </span></td><td><span style=white-space:pre-wrap>January 20, 2014  </span></td><td><span style=white-space:pre-wrap>1.5               </span></td><td><span style=white-space:pre-wrap>1.6 and up        </span></td><td>3.800000</td><td>regular</td><td>2355.2 </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>payermonstationnement.fr                     </span></td><td>MAPS_AND_NAVIGATION</td><td>NaN</td><td><span style=white-space:pre-wrap>38    </span></td><td><span style=white-space:pre-wrap>9.8M              </span></td><td><span style=white-space:pre-wrap>5,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Maps &amp; Navigation      </span></td><td><span style=white-space:pre-wrap>June 13, 2018     </span></td><td><span style=white-space:pre-wrap>2.0.148.0         </span></td><td><span style=white-space:pre-wrap>4.0 and up        </span></td><td>4.051613</td><td><span style=white-space:pre-wrap>bom    </span></td><td>10035.2</td></tr>\n",
              "\t<tr><td>FR Tides                                     </td><td>WEATHER            </td><td>3.8</td><td>1195  </td><td>582k              </td><td>100,000+   </td><td>Free</td><td>0</td><td>Everyone  </td><td>Weather                </td><td>February 16, 2014 </td><td>6.0               </td><td>2.1 and up        </td><td>3.800000</td><td>regular</td><td>582    </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>Chemin (fr)                                  </span></td><td>BOOKS_AND_REFERENCE</td><td>4.8</td><td><span style=white-space:pre-wrap>44    </span></td><td><span style=white-space:pre-wrap>619k              </span></td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>March 23, 2014    </span></td><td><span style=white-space:pre-wrap>0.8               </span></td><td><span style=white-space:pre-wrap>2.2 and up        </span></td><td>4.800000</td><td><span style=white-space:pre-wrap>bom    </span></td><td><span style=white-space:pre-wrap>619    </span></td></tr>\n",
              "\t<tr><td>FR Calculator                                </td><td>FAMILY             </td><td>4.0</td><td>7     </td><td>2.6M              </td><td>500+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>June 18, 2017     </td><td>1.0.0             </td><td>4.1 and up        </td><td>4.000000</td><td>regular</td><td>2662.4 </td></tr>\n",
              "\t<tr><td>FR Forms                                     </td><td>BUSINESS           </td><td>NaN</td><td>0     </td><td>9.6M              </td><td>10+        </td><td>Free</td><td>0</td><td>Everyone  </td><td>Business               </td><td>September 29, 2016</td><td>1.1.5             </td><td>4.0 and up        </td><td>4.121452</td><td>bom    </td><td>9830.4 </td></tr>\n",
              "\t<tr><td>Sya9a Maroc - FR                             </td><td>FAMILY             </td><td>4.5</td><td>38    </td><td>53M               </td><td>5,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 25, 2017     </td><td>1.48              </td><td>4.1 and up        </td><td>4.500000</td><td>bom    </td><td>54272  </td></tr>\n",
              "\t<tr><td>Fr. Mike Schmitz Audio Teachings             </td><td>FAMILY             </td><td>5.0</td><td>4     </td><td>3.6M              </td><td>100+       </td><td>Free</td><td>0</td><td>Everyone  </td><td>Education              </td><td>July 6, 2018      </td><td>1.0               </td><td>4.1 and up        </td><td>5.000000</td><td>bom    </td><td>3686.4 </td></tr>\n",
              "\t<tr><td>Parkinson Exercices FR                       </td><td>MEDICAL            </td><td>NaN</td><td>3     </td><td>9.5M              </td><td>1,000+     </td><td>Free</td><td>0</td><td>Everyone  </td><td>Medical                </td><td>January 20, 2017  </td><td>1.0               </td><td>2.2 and up        </td><td>4.189143</td><td>bom    </td><td>9728   </td></tr>\n",
              "\t<tr><td><span style=white-space:pre-wrap>The SCP Foundation DB fr nn5n                </span></td><td>BOOKS_AND_REFERENCE</td><td>4.5</td><td><span style=white-space:pre-wrap>114   </span></td><td>Varies with device</td><td><span style=white-space:pre-wrap>1,000+     </span></td><td>Free</td><td>0</td><td>Mature 17+</td><td><span style=white-space:pre-wrap>Books &amp; Reference      </span></td><td><span style=white-space:pre-wrap>January 19, 2015  </span></td><td>Varies with device</td><td>Varies with device</td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td><td><span style=white-space:pre-wrap>nd     </span></td></tr>\n",
              "\t<tr><td>iHoroscope - 2018 Daily Horoscope &amp; Astrology</td><td><span style=white-space:pre-wrap>LIFESTYLE          </span></td><td>4.5</td><td>398307</td><td><span style=white-space:pre-wrap>19M               </span></td><td>10,000,000+</td><td>Free</td><td>0</td><td><span style=white-space:pre-wrap>Everyone  </span></td><td><span style=white-space:pre-wrap>Lifestyle              </span></td><td><span style=white-space:pre-wrap>July 25, 2018     </span></td><td>Varies with device</td><td>Varies with device</td><td>4.500000</td><td><span style=white-space:pre-wrap>bom    </span></td><td><span style=white-space:pre-wrap>19456  </span></td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ],
            "text/markdown": "\nA data.frame: 10840 × 16\n\n| App &lt;chr&gt; | Category &lt;chr&gt; | Rating &lt;dbl&gt; | Reviews &lt;chr&gt; | Size &lt;chr&gt; | Installs &lt;chr&gt; | Type &lt;chr&gt; | Price &lt;chr&gt; | Content.Rating &lt;chr&gt; | Genres &lt;chr&gt; | Last.Updated &lt;chr&gt; | Current.Ver &lt;chr&gt; | Android.Ver &lt;chr&gt; | newRating &lt;dbl&gt; | rating_class &lt;chr&gt; | kb &lt;chr&gt; |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n| Photo Editor &amp; Candy Camera &amp; Grid &amp; ScrapBook     | ART_AND_DESIGN | 4.1 | 159    | 19M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | January 7, 2018    | 1.0.0              | 4.0.3 and up | 4.100000 | bom     | 19456  |\n| Coloring book moana                                | ART_AND_DESIGN | 3.9 | 967    | 14M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Pretend Play       | January 15, 2018   | 2.0.0              | 4.0.3 and up | 3.900000 | regular | 14336  |\n| U Launcher Lite – FREE Live Cool Themes, Hide Apps | ART_AND_DESIGN | 4.7 | 87510  | 8.7M | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 1, 2018     | 1.2.4              | 4.0.3 and up | 4.700000 | bom     | 8908.8 |\n| Sketch - Draw &amp; Paint                              | ART_AND_DESIGN | 4.5 | 215644 | 25M  | 50,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | June 8, 2018       | Varies with device | 4.2 and up   | 4.500000 | bom     | 25600  |\n| Pixel Draw - Number Art Coloring Book              | ART_AND_DESIGN | 4.3 | 967    | 2.8M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | June 20, 2018      | 1.1                | 4.4 and up   | 4.300000 | bom     | 2867.2 |\n| Paper flowers instructions                         | ART_AND_DESIGN | 4.4 | 167    | 5.6M | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | March 26, 2017     | 1.0                | 2.3 and up   | 4.400000 | bom     | 5734.4 |\n| Smoke Effect Photo Maker - Smoke Editor            | ART_AND_DESIGN | 3.8 | 178    | 19M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 26, 2018     | 1.1                | 4.0.3 and up | 3.800000 | regular | 19456  |\n| Infinite Painter                                   | ART_AND_DESIGN | 4.1 | 36815  | 29M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | June 14, 2018      | 6.1.61.1           | 4.2 and up   | 4.100000 | bom     | 29696  |\n| Garden Coloring Book                               | ART_AND_DESIGN | 4.4 | 13791  | 33M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | September 20, 2017 | 2.9.2              | 3.0 and up   | 4.400000 | bom     | 33792  |\n| Kids Paint Free - Drawing Fun                      | ART_AND_DESIGN | 4.7 | 121    | 3.1M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design;Creativity         | July 3, 2018       | 2.8                | 4.0.3 and up | 4.700000 | bom     | 3174.4 |\n| Text on Photo - Fonteee                            | ART_AND_DESIGN | 4.4 | 13880  | 28M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | October 27, 2017   | 1.0.4              | 4.1 and up   | 4.400000 | bom     | 28672  |\n| Name Art Photo Editor - Focus n Filters            | ART_AND_DESIGN | 4.4 | 8788   | 12M  | 1,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 1.0.15             | 4.0 and up   | 4.400000 | bom     | 12288  |\n| Tattoo Name On My Photo Editor                     | ART_AND_DESIGN | 4.2 | 44829  | 20M  | 10,000,000+ | Free | 0 | Teen         | Art &amp; Design                    | April 2, 2018      | 3.8                | 4.1 and up   | 4.200000 | bom     | 20480  |\n| Mandala Coloring Book                              | ART_AND_DESIGN | 4.6 | 4326   | 21M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | June 26, 2018      | 1.0.4              | 4.4 and up   | 4.600000 | bom     | 21504  |\n| 3D Color Pixel by Number - Sandbox Art Coloring    | ART_AND_DESIGN | 4.4 | 1518   | 37M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 1.2.3              | 2.3 and up   | 4.400000 | bom     | 37888  |\n| Learn To Draw Kawaii Characters                    | ART_AND_DESIGN | 3.2 | 55     | 2.7M | 5,000+      | Free | 0 | Everyone     | Art &amp; Design                    | June 6, 2018       | NaN                | 4.2 and up   | 3.200000 | regular | 2764.8 |\n| Photo Designer - Write your name with shapes       | ART_AND_DESIGN | 4.7 | 3632   | 5.5M | 500,000+    | Free | 0 | Everyone     | Art &amp; Design                    | July 31, 2018      | 3.1                | 4.1 and up   | 4.700000 | bom     | 5632   |\n| 350 Diy Room Decor Ideas                           | ART_AND_DESIGN | 4.5 | 27     | 17M  | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | November 7, 2017   | 1.0                | 2.3 and up   | 4.500000 | bom     | 17408  |\n| FlipaClip - Cartoon animation                      | ART_AND_DESIGN | 4.3 | 194216 | 39M  | 5,000,000+  | Free | 0 | Everyone     | Art &amp; Design                    | August 3, 2018     | 2.2.5              | 4.0.3 and up | 4.300000 | bom     | 39936  |\n| ibis Paint X                                       | ART_AND_DESIGN | 4.6 | 224399 | 31M  | 10,000,000+ | Free | 0 | Everyone     | Art &amp; Design                    | July 30, 2018      | 5.5.4              | 4.1 and up   | 4.600000 | bom     | 31744  |\n| Logo Maker - Small Business                        | ART_AND_DESIGN | 4.0 | 450    | 14M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | April 20, 2018     | 4.0                | 4.1 and up   | 4.000000 | regular | 14336  |\n| Boys Photo Editor - Six Pack &amp; Men's Suit          | ART_AND_DESIGN | 4.1 | 654    | 12M  | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 20, 2018     | 1.1                | 4.0.3 and up | 4.100000 | bom     | 12288  |\n| Superheroes Wallpapers | 4K Backgrounds            | ART_AND_DESIGN | 4.7 | 7699   | 4.2M | 500,000+    | Free | 0 | Everyone 10+ | Art &amp; Design                    | July 12, 2018      | 2.2.6.2            | 4.0.3 and up | 4.700000 | bom     | 4300.8 |\n| Mcqueen Coloring pages                             | ART_AND_DESIGN | NaN | 61     | 7.0M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design;Action &amp; Adventure | March 7, 2018      | 1.0.0              | 4.1 and up   | 4.358065 | bom     | 7168   |\n| HD Mickey Minnie Wallpapers                        | ART_AND_DESIGN | 4.7 | 118    | 23M  | 50,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 7, 2018       | 1.1.3              | 4.1 and up   | 4.700000 | bom     | 23552  |\n| Harley Quinn wallpapers HD                         | ART_AND_DESIGN | 4.8 | 192    | 6.0M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | April 25, 2018     | 1.5                | 3.0 and up   | 4.800000 | bom     | 6144   |\n| Colorfit - Drawing &amp; Coloring                      | ART_AND_DESIGN | 4.7 | 20260  | 25M  | 500,000+    | Free | 0 | Everyone     | Art &amp; Design;Creativity         | October 11, 2017   | 1.0.8              | 4.0.3 and up | 4.700000 | bom     | 25600  |\n| Animated Photo Editor                              | ART_AND_DESIGN | 4.1 | 203    | 6.1M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | March 21, 2018     | 1.03               | 4.0.3 and up | 4.100000 | bom     | 6246.4 |\n| Pencil Sketch Drawing                              | ART_AND_DESIGN | 3.9 | 136    | 4.6M | 10,000+     | Free | 0 | Everyone     | Art &amp; Design                    | July 12, 2018      | 6.0                | 2.3 and up   | 3.900000 | regular | 4710.4 |\n| Easy Realistic Drawing Tutorial                    | ART_AND_DESIGN | 4.1 | 223    | 4.2M | 100,000+    | Free | 0 | Everyone     | Art &amp; Design                    | August 22, 2017    | 1.0                | 2.3 and up   | 4.100000 | bom     | 4300.8 |\n| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n| FR Plus 1.6                                   | AUTO_AND_VEHICLES   | NaN | 4      | 3.9M               | 100+        | Free | 0 | Everyone   | Auto &amp; Vehicles         | July 24, 2018      | 1.3.6              | 4.4W and up        | 4.190411 | bom     | 3993.6  |\n| Fr Agnel Pune                                 | FAMILY              | 4.1 | 80     | 13M                | 1,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       | 4.100000 | bom     | 13312   |\n| DICT.fr Mobile                                | BUSINESS            | NaN | 20     | 2.7M               | 10,000+     | Free | 0 | Everyone   | Business                | July 17, 2018      | 2.1.10             | 4.1 and up         | 4.121452 | bom     | 2764.8  |\n| FR: My Secret Pets!                           | FAMILY              | 4.0 | 785    | 31M                | 50,000+     | Free | 0 | Teen       | Entertainment           | June 3, 2015       | 1.3.1              | 3.0 and up         | 4.000000 | regular | 31744   |\n| Golden Dictionary (FR-AR)                     | BOOKS_AND_REFERENCE | 4.2 | 5775   | 4.9M               | 500,000+    | Free | 0 | Everyone   | Books &amp; Reference       | July 19, 2018      | 7.0.4.6            | 4.2 and up         | 4.200000 | bom     | 5017.6  |\n| FieldBi FR Offline                            | BUSINESS            | NaN | 2      | 6.8M               | 100+        | Free | 0 | Everyone   | Business                | August 6, 2018     | 2.1.8              | 4.1 and up         | 4.121452 | bom     | 6963.2  |\n| HTC Sense Input - FR                          | TOOLS               | 4.0 | 885    | 8.0M               | 100,000+    | Free | 0 | Everyone   | Tools                   | October 30, 2015   | 1.0.612928         | 5.0 and up         | 4.000000 | regular | 8192    |\n| Gold Quote - Gold.fr                          | FINANCE             | NaN | 96     | 1.5M               | 10,000+     | Free | 0 | Everyone   | Finance                 | May 19, 2016       | 2.3                | 2.2 and up         | 4.131889 | bom     | 1536    |\n| Fanfic-FR                                     | BOOKS_AND_REFERENCE | 3.3 | 52     | 3.6M               | 5,000+      | Free | 0 | Teen       | Books &amp; Reference       | August 5, 2017     | 0.3.4              | 4.1 and up         | 3.300000 | regular | 3686.4  |\n| Fr. Daoud Lamei                               | FAMILY              | 5.0 | 22     | 8.6M               | 1,000+      | Free | 0 | Teen       | Education               | June 27, 2018      | 3.8.0              | 4.1 and up         | 5.000000 | bom     | 8806.4  |\n| Poop FR                                       | FAMILY              | NaN | 6      | 2.5M               | 50+         | Free | 0 | Everyone   | Entertainment           | May 29, 2018       | 1.0                | 4.0.3 and up       | 4.192272 | bom     | 2560    |\n| PLMGSS FR                                     | PRODUCTIVITY        | NaN | 0      | 3.1M               | 10+         | Free | 0 | Everyone   | Productivity            | December 1, 2017   | 1                  | 4.4 and up         | 4.211396 | bom     | 3174.4  |\n| List iptv FR                                  | VIDEO_PLAYERS       | NaN | 1      | 2.9M               | 100+        | Free | 0 | Everyone   | Video Players &amp; Editors | April 22, 2018     | 1.0                | 4.0.3 and up       | 4.063750 | bom     | 2969.6  |\n| Cardio-FR                                     | MEDICAL             | NaN | 67     | 82M                | 10,000+     | Free | 0 | Everyone   | Medical                 | July 31, 2018      | 2.2.2              | 4.4 and up         | 4.189143 | bom     | 83968   |\n| Naruto &amp; Boruto FR                            | SOCIAL              | NaN | 7      | 7.7M               | 100+        | Free | 0 | Teen       | Social                  | February 2, 2018   | 1.0                | 4.0 and up         | 4.255598 | bom     | 7884.8  |\n| Frim: get new friends on local chat rooms     | SOCIAL              | 4.0 | 88486  | Varies with device | 5,000,000+  | Free | 0 | Mature 17+ | Social                  | March 23, 2018     | Varies with device | Varies with device | 4.000000 | regular | nd      |\n| Fr Agnel Ambarnath                            | FAMILY              | 4.2 | 117    | 13M                | 5,000+      | Free | 0 | Everyone   | Education               | June 13, 2018      | 2.0.20             | 4.0.3 and up       | 4.200000 | bom     | 13312   |\n| Manga-FR - Anime Vostfr                       | COMICS              | 3.4 | 291    | 13M                | 10,000+     | Free | 0 | Everyone   | Comics                  | May 15, 2017       | 2.0.1              | 4.0 and up         | 3.400000 | regular | 13312   |\n| Bulgarian French Dictionary Fr                | BOOKS_AND_REFERENCE | 4.6 | 603    | 7.4M               | 10,000+     | Free | 0 | Everyone   | Books &amp; Reference       | June 19, 2016      | 2.96               | 4.1 and up         | 4.600000 | bom     | 7577.6  |\n| News Minecraft.fr                             | NEWS_AND_MAGAZINES  | 3.8 | 881    | 2.3M               | 100,000+    | Free | 0 | Everyone   | News &amp; Magazines        | January 20, 2014   | 1.5                | 1.6 and up         | 3.800000 | regular | 2355.2  |\n| payermonstationnement.fr                      | MAPS_AND_NAVIGATION | NaN | 38     | 9.8M               | 5,000+      | Free | 0 | Everyone   | Maps &amp; Navigation       | June 13, 2018      | 2.0.148.0          | 4.0 and up         | 4.051613 | bom     | 10035.2 |\n| FR Tides                                      | WEATHER             | 3.8 | 1195   | 582k               | 100,000+    | Free | 0 | Everyone   | Weather                 | February 16, 2014  | 6.0                | 2.1 and up         | 3.800000 | regular | 582     |\n| Chemin (fr)                                   | BOOKS_AND_REFERENCE | 4.8 | 44     | 619k               | 1,000+      | Free | 0 | Everyone   | Books &amp; Reference       | March 23, 2014     | 0.8                | 2.2 and up         | 4.800000 | bom     | 619     |\n| FR Calculator                                 | FAMILY              | 4.0 | 7      | 2.6M               | 500+        | Free | 0 | Everyone   | Education               | June 18, 2017      | 1.0.0              | 4.1 and up         | 4.000000 | regular | 2662.4  |\n| FR Forms                                      | BUSINESS            | NaN | 0      | 9.6M               | 10+         | Free | 0 | Everyone   | Business                | September 29, 2016 | 1.1.5              | 4.0 and up         | 4.121452 | bom     | 9830.4  |\n| Sya9a Maroc - FR                              | FAMILY              | 4.5 | 38     | 53M                | 5,000+      | Free | 0 | Everyone   | Education               | July 25, 2017      | 1.48               | 4.1 and up         | 4.500000 | bom     | 54272   |\n| Fr. Mike Schmitz Audio Teachings              | FAMILY              | 5.0 | 4      | 3.6M               | 100+        | Free | 0 | Everyone   | Education               | July 6, 2018       | 1.0                | 4.1 and up         | 5.000000 | bom     | 3686.4  |\n| Parkinson Exercices FR                        | MEDICAL             | NaN | 3      | 9.5M               | 1,000+      | Free | 0 | Everyone   | Medical                 | January 20, 2017   | 1.0                | 2.2 and up         | 4.189143 | bom     | 9728    |\n| The SCP Foundation DB fr nn5n                 | BOOKS_AND_REFERENCE | 4.5 | 114    | Varies with device | 1,000+      | Free | 0 | Mature 17+ | Books &amp; Reference       | January 19, 2015   | Varies with device | Varies with device | 4.500000 | bom     | nd      |\n| iHoroscope - 2018 Daily Horoscope &amp; Astrology | LIFESTYLE           | 4.5 | 398307 | 19M                | 10,000,000+ | Free | 0 | Everyone   | Lifestyle               | July 25, 2018      | Varies with device | Varies with device | 4.500000 | bom     | 19456   |\n\n",
            "text/latex": "A data.frame: 10840 × 16\n\\begin{tabular}{llllllllllllllll}\n App & Category & Rating & Reviews & Size & Installs & Type & Price & Content.Rating & Genres & Last.Updated & Current.Ver & Android.Ver & newRating & rating\\_class & kb\\\\\n <chr> & <chr> & <dbl> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <dbl> & <chr> & <chr>\\\\\n\\hline\n\t Photo Editor \\& Candy Camera \\& Grid \\& ScrapBook     & ART\\_AND\\_DESIGN & 4.1 & 159    & 19M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & January 7, 2018    & 1.0.0              & 4.0.3 and up & 4.100000 & bom     & 19456 \\\\\n\t Coloring book moana                                & ART\\_AND\\_DESIGN & 3.9 & 967    & 14M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Pretend Play       & January 15, 2018   & 2.0.0              & 4.0.3 and up & 3.900000 & regular & 14336 \\\\\n\t U Launcher Lite – FREE Live Cool Themes, Hide Apps & ART\\_AND\\_DESIGN & 4.7 & 87510  & 8.7M & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 1, 2018     & 1.2.4              & 4.0.3 and up & 4.700000 & bom     & 8908.8\\\\\n\t Sketch - Draw \\& Paint                              & ART\\_AND\\_DESIGN & 4.5 & 215644 & 25M  & 50,000,000+ & Free & 0 & Teen         & Art \\& Design                    & June 8, 2018       & Varies with device & 4.2 and up   & 4.500000 & bom     & 25600 \\\\\n\t Pixel Draw - Number Art Coloring Book              & ART\\_AND\\_DESIGN & 4.3 & 967    & 2.8M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & June 20, 2018      & 1.1                & 4.4 and up   & 4.300000 & bom     & 2867.2\\\\\n\t Paper flowers instructions                         & ART\\_AND\\_DESIGN & 4.4 & 167    & 5.6M & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & March 26, 2017     & 1.0                & 2.3 and up   & 4.400000 & bom     & 5734.4\\\\\n\t Smoke Effect Photo Maker - Smoke Editor            & ART\\_AND\\_DESIGN & 3.8 & 178    & 19M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 26, 2018     & 1.1                & 4.0.3 and up & 3.800000 & regular & 19456 \\\\\n\t Infinite Painter                                   & ART\\_AND\\_DESIGN & 4.1 & 36815  & 29M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & June 14, 2018      & 6.1.61.1           & 4.2 and up   & 4.100000 & bom     & 29696 \\\\\n\t Garden Coloring Book                               & ART\\_AND\\_DESIGN & 4.4 & 13791  & 33M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & September 20, 2017 & 2.9.2              & 3.0 and up   & 4.400000 & bom     & 33792 \\\\\n\t Kids Paint Free - Drawing Fun                      & ART\\_AND\\_DESIGN & 4.7 & 121    & 3.1M & 10,000+     & Free & 0 & Everyone     & Art \\& Design;Creativity         & July 3, 2018       & 2.8                & 4.0.3 and up & 4.700000 & bom     & 3174.4\\\\\n\t Text on Photo - Fonteee                            & ART\\_AND\\_DESIGN & 4.4 & 13880  & 28M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & October 27, 2017   & 1.0.4              & 4.1 and up   & 4.400000 & bom     & 28672 \\\\\n\t Name Art Photo Editor - Focus n Filters            & ART\\_AND\\_DESIGN & 4.4 & 8788   & 12M  & 1,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 1.0.15             & 4.0 and up   & 4.400000 & bom     & 12288 \\\\\n\t Tattoo Name On My Photo Editor                     & ART\\_AND\\_DESIGN & 4.2 & 44829  & 20M  & 10,000,000+ & Free & 0 & Teen         & Art \\& Design                    & April 2, 2018      & 3.8                & 4.1 and up   & 4.200000 & bom     & 20480 \\\\\n\t Mandala Coloring Book                              & ART\\_AND\\_DESIGN & 4.6 & 4326   & 21M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & June 26, 2018      & 1.0.4              & 4.4 and up   & 4.600000 & bom     & 21504 \\\\\n\t 3D Color Pixel by Number - Sandbox Art Coloring    & ART\\_AND\\_DESIGN & 4.4 & 1518   & 37M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 1.2.3              & 2.3 and up   & 4.400000 & bom     & 37888 \\\\\n\t Learn To Draw Kawaii Characters                    & ART\\_AND\\_DESIGN & 3.2 & 55     & 2.7M & 5,000+      & Free & 0 & Everyone     & Art \\& Design                    & June 6, 2018       & NaN                & 4.2 and up   & 3.200000 & regular & 2764.8\\\\\n\t Photo Designer - Write your name with shapes       & ART\\_AND\\_DESIGN & 4.7 & 3632   & 5.5M & 500,000+    & Free & 0 & Everyone     & Art \\& Design                    & July 31, 2018      & 3.1                & 4.1 and up   & 4.700000 & bom     & 5632  \\\\\n\t 350 Diy Room Decor Ideas                           & ART\\_AND\\_DESIGN & 4.5 & 27     & 17M  & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & November 7, 2017   & 1.0                & 2.3 and up   & 4.500000 & bom     & 17408 \\\\\n\t FlipaClip - Cartoon animation                      & ART\\_AND\\_DESIGN & 4.3 & 194216 & 39M  & 5,000,000+  & Free & 0 & Everyone     & Art \\& Design                    & August 3, 2018     & 2.2.5              & 4.0.3 and up & 4.300000 & bom     & 39936 \\\\\n\t ibis Paint X                                       & ART\\_AND\\_DESIGN & 4.6 & 224399 & 31M  & 10,000,000+ & Free & 0 & Everyone     & Art \\& Design                    & July 30, 2018      & 5.5.4              & 4.1 and up   & 4.600000 & bom     & 31744 \\\\\n\t Logo Maker - Small Business                        & ART\\_AND\\_DESIGN & 4.0 & 450    & 14M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & April 20, 2018     & 4.0                & 4.1 and up   & 4.000000 & regular & 14336 \\\\\n\t Boys Photo Editor - Six Pack \\& Men's Suit          & ART\\_AND\\_DESIGN & 4.1 & 654    & 12M  & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 20, 2018     & 1.1                & 4.0.3 and up & 4.100000 & bom     & 12288 \\\\\n\t Superheroes Wallpapers \\textbar{} 4K Backgrounds            & ART\\_AND\\_DESIGN & 4.7 & 7699   & 4.2M & 500,000+    & Free & 0 & Everyone 10+ & Art \\& Design                    & July 12, 2018      & 2.2.6.2            & 4.0.3 and up & 4.700000 & bom     & 4300.8\\\\\n\t Mcqueen Coloring pages                             & ART\\_AND\\_DESIGN & NaN & 61     & 7.0M & 100,000+    & Free & 0 & Everyone     & Art \\& Design;Action \\& Adventure & March 7, 2018      & 1.0.0              & 4.1 and up   & 4.358065 & bom     & 7168  \\\\\n\t HD Mickey Minnie Wallpapers                        & ART\\_AND\\_DESIGN & 4.7 & 118    & 23M  & 50,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 7, 2018       & 1.1.3              & 4.1 and up   & 4.700000 & bom     & 23552 \\\\\n\t Harley Quinn wallpapers HD                         & ART\\_AND\\_DESIGN & 4.8 & 192    & 6.0M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & April 25, 2018     & 1.5                & 3.0 and up   & 4.800000 & bom     & 6144  \\\\\n\t Colorfit - Drawing \\& Coloring                      & ART\\_AND\\_DESIGN & 4.7 & 20260  & 25M  & 500,000+    & Free & 0 & Everyone     & Art \\& Design;Creativity         & October 11, 2017   & 1.0.8              & 4.0.3 and up & 4.700000 & bom     & 25600 \\\\\n\t Animated Photo Editor                              & ART\\_AND\\_DESIGN & 4.1 & 203    & 6.1M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & March 21, 2018     & 1.03               & 4.0.3 and up & 4.100000 & bom     & 6246.4\\\\\n\t Pencil Sketch Drawing                              & ART\\_AND\\_DESIGN & 3.9 & 136    & 4.6M & 10,000+     & Free & 0 & Everyone     & Art \\& Design                    & July 12, 2018      & 6.0                & 2.3 and up   & 3.900000 & regular & 4710.4\\\\\n\t Easy Realistic Drawing Tutorial                    & ART\\_AND\\_DESIGN & 4.1 & 223    & 4.2M & 100,000+    & Free & 0 & Everyone     & Art \\& Design                    & August 22, 2017    & 1.0                & 2.3 and up   & 4.100000 & bom     & 4300.8\\\\\n\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n\t FR Plus 1.6                                   & AUTO\\_AND\\_VEHICLES   & NaN & 4      & 3.9M               & 100+        & Free & 0 & Everyone   & Auto \\& Vehicles         & July 24, 2018      & 1.3.6              & 4.4W and up        & 4.190411 & bom     & 3993.6 \\\\\n\t Fr Agnel Pune                                 & FAMILY              & 4.1 & 80     & 13M                & 1,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up       & 4.100000 & bom     & 13312  \\\\\n\t DICT.fr Mobile                                & BUSINESS            & NaN & 20     & 2.7M               & 10,000+     & Free & 0 & Everyone   & Business                & July 17, 2018      & 2.1.10             & 4.1 and up         & 4.121452 & bom     & 2764.8 \\\\\n\t FR: My Secret Pets!                           & FAMILY              & 4.0 & 785    & 31M                & 50,000+     & Free & 0 & Teen       & Entertainment           & June 3, 2015       & 1.3.1              & 3.0 and up         & 4.000000 & regular & 31744  \\\\\n\t Golden Dictionary (FR-AR)                     & BOOKS\\_AND\\_REFERENCE & 4.2 & 5775   & 4.9M               & 500,000+    & Free & 0 & Everyone   & Books \\& Reference       & July 19, 2018      & 7.0.4.6            & 4.2 and up         & 4.200000 & bom     & 5017.6 \\\\\n\t FieldBi FR Offline                            & BUSINESS            & NaN & 2      & 6.8M               & 100+        & Free & 0 & Everyone   & Business                & August 6, 2018     & 2.1.8              & 4.1 and up         & 4.121452 & bom     & 6963.2 \\\\\n\t HTC Sense Input - FR                          & TOOLS               & 4.0 & 885    & 8.0M               & 100,000+    & Free & 0 & Everyone   & Tools                   & October 30, 2015   & 1.0.612928         & 5.0 and up         & 4.000000 & regular & 8192   \\\\\n\t Gold Quote - Gold.fr                          & FINANCE             & NaN & 96     & 1.5M               & 10,000+     & Free & 0 & Everyone   & Finance                 & May 19, 2016       & 2.3                & 2.2 and up         & 4.131889 & bom     & 1536   \\\\\n\t Fanfic-FR                                     & BOOKS\\_AND\\_REFERENCE & 3.3 & 52     & 3.6M               & 5,000+      & Free & 0 & Teen       & Books \\& Reference       & August 5, 2017     & 0.3.4              & 4.1 and up         & 3.300000 & regular & 3686.4 \\\\\n\t Fr. Daoud Lamei                               & FAMILY              & 5.0 & 22     & 8.6M               & 1,000+      & Free & 0 & Teen       & Education               & June 27, 2018      & 3.8.0              & 4.1 and up         & 5.000000 & bom     & 8806.4 \\\\\n\t Poop FR                                       & FAMILY              & NaN & 6      & 2.5M               & 50+         & Free & 0 & Everyone   & Entertainment           & May 29, 2018       & 1.0                & 4.0.3 and up       & 4.192272 & bom     & 2560   \\\\\n\t PLMGSS FR                                     & PRODUCTIVITY        & NaN & 0      & 3.1M               & 10+         & Free & 0 & Everyone   & Productivity            & December 1, 2017   & 1                  & 4.4 and up         & 4.211396 & bom     & 3174.4 \\\\\n\t List iptv FR                                  & VIDEO\\_PLAYERS       & NaN & 1      & 2.9M               & 100+        & Free & 0 & Everyone   & Video Players \\& Editors & April 22, 2018     & 1.0                & 4.0.3 and up       & 4.063750 & bom     & 2969.6 \\\\\n\t Cardio-FR                                     & MEDICAL             & NaN & 67     & 82M                & 10,000+     & Free & 0 & Everyone   & Medical                 & July 31, 2018      & 2.2.2              & 4.4 and up         & 4.189143 & bom     & 83968  \\\\\n\t Naruto \\& Boruto FR                            & SOCIAL              & NaN & 7      & 7.7M               & 100+        & Free & 0 & Teen       & Social                  & February 2, 2018   & 1.0                & 4.0 and up         & 4.255598 & bom     & 7884.8 \\\\\n\t Frim: get new friends on local chat rooms     & SOCIAL              & 4.0 & 88486  & Varies with device & 5,000,000+  & Free & 0 & Mature 17+ & Social                  & March 23, 2018     & Varies with device & Varies with device & 4.000000 & regular & nd     \\\\\n\t Fr Agnel Ambarnath                            & FAMILY              & 4.2 & 117    & 13M                & 5,000+      & Free & 0 & Everyone   & Education               & June 13, 2018      & 2.0.20             & 4.0.3 and up       & 4.200000 & bom     & 13312  \\\\\n\t Manga-FR - Anime Vostfr                       & COMICS              & 3.4 & 291    & 13M                & 10,000+     & Free & 0 & Everyone   & Comics                  & May 15, 2017       & 2.0.1              & 4.0 and up         & 3.400000 & regular & 13312  \\\\\n\t Bulgarian French Dictionary Fr                & BOOKS\\_AND\\_REFERENCE & 4.6 & 603    & 7.4M               & 10,000+     & Free & 0 & Everyone   & Books \\& Reference       & June 19, 2016      & 2.96               & 4.1 and up         & 4.600000 & bom     & 7577.6 \\\\\n\t News Minecraft.fr                             & NEWS\\_AND\\_MAGAZINES  & 3.8 & 881    & 2.3M               & 100,000+    & Free & 0 & Everyone   & News \\& Magazines        & January 20, 2014   & 1.5                & 1.6 and up         & 3.800000 & regular & 2355.2 \\\\\n\t payermonstationnement.fr                      & MAPS\\_AND\\_NAVIGATION & NaN & 38     & 9.8M               & 5,000+      & Free & 0 & Everyone   & Maps \\& Navigation       & June 13, 2018      & 2.0.148.0          & 4.0 and up         & 4.051613 & bom     & 10035.2\\\\\n\t FR Tides                                      & WEATHER             & 3.8 & 1195   & 582k               & 100,000+    & Free & 0 & Everyone   & Weather                 & February 16, 2014  & 6.0                & 2.1 and up         & 3.800000 & regular & 582    \\\\\n\t Chemin (fr)                                   & BOOKS\\_AND\\_REFERENCE & 4.8 & 44     & 619k               & 1,000+      & Free & 0 & Everyone   & Books \\& Reference       & March 23, 2014     & 0.8                & 2.2 and up         & 4.800000 & bom     & 619    \\\\\n\t FR Calculator                                 & FAMILY              & 4.0 & 7      & 2.6M               & 500+        & Free & 0 & Everyone   & Education               & June 18, 2017      & 1.0.0              & 4.1 and up         & 4.000000 & regular & 2662.4 \\\\\n\t FR Forms                                      & BUSINESS            & NaN & 0      & 9.6M               & 10+         & Free & 0 & Everyone   & Business                & September 29, 2016 & 1.1.5              & 4.0 and up         & 4.121452 & bom     & 9830.4 \\\\\n\t Sya9a Maroc - FR                              & FAMILY              & 4.5 & 38     & 53M                & 5,000+      & Free & 0 & Everyone   & Education               & July 25, 2017      & 1.48               & 4.1 and up         & 4.500000 & bom     & 54272  \\\\\n\t Fr. Mike Schmitz Audio Teachings              & FAMILY              & 5.0 & 4      & 3.6M               & 100+        & Free & 0 & Everyone   & Education               & July 6, 2018       & 1.0                & 4.1 and up         & 5.000000 & bom     & 3686.4 \\\\\n\t Parkinson Exercices FR                        & MEDICAL             & NaN & 3      & 9.5M               & 1,000+      & Free & 0 & Everyone   & Medical                 & January 20, 2017   & 1.0                & 2.2 and up         & 4.189143 & bom     & 9728   \\\\\n\t The SCP Foundation DB fr nn5n                 & BOOKS\\_AND\\_REFERENCE & 4.5 & 114    & Varies with device & 1,000+      & Free & 0 & Mature 17+ & Books \\& Reference       & January 19, 2015   & Varies with device & Varies with device & 4.500000 & bom     & nd     \\\\\n\t iHoroscope - 2018 Daily Horoscope \\& Astrology & LIFESTYLE           & 4.5 & 398307 & 19M                & 10,000,000+ & Free & 0 & Everyone   & Lifestyle               & July 25, 2018      & Varies with device & Varies with device & 4.500000 & bom     & 19456  \\\\\n\\end{tabular}\n",
            "text/plain": [
              "      App                                                Category           \n",
              "1     Photo Editor & Candy Camera & Grid & ScrapBook     ART_AND_DESIGN     \n",
              "2     Coloring book moana                                ART_AND_DESIGN     \n",
              "3     U Launcher Lite – FREE Live Cool Themes, Hide Apps ART_AND_DESIGN     \n",
              "4     Sketch - Draw & Paint                              ART_AND_DESIGN     \n",
              "5     Pixel Draw - Number Art Coloring Book              ART_AND_DESIGN     \n",
              "6     Paper flowers instructions                         ART_AND_DESIGN     \n",
              "7     Smoke Effect Photo Maker - Smoke Editor            ART_AND_DESIGN     \n",
              "8     Infinite Painter                                   ART_AND_DESIGN     \n",
              "9     Garden Coloring Book                               ART_AND_DESIGN     \n",
              "10    Kids Paint Free - Drawing Fun                      ART_AND_DESIGN     \n",
              "11    Text on Photo - Fonteee                            ART_AND_DESIGN     \n",
              "12    Name Art Photo Editor - Focus n Filters            ART_AND_DESIGN     \n",
              "13    Tattoo Name On My Photo Editor                     ART_AND_DESIGN     \n",
              "14    Mandala Coloring Book                              ART_AND_DESIGN     \n",
              "15    3D Color Pixel by Number - Sandbox Art Coloring    ART_AND_DESIGN     \n",
              "16    Learn To Draw Kawaii Characters                    ART_AND_DESIGN     \n",
              "17    Photo Designer - Write your name with shapes       ART_AND_DESIGN     \n",
              "18    350 Diy Room Decor Ideas                           ART_AND_DESIGN     \n",
              "19    FlipaClip - Cartoon animation                      ART_AND_DESIGN     \n",
              "20    ibis Paint X                                       ART_AND_DESIGN     \n",
              "21    Logo Maker - Small Business                        ART_AND_DESIGN     \n",
              "22    Boys Photo Editor - Six Pack & Men's Suit          ART_AND_DESIGN     \n",
              "23    Superheroes Wallpapers | 4K Backgrounds            ART_AND_DESIGN     \n",
              "24    Mcqueen Coloring pages                             ART_AND_DESIGN     \n",
              "25    HD Mickey Minnie Wallpapers                        ART_AND_DESIGN     \n",
              "26    Harley Quinn wallpapers HD                         ART_AND_DESIGN     \n",
              "27    Colorfit - Drawing & Coloring                      ART_AND_DESIGN     \n",
              "28    Animated Photo Editor                              ART_AND_DESIGN     \n",
              "29    Pencil Sketch Drawing                              ART_AND_DESIGN     \n",
              "30    Easy Realistic Drawing Tutorial                    ART_AND_DESIGN     \n",
              "⋮     ⋮                                                  ⋮                  \n",
              "10811 FR Plus 1.6                                        AUTO_AND_VEHICLES  \n",
              "10812 Fr Agnel Pune                                      FAMILY             \n",
              "10813 DICT.fr Mobile                                     BUSINESS           \n",
              "10814 FR: My Secret Pets!                                FAMILY             \n",
              "10815 Golden Dictionary (FR-AR)                          BOOKS_AND_REFERENCE\n",
              "10816 FieldBi FR Offline                                 BUSINESS           \n",
              "10817 HTC Sense Input - FR                               TOOLS              \n",
              "10818 Gold Quote - Gold.fr                               FINANCE            \n",
              "10819 Fanfic-FR                                          BOOKS_AND_REFERENCE\n",
              "10820 Fr. Daoud Lamei                                    FAMILY             \n",
              "10821 Poop FR                                            FAMILY             \n",
              "10822 PLMGSS FR                                          PRODUCTIVITY       \n",
              "10823 List iptv FR                                       VIDEO_PLAYERS      \n",
              "10824 Cardio-FR                                          MEDICAL            \n",
              "10825 Naruto & Boruto FR                                 SOCIAL             \n",
              "10826 Frim: get new friends on local chat rooms          SOCIAL             \n",
              "10827 Fr Agnel Ambarnath                                 FAMILY             \n",
              "10828 Manga-FR - Anime Vostfr                            COMICS             \n",
              "10829 Bulgarian French Dictionary Fr                     BOOKS_AND_REFERENCE\n",
              "10830 News Minecraft.fr                                  NEWS_AND_MAGAZINES \n",
              "10831 payermonstationnement.fr                           MAPS_AND_NAVIGATION\n",
              "10832 FR Tides                                           WEATHER            \n",
              "10833 Chemin (fr)                                        BOOKS_AND_REFERENCE\n",
              "10834 FR Calculator                                      FAMILY             \n",
              "10835 FR Forms                                           BUSINESS           \n",
              "10836 Sya9a Maroc - FR                                   FAMILY             \n",
              "10837 Fr. Mike Schmitz Audio Teachings                   FAMILY             \n",
              "10838 Parkinson Exercices FR                             MEDICAL            \n",
              "10839 The SCP Foundation DB fr nn5n                      BOOKS_AND_REFERENCE\n",
              "10840 iHoroscope - 2018 Daily Horoscope & Astrology      LIFESTYLE          \n",
              "      Rating Reviews Size               Installs    Type Price Content.Rating\n",
              "1     4.1    159     19M                10,000+     Free 0     Everyone      \n",
              "2     3.9    967     14M                500,000+    Free 0     Everyone      \n",
              "3     4.7    87510   8.7M               5,000,000+  Free 0     Everyone      \n",
              "4     4.5    215644  25M                50,000,000+ Free 0     Teen          \n",
              "5     4.3    967     2.8M               100,000+    Free 0     Everyone      \n",
              "6     4.4    167     5.6M               50,000+     Free 0     Everyone      \n",
              "7     3.8    178     19M                50,000+     Free 0     Everyone      \n",
              "8     4.1    36815   29M                1,000,000+  Free 0     Everyone      \n",
              "9     4.4    13791   33M                1,000,000+  Free 0     Everyone      \n",
              "10    4.7    121     3.1M               10,000+     Free 0     Everyone      \n",
              "11    4.4    13880   28M                1,000,000+  Free 0     Everyone      \n",
              "12    4.4    8788    12M                1,000,000+  Free 0     Everyone      \n",
              "13    4.2    44829   20M                10,000,000+ Free 0     Teen          \n",
              "14    4.6    4326    21M                100,000+    Free 0     Everyone      \n",
              "15    4.4    1518    37M                100,000+    Free 0     Everyone      \n",
              "16    3.2    55      2.7M               5,000+      Free 0     Everyone      \n",
              "17    4.7    3632    5.5M               500,000+    Free 0     Everyone      \n",
              "18    4.5    27      17M                10,000+     Free 0     Everyone      \n",
              "19    4.3    194216  39M                5,000,000+  Free 0     Everyone      \n",
              "20    4.6    224399  31M                10,000,000+ Free 0     Everyone      \n",
              "21    4.0    450     14M                100,000+    Free 0     Everyone      \n",
              "22    4.1    654     12M                100,000+    Free 0     Everyone      \n",
              "23    4.7    7699    4.2M               500,000+    Free 0     Everyone 10+  \n",
              "24    NaN    61      7.0M               100,000+    Free 0     Everyone      \n",
              "25    4.7    118     23M                50,000+     Free 0     Everyone      \n",
              "26    4.8    192     6.0M               10,000+     Free 0     Everyone      \n",
              "27    4.7    20260   25M                500,000+    Free 0     Everyone      \n",
              "28    4.1    203     6.1M               100,000+    Free 0     Everyone      \n",
              "29    3.9    136     4.6M               10,000+     Free 0     Everyone      \n",
              "30    4.1    223     4.2M               100,000+    Free 0     Everyone      \n",
              "⋮     ⋮      ⋮       ⋮                  ⋮           ⋮    ⋮     ⋮             \n",
              "10811 NaN    4       3.9M               100+        Free 0     Everyone      \n",
              "10812 4.1    80      13M                1,000+      Free 0     Everyone      \n",
              "10813 NaN    20      2.7M               10,000+     Free 0     Everyone      \n",
              "10814 4.0    785     31M                50,000+     Free 0     Teen          \n",
              "10815 4.2    5775    4.9M               500,000+    Free 0     Everyone      \n",
              "10816 NaN    2       6.8M               100+        Free 0     Everyone      \n",
              "10817 4.0    885     8.0M               100,000+    Free 0     Everyone      \n",
              "10818 NaN    96      1.5M               10,000+     Free 0     Everyone      \n",
              "10819 3.3    52      3.6M               5,000+      Free 0     Teen          \n",
              "10820 5.0    22      8.6M               1,000+      Free 0     Teen          \n",
              "10821 NaN    6       2.5M               50+         Free 0     Everyone      \n",
              "10822 NaN    0       3.1M               10+         Free 0     Everyone      \n",
              "10823 NaN    1       2.9M               100+        Free 0     Everyone      \n",
              "10824 NaN    67      82M                10,000+     Free 0     Everyone      \n",
              "10825 NaN    7       7.7M               100+        Free 0     Teen          \n",
              "10826 4.0    88486   Varies with device 5,000,000+  Free 0     Mature 17+    \n",
              "10827 4.2    117     13M                5,000+      Free 0     Everyone      \n",
              "10828 3.4    291     13M                10,000+     Free 0     Everyone      \n",
              "10829 4.6    603     7.4M               10,000+     Free 0     Everyone      \n",
              "10830 3.8    881     2.3M               100,000+    Free 0     Everyone      \n",
              "10831 NaN    38      9.8M               5,000+      Free 0     Everyone      \n",
              "10832 3.8    1195    582k               100,000+    Free 0     Everyone      \n",
              "10833 4.8    44      619k               1,000+      Free 0     Everyone      \n",
              "10834 4.0    7       2.6M               500+        Free 0     Everyone      \n",
              "10835 NaN    0       9.6M               10+         Free 0     Everyone      \n",
              "10836 4.5    38      53M                5,000+      Free 0     Everyone      \n",
              "10837 5.0    4       3.6M               100+        Free 0     Everyone      \n",
              "10838 NaN    3       9.5M               1,000+      Free 0     Everyone      \n",
              "10839 4.5    114     Varies with device 1,000+      Free 0     Mature 17+    \n",
              "10840 4.5    398307  19M                10,000,000+ Free 0     Everyone      \n",
              "      Genres                          Last.Updated       Current.Ver       \n",
              "1     Art & Design                    January 7, 2018    1.0.0             \n",
              "2     Art & Design;Pretend Play       January 15, 2018   2.0.0             \n",
              "3     Art & Design                    August 1, 2018     1.2.4             \n",
              "4     Art & Design                    June 8, 2018       Varies with device\n",
              "5     Art & Design;Creativity         June 20, 2018      1.1               \n",
              "6     Art & Design                    March 26, 2017     1.0               \n",
              "7     Art & Design                    April 26, 2018     1.1               \n",
              "8     Art & Design                    June 14, 2018      6.1.61.1          \n",
              "9     Art & Design                    September 20, 2017 2.9.2             \n",
              "10    Art & Design;Creativity         July 3, 2018       2.8               \n",
              "11    Art & Design                    October 27, 2017   1.0.4             \n",
              "12    Art & Design                    July 31, 2018      1.0.15            \n",
              "13    Art & Design                    April 2, 2018      3.8               \n",
              "14    Art & Design                    June 26, 2018      1.0.4             \n",
              "15    Art & Design                    August 3, 2018     1.2.3             \n",
              "16    Art & Design                    June 6, 2018       NaN               \n",
              "17    Art & Design                    July 31, 2018      3.1               \n",
              "18    Art & Design                    November 7, 2017   1.0               \n",
              "19    Art & Design                    August 3, 2018     2.2.5             \n",
              "20    Art & Design                    July 30, 2018      5.5.4             \n",
              "21    Art & Design                    April 20, 2018     4.0               \n",
              "22    Art & Design                    March 20, 2018     1.1               \n",
              "23    Art & Design                    July 12, 2018      2.2.6.2           \n",
              "24    Art & Design;Action & Adventure March 7, 2018      1.0.0             \n",
              "25    Art & Design                    July 7, 2018       1.1.3             \n",
              "26    Art & Design                    April 25, 2018     1.5               \n",
              "27    Art & Design;Creativity         October 11, 2017   1.0.8             \n",
              "28    Art & Design                    March 21, 2018     1.03              \n",
              "29    Art & Design                    July 12, 2018      6.0               \n",
              "30    Art & Design                    August 22, 2017    1.0               \n",
              "⋮     ⋮                               ⋮                  ⋮                 \n",
              "10811 Auto & Vehicles                 July 24, 2018      1.3.6             \n",
              "10812 Education                       June 13, 2018      2.0.20            \n",
              "10813 Business                        July 17, 2018      2.1.10            \n",
              "10814 Entertainment                   June 3, 2015       1.3.1             \n",
              "10815 Books & Reference               July 19, 2018      7.0.4.6           \n",
              "10816 Business                        August 6, 2018     2.1.8             \n",
              "10817 Tools                           October 30, 2015   1.0.612928        \n",
              "10818 Finance                         May 19, 2016       2.3               \n",
              "10819 Books & Reference               August 5, 2017     0.3.4             \n",
              "10820 Education                       June 27, 2018      3.8.0             \n",
              "10821 Entertainment                   May 29, 2018       1.0               \n",
              "10822 Productivity                    December 1, 2017   1                 \n",
              "10823 Video Players & Editors         April 22, 2018     1.0               \n",
              "10824 Medical                         July 31, 2018      2.2.2             \n",
              "10825 Social                          February 2, 2018   1.0               \n",
              "10826 Social                          March 23, 2018     Varies with device\n",
              "10827 Education                       June 13, 2018      2.0.20            \n",
              "10828 Comics                          May 15, 2017       2.0.1             \n",
              "10829 Books & Reference               June 19, 2016      2.96              \n",
              "10830 News & Magazines                January 20, 2014   1.5               \n",
              "10831 Maps & Navigation               June 13, 2018      2.0.148.0         \n",
              "10832 Weather                         February 16, 2014  6.0               \n",
              "10833 Books & Reference               March 23, 2014     0.8               \n",
              "10834 Education                       June 18, 2017      1.0.0             \n",
              "10835 Business                        September 29, 2016 1.1.5             \n",
              "10836 Education                       July 25, 2017      1.48              \n",
              "10837 Education                       July 6, 2018       1.0               \n",
              "10838 Medical                         January 20, 2017   1.0               \n",
              "10839 Books & Reference               January 19, 2015   Varies with device\n",
              "10840 Lifestyle                       July 25, 2018      Varies with device\n",
              "      Android.Ver        newRating rating_class kb     \n",
              "1     4.0.3 and up       4.100000  bom          19456  \n",
              "2     4.0.3 and up       3.900000  regular      14336  \n",
              "3     4.0.3 and up       4.700000  bom          8908.8 \n",
              "4     4.2 and up         4.500000  bom          25600  \n",
              "5     4.4 and up         4.300000  bom          2867.2 \n",
              "6     2.3 and up         4.400000  bom          5734.4 \n",
              "7     4.0.3 and up       3.800000  regular      19456  \n",
              "8     4.2 and up         4.100000  bom          29696  \n",
              "9     3.0 and up         4.400000  bom          33792  \n",
              "10    4.0.3 and up       4.700000  bom          3174.4 \n",
              "11    4.1 and up         4.400000  bom          28672  \n",
              "12    4.0 and up         4.400000  bom          12288  \n",
              "13    4.1 and up         4.200000  bom          20480  \n",
              "14    4.4 and up         4.600000  bom          21504  \n",
              "15    2.3 and up         4.400000  bom          37888  \n",
              "16    4.2 and up         3.200000  regular      2764.8 \n",
              "17    4.1 and up         4.700000  bom          5632   \n",
              "18    2.3 and up         4.500000  bom          17408  \n",
              "19    4.0.3 and up       4.300000  bom          39936  \n",
              "20    4.1 and up         4.600000  bom          31744  \n",
              "21    4.1 and up         4.000000  regular      14336  \n",
              "22    4.0.3 and up       4.100000  bom          12288  \n",
              "23    4.0.3 and up       4.700000  bom          4300.8 \n",
              "24    4.1 and up         4.358065  bom          7168   \n",
              "25    4.1 and up         4.700000  bom          23552  \n",
              "26    3.0 and up         4.800000  bom          6144   \n",
              "27    4.0.3 and up       4.700000  bom          25600  \n",
              "28    4.0.3 and up       4.100000  bom          6246.4 \n",
              "29    2.3 and up         3.900000  regular      4710.4 \n",
              "30    2.3 and up         4.100000  bom          4300.8 \n",
              "⋮     ⋮                  ⋮         ⋮            ⋮      \n",
              "10811 4.4W and up        4.190411  bom          3993.6 \n",
              "10812 4.0.3 and up       4.100000  bom          13312  \n",
              "10813 4.1 and up         4.121452  bom          2764.8 \n",
              "10814 3.0 and up         4.000000  regular      31744  \n",
              "10815 4.2 and up         4.200000  bom          5017.6 \n",
              "10816 4.1 and up         4.121452  bom          6963.2 \n",
              "10817 5.0 and up         4.000000  regular      8192   \n",
              "10818 2.2 and up         4.131889  bom          1536   \n",
              "10819 4.1 and up         3.300000  regular      3686.4 \n",
              "10820 4.1 and up         5.000000  bom          8806.4 \n",
              "10821 4.0.3 and up       4.192272  bom          2560   \n",
              "10822 4.4 and up         4.211396  bom          3174.4 \n",
              "10823 4.0.3 and up       4.063750  bom          2969.6 \n",
              "10824 4.4 and up         4.189143  bom          83968  \n",
              "10825 4.0 and up         4.255598  bom          7884.8 \n",
              "10826 Varies with device 4.000000  regular      nd     \n",
              "10827 4.0.3 and up       4.200000  bom          13312  \n",
              "10828 4.0 and up         3.400000  regular      13312  \n",
              "10829 4.1 and up         4.600000  bom          7577.6 \n",
              "10830 1.6 and up         3.800000  regular      2355.2 \n",
              "10831 4.0 and up         4.051613  bom          10035.2\n",
              "10832 2.1 and up         3.800000  regular      582    \n",
              "10833 2.2 and up         4.800000  bom          619    \n",
              "10834 4.1 and up         4.000000  regular      2662.4 \n",
              "10835 4.0 and up         4.121452  bom          9830.4 \n",
              "10836 4.1 and up         4.500000  bom          54272  \n",
              "10837 4.1 and up         5.000000  bom          3686.4 \n",
              "10838 2.2 and up         4.189143  bom          9728   \n",
              "10839 Varies with device 4.500000  bom          nd     \n",
              "10840 Varies with device 4.500000  bom          19456  "
            ]
          },
          "metadata": {}
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "options(scipen = 999)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.53582Z",
          "iopub.execute_input": "2024-04-14T16:57:28.537303Z",
          "iopub.status.idle": "2024-04-14T16:57:28.550144Z"
        },
        "trusted": true,
        "id": "QL7ehIo0k-jg"
      },
      "execution_count": 38,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "hist(as.numeric(dados_2$kb))"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.552982Z",
          "iopub.execute_input": "2024-04-14T16:57:28.554566Z",
          "iopub.status.idle": "2024-04-14T16:57:28.63459Z"
        },
        "trusted": true,
        "id": "TBVQdXuXk-jl",
        "outputId": "82caeaa5-497e-4020-f603-fe74056875cc",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 472
        }
      },
      "execution_count": 39,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "Warning message in hist(as.numeric(dados_2$kb)):\n",
            "“NAs introduced by coercion”\n"
          ]
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "Plot with title “Histogram of as.numeric(dados_2$kb)”"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAADAFBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUW\nFhYXFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIjIyMkJCQlJSUmJiYnJyco\nKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6\nOjo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlKSkpLS0tM\nTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1e\nXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29w\ncHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGC\ngoKDg4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OU\nlJSVlZWWlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWm\npqanp6eoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4\nuLi5ubm6urq7u7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnK\nysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc\n3Nzd3d3e3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u\n7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////i\nsF19AAAACXBIWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3dCXwU9d2A8V+OTUggRG4EwiFS\nzxYELVjBolC8hVYLorZEYkUERV9s8QSPAhbqVcVb0VqtRcXWu1KU1luh1opYRdSCcmqQcoeQ\neWdmd7OzO8kks/ntbpJ5vp8P2cnO8Z9N5skeGTZiAGgwyfQOAM0BIQEKCAlQQEiAAkICFBAS\noICQAAWEBCggJEABIQEKCAlQQEiAAkICFBASoICQAAWEBCggJEABIQEKCAlQQEiAAkICFBAS\noICQAAWEBCggJEABIQEKCAlQQEiAAkICFBASoICQAAWEBCggJEABIQEKCAlQQEiAAkICFBAS\noICQAAXBDOlxkfyMDb6gf4uC/XakfdhabnOpyBnVnzwlklPb+l7z6qfT/Br2JH63Rov8omGD\nZEogQrpXRDaHJ4eJHJfZkN4Sy9a0j1vzbX4nS1qtq/5MN6SXRnbKbf39G7ZZ0xt+dWiB5HQe\nvSxxT+J3a21LyV7qb5RGIpghrbz55ttcS63PkY/SsDMTRIpv/n1FGkaKV+NtNo4UmR77TDWk\nyyXswA2G8VGHyCehZzxDMq4Q+YGvURqLYIZUo99JWkI6QWRCGoapH/PuMbQh9qlmSM+bX/SS\nH/c1P/7MMI4Raf/LouO6i3Ta4RnS2lyRd/wM01gQUrWj0hOSuQdT0zBM/ZwjcrrjU82QRokc\nvtMwzhcp3PNtlsgK8znShrYij3mGZIxsos+SghlS9Lu35+5hHXI7HD5rk2GcFH7oMcW8dsvM\ngW1CHUc8UBle5YEBhW1Pevczc6Z5XNwvcvSei9p3NIyqP47okFv0/d9ZS5nXDjEe71fQ48oK\nY8Up+7T80XLn8M7tTYg8xKl+juTcjHN/ouxN/2P4Pi0HL7I+vVJkoHUZOaxrGfg/E/bPLzr8\n1j2GY4erj9gvLzmosMXB0zaak7sLRZ6zr5w/oLDNie/+ORJL3E4lzEv48tSwy2FH9O79qHnx\nsnlj164SKbBfbLhs+EX/iO5JeR+R861PCoyFQ1oXDX3FXs0cpmiPn29uIxHokCqGRg7r/T51\nhPSvrpFrj/zaWuMSezp/nvnB/OxRke/daB9SZ0WWOrnKMB4TOXRBlvXZpM/aWxcdvo2NHrc9\nV0jOzTj3J8ra9F/zrCtz/ma4Qqp54CdbhDdz7E7HDkdDerk4PLPTvw3jbZEse0+nhm/kVZFY\nnDuVOC/+y1PTLscxh5VtW8xdXJzwql2F+XDvlErrk1Z32lvIftaa+Y051RRfbgh0SOY38MA/\nvvHiaSI/ND78i7nQI69+ZpSbB0qvO/88zXywfpK5zDvm1f3uffgHrcLHkblmz5JQvwOMZ8zv\n/B0f3G8utcC+dt9up042D9H8E7pMGWiucnP14PHb+/TVw0XOePXVvZG5cZtx7k+Uteme/S4f\nYW7z+4YrpBoH/qxA5Jcfv/tDkcsdOxy5zevMR1c/fOIP/UQO2GPcKnKwtbW3reoWPn18bnir\ncTuVMC/hy1PTLjtVHG7vt/mwOfTzoruqb5K5J+eKHLE9/EnRuX+cY96Ekt3WXPN+qoYXRRq9\nwIQUEwupVORG86Ji7OQb9hrrJPwc6VqR1l+Zlw+HfzSeJ7KP+aN3R4/qI1f6rDEnbj/pJOth\n4KkiPw9f+1PznsC8aLHK2H2A+bO2evCE7SU8R4rbTNz+RFibHrLTvpPIrqgpJPfAk0WGmvM2\ntZKinbEdjtzmy82n/ebxu9GM7QnjFyJnWVszLztsMx+mHRjeatxOJcxLuDk17bLDnjHmYs+Y\nP44KrK981oBfb47uyVzzTmxD5Bacb14+YV4+b60yWuS8Bn6/MyHQIV0k0v336yMLRUPqK1Jq\nfV7ZRuQ6wzjYftXJMK6OHbmPOjZ9ociI8LXvmIdTvshY88pLzTux6iUStlfziw3hzcTtT4S1\n6ZfNy7+Zl1/UGJJr4N4iV+40HS3yt9gOR27zoSLnWp++/sILK43Twk8KjYNExluX18e9oBDe\nqYR5CTenpl2O2XaiOfrF1tR7Pwh/8dvMD+/J09nS7uPo7fvA2l7ryAvxF8S//tFUBCakkh62\nFs6Q3iu0vre9y560njdHQqrKDf+MtX/FYh6c5iKzrM+eiB254eNm0cj98u1jY1j4WutchW4i\ns80L8zlJ7+jYidtLDMm5mbj9ibA2/T/zcmX4gKshpMSBq7JjPzRuje1w+DZX5YSXDDtWZIZ1\nWRC5cmEkJOdOxc9LvDk17XK1jd+X2I19d4b9zC3rJWtPss1HyofuiexWyL4v6x8p9Ap71CYn\nMCHV+KrdK4eEj7eeb1SHtM28uNtedLj5ZNuoso9G04vVR26O/X2/w5zR8qC+7aMh2dsz7wvu\nNC9uc4SUsL3EkOI2E7c/EdFNr6ktJNfA2xz3vjNiOxxe1Jp5V/XGzSdVc82LxBvp3KmEea6b\nU8MuR31h7lXOTbHPO936gPkE6xi7bcuNkd3ax547WGSMdTlbZJD3t7NRCnZIRtUb1x1vvYpl\nPgtw3CPNtecNtJ9A5Ed+ID8ef+RuNX8Sn7nDfiDiHVLi9uJDit9M3P5EuEOyHzXeXXtI1p3O\nLUbi+pGJvdnRe5TIV2OGddkicre7wN5q/E7Fz3PdnBp2OWLTd8ynUy9FPvlqo/3y999FWtkh\nDZspUvRVZLes1waNwyIPIc17pOEe38vGKuAhWSr/0sZ6nht9jtQvcoBUFIn8xjD2jzxHuir+\nyP2HufR74e15h5S4vfiQ4jcTtz8RCSGZP687WsfdhNpDMr4TeeYTt3504oDIc6RHrr/+Bes5\n0kXWJ9+xX1awX4nISdyp+Hmum1PDLkeuGyTS6b3w9C2d5Wo7pE3RF+Kr9vYPny37eOTLvqco\n/BTSmMhzpEarlpB2zCo91X7UM0LkKWO9udCr5ifXmQ9rrFe57jEfz5tPh88WKd5k/pQuiT9y\nF4Wf5X9o/oA/2jukhO3FhxS3mfj9eWPChAl7XSE9HH4V7KNCj5AuFOmy3TySzzznsi9dIV0i\n0v5bwyg3j/x7rZck7SrGmY+vys0b2c3eavxti5+XcHPidznOzeby0ZN9/mzeYa2zQnpUpE9k\nT14V63dLdkiXmIv8KfKiijGGV+0ardrukcyfrqc9v/Qf14Ykf4NRGRIZsuCvxmbziNl/3pO/\nzA//6F5srvu9B+8/omX8kfuVeZSd8sHTXc0f8K3f3OAVUsL24kOK30zc/sw3B97jCmlVlnkg\nT7i07Q88QlpVIHLUc3/9icghla6Q/mv+5B/4p0cGiHTfZi1/iDVvibnxAY89dEQrkezEnYqf\nl3hz4nbZ6WtznNbHhb2460CRzpe2Hl1mPk68Jrono0UOqrACysm75C83thY5wH7BwrwHvF3v\nW582gQ7pg26Rp73Z9xv22aT2Lxmrf3X/k53WGuPs6cLfxB+51o99U5fPu1hP6b1CStxe/IsN\ncZuJ25+aQ7LOXTP1ec28Q6iq7a7w8fBLbtL1I/dDO+PZwvDMzv+yf9mavcW68hz7qpa3mx/2\nJuxUwryEmxP/JXT4wPGSx73Gh22i08fvrk7a7P0G4w/mY9WZ9pwWr1vrfZPFmQ2NVq3PkdZf\nf3inUOGB571vffLlqH1a9JppTmz59RHFoX1//HR4jb1zD8jvePq/nw+vUn1cVvzm4IKu535l\nLDogt9tjniElbC8+pLjNxO1PLSFVzu6T1/W8DV+an26v9THlivG98gsPvbLcqCEk47OJfQoK\nDrncOjmu+ly7vTcekNfx9OUfiv1ae/xOxc9LvDlxX0KH+JCMr/7voALJaT/iYcej1avNPFff\nJ3KgMb9fizan/stej3PtmrmHzB/Rmd4Hfeek85l99Fw7T5z93UytmH3BGdZPyFNFRmV6X/Ql\n/H+k1Br7Ut3L8P+RmquV5mP2UUteu9h8hFKP46DJif8fsg3yVjunK5PbCP9Dttm6JvpI/+pM\n70kqxL9nQ8ZZ79nwbqZ3IimEVKfFp3cL5fcYsyTT+5EapZEzcxqH0ZHfETQ9hAQoICRAASEB\nCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEB\nCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEB\nCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEB\nCggJUEBIgAJCAhQQEqCAkAAFhAQoyGRIaxd5eiODuwb4k8mQykKtPbSSDRncN8CXTIZUOvID\nD8/KVxncN8AXQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEh\nAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEh\nAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKGhISFWr\nFi1cuHh10usTEpqN5EMqn9pRbN2v25HcFggJzUbSIa3tJX1KZ8yZc9XYLtK3PKlNEBKajaRD\nKgstiExVzsuaktQmCAnNRtIhdR4fmx5TktQmCAnNRtIhhWbGpq/JS2oThIRmI+mQeoyOTY/s\nmdQmCAnNRtIhTcmauys8tW26TEtqE4SEZiPpkDb3l6JhpZMnjRtaKEO2JrUJQkKzkfzvkXbf\n1C/H+jVSaNA9lcltgZDQbDToFKGdnyxbtnJ30qsTEpoNThECFHCKEKCAU4QABZwiBCjgFCFA\nAacIAQo4RQhQwClCgAJOEQIUcIoQoCA1pwitPW54tSElVbWsTkhoNlJzitD2395QbaLUdjYe\nIaHZSP0pQq8TEpq/1J8iREgIgNSfIkRICIDUnyJESAiA1J8iREgIgNSfIkRICIDUnyJESAiA\n1J8iREgIgNSfIkRICIDUv4sQISEAVP5iX/nnHjMJCQGQfEjvn9hj8Lzwg7ppXlshJARA0iG9\nli+FIfmhfXIQISHokg7ppNBTVbtuCh2xzSAkIOmQSs62Pi7OO7GSkIDkTxGabl/8Xi4iJCDp\nkLqdGr68XOYQEgIv6ZAuyrqtwrqsGicXX0hICLikQ/q6uwy3J6ouEiEkBFzyv0fadMHFkakn\nexMSAk7lzAZPhIQAICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJC\nAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJC\nAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJC\nAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJC\nAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJCAhQQEqCAkAAFhAQoICRAASEBCggJUEBIgAJC\nAhQQEqCAkAAFhAQoICRAQeMN6U/yvQFe5qd8z4F6a0hIVasWLVy4eHUdSyUb0t1yyQwPB01u\nwJ4DypIPqXxqR7F1v26H13LJh7TYa/YIQkIjknRIa3tJn9IZc+ZcNbaL9C33WJCQEABJh1QW\nWhCZqpyXNcVjQUJCACQdUufxsekxJR4LEhICIOmQQjNj09fkeSxISAiApEPqMTo2PbKnx4KE\nhABIOqQpWXN3hae2TZdpHgsSEgIg6ZA295eiYaWTJ40bWihDtnosSEgIgOR/j7T7pn451q+R\nQoPuqfRajpAQAA06RWjnJ8uWrawtkyhCQgA05lOECAlNBqcIAQo4RQhQwClCgAJOEQIUcIoQ\noIBThAAFnCIEKOAUIUABpwgBClJzilDl0wuqXU9IaP4a+nZcu995+TP3tZ93bFOtSHbVsi4h\nodlIOqTrX7Y+3tXGfHA34D2vBXlohwBIOiT7lbpnJf/HE46S4k89FiQkBEDDQupTvML8+GTW\nOR4LEhICoEEhbZQr7OlRXT0WJCQEQINCWi0P29NXhTwWJCQEQINCqiyebU+Pb+uxICEhAJIP\naey7Kzddvv92c/Kjlqd4LEhICIDkQwp7wjAeaZn9jseChIQASDqk+TfPmDJu1NDFhjGv6zNe\nCxISAkDhD41t3es5m5AQACp/se/rlR4zCQkBoBLSNK+tEBICgJAABYQEKEg6JOcfGO9MSAi4\npEPKzs6vlkNICLikQ5pWFHupjod2CLqkQ6o47PCK6DQhIeiSf7FhRcGl0UlCQtA14FW7Ld9E\np5bM9liMkBAAKi9/eyIkBAAhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIAC\nQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQIEzpEF3fZuCEQgJ\nAeAMKVcKxr7k/ZeVk0BICABnSF/fPSxHSq70+svKSSAkBEDCc6SNdx6TLYPv+5/iCISEAHC/\n2LD25r5SeP7HaiMQEgLAFdKOx08rkO6h0DVVSiMQEgIgIaTXzm0tBWe9Yqw+TWYojUBICABn\nSKt/3UfksNs3W9NVwzsqjUBICABnSNlSfP7S6Ce3ZymNQEgIAGdIQx7cEftk5UKlEQgJARD/\nHGn5JuvDP1VHICQEgDOkivHyinlxm5RWKo5ASAgAZ0g3ykmfmRf/GSO3KI5ASAgAZ0jfPTky\nceL+iiMQEgLAGVLBjZGJOSHFEQgJAeAMqdOFkYkLOimOQEgIAGdI4wufsy4q7sn9meIIhIQA\ncIa0dl/p/qOTB7eVff+rOAIhIQDifo+0/vx2ItLhF19qjkBICICEk1arvvp0m/IIhIQA4M1P\nAAXOkKoWnNzvkDDFEQgJAeAMaa5IYXGY4giEhABwhtTtuFUpGIGQEADOkEJvpWIEQkIAxN0j\nvZmKEQgJAeAM6ZcXpGIEQkIAOEPaetyZL65YaVMcgZAQAM6QJEZxBEJCADiTGTuuLEpxBEJC\nAHBmA6AgIaT/Ld+sPQIhIQDiQloyQOQFwzjlb5ojEBICwBnS23lFx5khbeyct7TW5f0jJASA\nM6STuq9ZZ90jbeg+UnEEQkIAOENqN9uwQzJmtVEcgZAQAHF/+vIPkZDm8y5CgC9x59pdGQnp\nnB6KIxASAsAZ0nltllkhlV8hmifdERICwBnSupLc/tKvX750X684AiEhAOJ+j7RhovUuQu0n\nbtAcgZAQAInvIrR+pea9kYWQEACcawcocIY0rNoQxREICQFQ4/9HKuqiOAIhIQCcIe2xbV9+\n6dFbFEcgJARAjc+RLjtfcQRCQgDUGNKbPLQDfKkxpJcKFUcgJASAM6TNYRtf6cd7fwO+1Pwu\nQg8rjkBICIC4/9gXNmoi/9Uc8IczGwAFhAQocIbU9/sDnZRGICQEgDOkTgUikmX+K8ixKI1A\nSAgAZ0jlgyf9c6ex5e8/GcEpQoAvzpDOKY1MHH+u4giEhABwhtTh/sjEbzsqjkBICABnSPkz\nIxO/yq/XulWrFi1cuHh1HUsREgLAGdJhXcJ/RPa19n3rsWb51I7h0yC6X7fDazlCQgA4Q/pL\njvQafsrw/STribpXXNtL+pTOmDPnqrFdpG+5x4KEhACI/2sUx7Uw72Hyjl1UjxXLQgsiU5Xz\nsqZ4LEhICICEMxv2fvnJmsp6rdh5fGx6TInHgoSEAEj6D42FZsamr8nzWJCQEABJ/6GxHqNj\n0yN7eixISAiApP/Q2JSsubvCU9umyzSPBQkJAZD0Hxrb3F+KhpVOnjRuaKEM2eqxICEhAJL/\nQ2O7b+qXY/0aKTToHs+XJwgJAdCgPzS285Nly1bWlkkUISEAGvKHxjhFCIhI/g+NcYoQUC3p\nPzTGKUJATNJ/aIxThICYpP/QGKcIATFxZ38v97EipwgBMc6QWtzgY0VOEQJinCENP2Fv/Vfk\nFCEgxhnS+rHHP7p0pa3uFTlFCIip+U306/P+q5wiBFRzJjPmZ+PLIuq3cq2nCK0+cL9qXWRX\nLasTEpqNhrz3d+2nCO1+8O5qv+IeCc1fdUi3vWpfvPdlfdfkFCGgWnVIEj47QSbVc0VOEQJi\nkg4p06cIDeg/zcuvq+p5OwANSYeU6VOEOnUf4WGQaP4dAKAuSYeU6VOEOo31mruAkJBWSYeU\n6VOECAmNSdIhZfoUIUJCY5J0SJk+RYiQ0JjEQho4wyJH2Bf1WDPDpwgREhqTWEhx6rdyJt9F\niJDQmFQn83Acfxv52utscUJCADTkXLtq07y2QkgIAEICFBASoCDpkAY4dCYkBFzSIWVn51fL\nISQEXNIhTSuKvVTHQzsEXdIhVRx2eEV0mpAQdMm/2LCi4NLoJCEh6Brwqt2Wb6JTS2Z7LEZI\nCACVl789ERICgJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBA\nSIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBA\nSIACQgIUEBKgoNmG9PelXram/GYjWJppSDeKt+kpv9kIlmYa0m/kTa/Zgy9L+c1GsBASoICQ\nAAWEBCggJEABIQEKCAlQQEiAAkICFBASoICQAAWEBCggJEABIQEKCAlQQEiAAkICFBASoICQ\nAAWEBCggJEABIQEKCAlQQEiAAkICFBASoICQAAWEBCggJEABIQEKCAlQQEiAAkICFAQzpO6d\nB3gZkfIvCpqbYIbUZvAMD6WyN+VfFTQzAQ2pzGvug4QEvwjJjZDgGyG5ERJ8IyQ3QoJvhORG\nSPCNkNwICb4RkhshwTdCciMk+EZIboQE3wjJjZDgGyG5ERJ8IyQ3QoJvhOR2r9x1t5c1Kf+a\nockhJLcrpJuX/Jkp/5qhySEkt8vlfa/Z/a9P+dcMTQ4huRESfCMkN0KCb4TkRkjwjZDcCAm+\nNSSkqlWLFi5cvLqOpQgJAZB8SOVTO4qt+3U7vJYjJARA0iGt7SV9SmfMmXPV2C7St9xjQUJC\nACQdUlloQWSqcl7WFI8FCQkBkHRIncfHpseUeCxISAiApEMKOU6UuSbPY0FCQgAkHVKP0bHp\nkT09FiQkBEDSIU3JmrsrPLVtukzzWJCQEABJh7S5vxQNK508adzQQhmy1WNBQkIAJP97pN03\n9cuxfo0UGnRPpddyhIQAaNApQjs/WbZsZW2ZRBESAoBThNwICb5xipAbIcE3ThFyIyT4xilC\nboQE31JzitCuB2LvufMrQkLzl5pThNYcsl+1LrKrlk0QEpoNThFyIyT4xilCboQE3zhFyI2Q\n4BunCLkREnzjFCE3QoJvDX07rt3vvPyZ9xKEhABIOqTrX7Y+3tXGfHA34D2vBQkJAZB0SPYr\ndc9K/o8nHCXFn3osSEgIgIaF1Kd4hfnxyaxzPBYkJARAg0LaKFfY06O6eixISAiABoW0Wh62\np68KeSxISAiABoVUWTzbnh7f1mNBQkIAJB/S2HdXbrp8/+3m5EctT/FYkJAQAMmHFPaEYTzS\nMvsdjwUJCQGQdEjzb54xZdyooYsNY17XZ7wWJCQEgMIfGtu613M2ISEA+It9boQE3wjJjZDg\nGyG5ERJ8IyQ3QoJvhORGSPCNkNwICb4RkhshwTdCciMk+EZIboQE3wjJjZDgGyG5ERJ8IyQ3\nQoJvhORGSPCNkNwICb4RkhshwTdCciMk+EZIboQE3wjJjZDgGyG51RFSl97DvYyv5daiWSMk\ntzpCajVgvIcRLVP+FUUjREhudYV0odfceYQUSITkRkjwjZDcCAm+EZIbIcE3QnIjJPhGSG6E\nBN8IyY2Q4BshuRESfCMktwaFNCv3PE/vp/wLjkwgJLcGhTQx53Qv+9yS8i84MoGQ3BoWUoHX\n3A8OIKTmiZDcCAm+EZIbIcE3QnIjJPhGSG6EBN8IyY2Q4BshuRESfCMkN0KCb4TkRkjwjZDc\nCAm+EZIbIcE3QnIjJPhGSG6EBN8IyY2Q4BshuWUupI9H/9QT/5mp0SIkt8yF9FiB15u4ji+6\nLwXfH6ggJLcMhtTOc+USQmq0CMmNkOAbIbkREnwjJDdCgm+E5EZI8I2Q3AgJvhGSGyHBN0Jy\nIyT4RkhuhATfCMmNkOAbIbkREnwjJDdCgm+E5NZoQ2p7wjQvD6Xgu4d6IiS3VIZUKJ7aea6c\n23uQh969U/69RK0IyS2VIeWX/snDie08V8691mvutYSUQYTkltKQpnnNPbud58qE1HgRkhsh\nwTdCciMk+EZIboQE3wjJrXmGdMlwT9fpf+cDhZDcmmdInY7xel+VgX31v/OBQkhuzTSkuV4r\nTyOkhiEkN0KCb4TkRkjwjZDcmmhIk1t5vktrC0JKJUJya6IhjWx1upcsQkolQnJrqiGVeK6c\nTUipREhuhATfCMmNkOAbIbkREnwjJDdCgm+E5EZI8I2Q3AgJvhGSGyHBN0JyIyT4RkhuhATf\nCMmNkOAbIbkREnwjJDdCcinz/G/qx5Qt8vJalf5RFfHeDZ5uqUjZyIkIyY2QXFqO8Pp/6t28\n3z5W3tA/qiImt/V679n+8knKRk5ESG5BDGlUlncL87xWHnSY19x/y5KUHVyTR3iNvFg+TtnI\niQjJLYghDet2rxdCqgshuQUypAM8VyakuhCSGyG5EFJdCMmNkFwIqS6E5EZILg0J6X0pauNl\nSgMOLu+QnpXWniPPasDIiQjJjZBcGhLSv2TSjR6OPd7r6Nk70fOtkfb3DGmBXOY18hGlioc5\nIbkRkkvDQnrQa3aZZ0hbZLjXWyMV1xHSs16zRxLSB4Tk1kxDWuC18ncIySAkN0JKREjVCMmJ\nkBIRUj0RkhMhJRpauJ+HnoQURUhOhJSo7/4zPFxCSFGE5ERIifoO9pr7N0KKIiQnQkpESPVE\nSE6ElIiQ6omQnAgpESHVE/k7LBkAAA25SURBVCE5EVIiQjKqVi1auHDx6jqWIiQnQkoU+JDK\np3YM/y/k7tft8FqOkJwIKVHQQ1rbS/qUzpgz56qxXaRvuceChORESImCHlJZaEFkqnJeltd/\nKSEkJ0JKFPSQOo+PTY8p8ViQkJwIKVHQQwrNjE1fk5cw87MOsf+GWCS1vUtfWai1h0Jp5TU7\nO8975SKv2Vn5XnNbiNfcOlbOz/JcWVp4zc3LbsDKoTpWLmjIyoVec3NzvFdu6TU3J9drbivv\noyDH8xBq6b1yqCzZg78GSYfUY3RsemTPhJl7X4m9z+ZLf6htE2s9359z0R2ecx993GvuS3d6\nrvyHJz1Xvstz5Yee8pr7wt2eK89/2mvu8/d6rnzfs15zn73Pc+V7n/ea+/R8z5XvfsFr7lMP\nea5811+95j75B8+V73zJa+7jj3qu7H0ILVqb7MFfg6RDmpI1d1d4att0maa1O0DTlHRIm/tL\n0bDSyZPGDS2UIVs1dwloepL/PdLum/rlWL9GCg26p1Jxh4CmqEGnCO38ZNmylbW9JgcESOrP\ntQMCgJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIU\nEBKgIJMhDRIgpT5K28GcyZDOPGVphvygNFMjf2dqpkZuOytDA78j92Ro5Bfk47QdzJkMqVTz\nnS59Of6yTI3c95ZMjdzpsQwNvFf+nqGRvyKkFCOkNCKkVCOkdCKklCKk9CKkNCKkVCOkNCKk\nVCOkdCKklCKk9CKkNCKkVCOkNCKkVCOkdCKklCKk9CKkNApKSOedl6mRT52eqZGPuCNTI5cs\nzNDAVaE3MzTypqzP0zZWJkMqL8/UyBsy9pfRvtyVqZG/2JOpkT+rytTIq9I3FP+NAlBASIAC\nQgIUEBKggJAABYQEKCAkQAEhAQoICVBASIACQgIUEBKggJAABYQEKCAkQAEhAQoyF9LmKT1C\n+5atTeUQ5VO75/Uc+WbCaHVOKrlEyjIx8vNHtyo+5pUMjPzR2Z1z2496O80jV1yWPSA85WdQ\n/e92xkLa3V9Omzk+1CuF/0v2m55y0tVn5bb4d9xodU4qeTfHDindIz8gva+6tEPe62kfeXlR\n2+m/v75z7uK0jryif1EkJD+DpuDgy1hIN8lvzI9/kqmpG2KS3GZ+fFJOjButzkkde/r1tUNK\n88gbWh22zTBWtrog7SOfKS+bH9+XoekceUvB4SvzwyH5GTQFB1/GQupXZL97wf4dU/cf+i8e\nVmF+rCroETdanZM6bsh6wQ4pzSPPlReti6r0jzxQrK+20bpnOkf+ZmqFEQnJz6ApOPgyFdLO\nnGH2Zamk+g0qdoWOco5W56TOqJ8WTNxshZTukY8rqDB2bbGm0j3yOPnA/Lgp+4R0jxwOyc+g\n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"
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "size.app <- dados_2 %>% filter(kb != \"nd\") %>% mutate(kb = as.numeric(kb))"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.637599Z",
          "iopub.execute_input": "2024-04-14T16:57:28.639173Z",
          "iopub.status.idle": "2024-04-14T16:57:28.6599Z"
        },
        "trusted": true,
        "id": "0I2xQpl1k-jm"
      },
      "execution_count": 40,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "size.App.Plot <- ggplot(size.app) + geom_histogram(aes(kb))\n",
        "size.App.Plot"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.662652Z",
          "iopub.execute_input": "2024-04-14T16:57:28.664174Z",
          "iopub.status.idle": "2024-04-14T16:57:28.932889Z"
        },
        "trusted": true,
        "id": "BIYQQ2_Zk-jm",
        "outputId": "05229e4f-99ba-400d-bb70-b1570790b929",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 454
        }
      },
      "execution_count": 41,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "\u001b[1m\u001b[22m`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.\n"
          ]
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAACeVBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcJCQkKCgoLCwsMDAwNDQ0PDw8RERETExMUFBQVFRUYGBgZGRkaGhocHBwd\nHR0eHh4fHx8gICAhISEiIiIjIyMkJCQmJiYnJycoKCgpKSkrKyssLCwtLS0uLi4vLy8xMTEy\nMjIzMzM1NTU2NjY5OTk6Ojo7Ozs8PDw9PT0+Pj5AQEBBQUFCQkJDQ0NGRkZHR0dNTU1OTk5P\nT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBh\nYWFiYmJjY2NkZGRlZWVmZmZoaGhpaWlqampra2tsbGxtbW1vb29wcHBxcXFycnJzc3N0dHR1\ndXV3d3d4eHh5eXl7e3t8fHx+fn6AgICBgYGCgoKDg4OFhYWGhoaHh4eKioqLi4uMjIyNjY2O\njo6Pj4+RkZGSkpKTk5OWlpaXl5eZmZmampqbm5ucnJydnZ2enp6fn5+hoaGkpKSlpaWmpqan\np6epqamrq6usrKyurq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4uLi5ubm6urq7u7u8\nvLy9vb2+vr6/v7/BwcHCwsLDw8PGxsbHx8fIyMjJycnKysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR\n0dHS0tLU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7g4ODh4eHi4uLj4+Pk5OTl\n5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb3\n9/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7///+usPpGAAAACXBIWXMAABJ0AAASdAHeZh94AAAc\n2UlEQVR4nO3d+59c9X3f8bV78SWt01zcNGlTJ03aREkqJ3VTS6LBqmMBAplcarApbmkhUoUw\nxTJuTNu4NYU0drFThQQSinFwWhLsBlOJ2iIgxrqtLrvay5y/qDO7Wu0+VtKc+c68tWdnz/P1\nw5wdM/OZ75zveT52VovFVCVp7KaaXoC0FQJJCgSSFAgkKRBIUiCQpEAgSYFAkgKFIE2fKuji\nYtHDh+jC+fDAc4sXwhOnZ8IDzyymJ56eCw88tRCfOJ8eeGnx9BjPPpOGdKZT0MWyhw/RhXPh\ngdPV+fDEszPhgaeq2fDEk/PhgZ3uQnriYnrgXPXdMZ59CqTBgRQJJJBACgQSSCAFAgkkkAKB\nBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQ\nQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQS\nSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgTSxkH6yLUrez8gJQKpOJBq\nAikSSCCBFAgkkEAKBBJIIAUCCSSQAoEEEkiBQAIJpEAggQRSIJBAAikQSCCBFAgkkEAKBBJI\nIAUCCSSQAoEEEkiBQAIJpEAggQRSIJBAAikQSCCBFAgkkEAKBBJIIAUCCSSQAoEEEkiBQAIJ\npEAggQRSIJBAAikQSCCBFAik0i6WNF/Nrt65DqSigRfn5soeX9ulKj5xPjxwplpIT1wMD7zY\n7cYnpgcull2760tDunCuoEvVxdU714FUMq83cbbs8bXNVPGJc+GBF6r58MTzi+GB57r5iemB\nC9X5MZ59Pg3JR7u6fLSLtNU/2oFUF0iRQFoTSIlAigTS2kBKBFJxINUEUiSQQAIpEEgggRQI\nJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKB\nBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQ\nQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQS\nSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUAC\nCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgg\ngRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkk\nkAKBBBJIgUACCaRAIIEEUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUACCaRAIIEE\nUiCQQAIpEEgggRQIJJBACgQSSCAFAgkkkAKBBBJIgUBa7fgnd/UPH9/Ra3dVnXvk9j0HTqwe\n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\nSUVORK5CYII="
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "install.packages(\"lubridate\")"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:57:28.935622Z",
          "iopub.execute_input": "2024-04-14T16:57:28.937131Z",
          "iopub.status.idle": "2024-04-14T16:58:29.028655Z"
        },
        "trusted": true,
        "id": "UvPUlPFfk-jm",
        "outputId": "34a9c151-3893-4634-8b3d-d31664dc9b06",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 42,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "Installing package into ‘/usr/local/lib/R/site-library’\n",
            "(as ‘lib’ is unspecified)\n",
            "\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "library(lubridate)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.032114Z",
          "iopub.execute_input": "2024-04-14T16:58:29.033746Z",
          "iopub.status.idle": "2024-04-14T16:58:29.047575Z"
        },
        "trusted": true,
        "id": "BkCso2n7k-jm"
      },
      "execution_count": 43,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "notas <- read.csv(\"/kaggle/input/dataset-google-com-data/user_reviews.csv\")"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.050652Z",
          "iopub.execute_input": "2024-04-14T16:58:29.052245Z",
          "iopub.status.idle": "2024-04-14T16:58:29.378227Z"
        },
        "trusted": true,
        "id": "yJruLTE8k-jm"
      },
      "execution_count": 44,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "str(notas)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.383185Z",
          "iopub.execute_input": "2024-04-14T16:58:29.384933Z",
          "iopub.status.idle": "2024-04-14T16:58:29.417101Z"
        },
        "trusted": true,
        "id": "sfd5M3Xfk-jm",
        "outputId": "1e671786-87c8-4f9b-d5e3-df1576ba926d",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 45,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "'data.frame':\t64295 obs. of  7 variables:\n",
            " $ X                     : int  1 2 3 4 5 6 7 8 9 10 ...\n",
            " $ App                   : chr  \"10 Best Foods for You\" \"10 Best Foods for You\" \"10 Best Foods for You\" \"10 Best Foods for You\" ...\n",
            " $ Translated_Review     : chr  \"I like eat delicious food. That's I'm cooking food myself, case \\\"10 Best Foods\\\" helps lot, also \\\"Best Before (Shelf Life)\\\"\" \"This help eating healthy exercise regular basis\" \"nan\" \"Works great especially going grocery store\" ...\n",
            " $ Sentiment             : chr  \"Positive\" \"Positive\" \"nan\" \"Positive\" ...\n",
            " $ Sentiment_Polarity    : num  1 0.25 NA 0.4 1 1 0.6 NA 0 0 ...\n",
            " $ Sentiment_Subjectivity: num  0.533 0.288 NA 0.875 0.3 ...\n",
            " $ data                  : chr  \"2016-01-20 08:31:00\" \"2017-11-04 03:40:00\" NA \"2017-09-19 03:23:00\" ...\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "notas$data_2 <- ymd_hms(notas$data)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.420219Z",
          "iopub.execute_input": "2024-04-14T16:58:29.421919Z",
          "iopub.status.idle": "2024-04-14T16:58:29.479414Z"
        },
        "trusted": true,
        "id": "Vquc4-v-k-jn"
      },
      "execution_count": 46,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "str(notas)"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.483439Z",
          "iopub.execute_input": "2024-04-14T16:58:29.485089Z",
          "iopub.status.idle": "2024-04-14T16:58:29.51816Z"
        },
        "trusted": true,
        "id": "TiiErBJ8k-jn",
        "outputId": "6ad4fec3-4a61-4d5a-d752-3e100f0bda7b",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 47,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "'data.frame':\t64295 obs. of  8 variables:\n",
            " $ X                     : int  1 2 3 4 5 6 7 8 9 10 ...\n",
            " $ App                   : chr  \"10 Best Foods for You\" \"10 Best Foods for You\" \"10 Best Foods for You\" \"10 Best Foods for You\" ...\n",
            " $ Translated_Review     : chr  \"I like eat delicious food. That's I'm cooking food myself, case \\\"10 Best Foods\\\" helps lot, also \\\"Best Before (Shelf Life)\\\"\" \"This help eating healthy exercise regular basis\" \"nan\" \"Works great especially going grocery store\" ...\n",
            " $ Sentiment             : chr  \"Positive\" \"Positive\" \"nan\" \"Positive\" ...\n",
            " $ Sentiment_Polarity    : num  1 0.25 NA 0.4 1 1 0.6 NA 0 0 ...\n",
            " $ Sentiment_Subjectivity: num  0.533 0.288 NA 0.875 0.3 ...\n",
            " $ data                  : chr  \"2016-01-20 08:31:00\" \"2017-11-04 03:40:00\" NA \"2017-09-19 03:23:00\" ...\n",
            " $ data_2                : POSIXct, format: \"2016-01-20 08:31:00\" \"2017-11-04 03:40:00\" ...\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "notas$data_2 <- parse_date_time(format(notas$data_2, \"%Y-%m\"),\"ym\")"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.521216Z",
          "iopub.execute_input": "2024-04-14T16:58:29.522809Z",
          "iopub.status.idle": "2024-04-14T16:58:29.595484Z"
        },
        "trusted": true,
        "id": "OK2eKgg9k-jn"
      },
      "execution_count": 48,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "source": [
        "Calculo da media por dia para adicionar apenas um registro por data"
      ],
      "metadata": {
        "id": "E9ZiLZVfk-jn"
      }
    },
    {
      "cell_type": "code",
      "source": [
        "media_nota <- notas %>% group_by(data_2) %>% summarise(media = mean(Sentiment_Polarity))"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.59856Z",
          "iopub.execute_input": "2024-04-14T16:58:29.600144Z",
          "iopub.status.idle": "2024-04-14T16:58:29.628237Z"
        },
        "trusted": true,
        "id": "442gN126k-jn"
      },
      "execution_count": 49,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "ggplot(media_nota) + geom_line(aes(x = data_2, y = media))"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.631364Z",
          "iopub.execute_input": "2024-04-14T16:58:29.633066Z",
          "iopub.status.idle": "2024-04-14T16:58:29.886435Z"
        },
        "trusted": true,
        "id": "T0BuF4aHk-jn",
        "outputId": "f8752a52-1dfd-4575-d523-fa62b9d77069",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 472
        }
      },
      "execution_count": 50,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "Warning message:\n",
            "“\u001b[1m\u001b[22mRemoved 1 row containing missing values (`geom_line()`).”\n"
          ]
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAADAFBMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUW\nFhYXFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIjIyMkJCQlJSUmJiYnJyco\nKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6\nOjo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlKSkpLS0tM\nTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1e\nXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29w\ncHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGC\ngoKDg4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OU\nlJSVlZWWlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWm\npqanp6eoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4\nuLi5ubm6urq7u7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnK\nysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc\n3Nzd3d3e3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u\n7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////i\nsF19AAAACXBIWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3dCbwN5RsH8Oeu9jUtZGnVIknS\nJkn7YiuSIlS0kUSiEBIqpNL216JVoVWSRIsKpVBIsm+Xe0eSJct17/zPfs88Z5b3fecd855z\n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\noUjI/wGcdG4sinY8egAAAABJRU5ErkJggg=="
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "rating.Histogram <- rating.Histogram + ggtitle(\"Histograma das notas\") + theme(plot.title = element_text(hjust = 0.5)) + xlab(\"Notas\") + ylab(\"Avaliações\")\n",
        "rating.Histogram"
      ],
      "metadata": {
        "execution": {
          "iopub.status.busy": "2024-04-14T16:58:29.8894Z",
          "iopub.execute_input": "2024-04-14T16:58:29.890941Z",
          "iopub.status.idle": "2024-04-14T16:58:30.157547Z"
        },
        "trusted": true,
        "id": "nT7wf2-Jk-jp",
        "outputId": "3880f8b8-310e-4e7e-dfd7-693d7d1ae271",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 437
        }
      },
      "execution_count": 51,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "plot without title"
            ],
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAMAAADKOT/pAAAC91BMVEUAAAABAQECAgIDAwME\nBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUW\nFhYXFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIjIyMkJCQlJSUmJiYnJyco\nKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6\nOjo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlKSkpLS0tM\nTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1e\nXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1vb29wcHBx\ncXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGCgoKD\ng4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCSkpKTk5OVlZWWlpaX\nl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWmpqanp6eoqKip\nqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4uLi5ubm6urq7\nu7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnKysrLy8vMzMzN\nzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7f\n39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx\n8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////iVLcdAAAACXBI\nWXMAABJ0AAASdAHeZh94AAAgAElEQVR4nO3deYCVdb3H8R8im4qokSGJ3sqScsvQQnErb2UL\noJHSFwRERU3c0C4upRABJhl6syJpMzPTVK5oiEo38+KCN0hNc4FMWcRhm32f3x/3ec4Z8Mxy\n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\nCUhAMghIQAKSQUACEpAMAhKQgGQQkIAEJIOABCQgGQQkIAHJICABCUgGAQlIQDIISEACkkFA\nAhKQDAISkIBkEJCABCSDgAQkIBkEJCABySAgAQlIBgEJSEAyCEhAApJBQAISkAwCEpCAZBCQ\ngAQkg4AEJCAZBCQgAckgIAEJSAYBCUhAMghIQAKSQUACEpAMAhKQgGQQkIAEJIOABCQgGQQk\nIAHJICABCUgGAQlIQDIISEACkkFAAhKQDAISkIBkEJCABCSDgAQkIBkEJCABySAgAQlIBgEJ\nSEAyCEhAApJBQAISkAwCEpCAZBCQgAQkg4AEJCAZBCQgAckgIAEJSAYBCUhAMghIQAKSQUAC\nEpAMAhKQgGQQkIAEJIOABCQgGQQkIAHJICABCUgGAQlIQDIISEACkkFAAhKQDAISkIBkEJCA\nBCSDgAQkIBkEJCABySAgAQlIBgEJSPmqyVetb8p7ny5UF2bVN4aYrQ+z6htCzDaEWS22jYLy\ndXl/QNaQqiryVOkb892lK1UFWa32DSFma+qDrPq6ELN1YVaLbaOgkrxbG0PiqV2CeGrHUzsg\nGQQkIAHJICABCUgGAQlIQDIISEACkkFAAhKQDAISkIBkEJCABCSDgAQkIBkEJCABySAgAQlI\nBgEJSEAyCEhAApJBQAISkAwCEpCAZBCQgAQkg4AEJCAZBCQgAckgIAEJSAYBCUhAMghIQAKS\nQUACEpAMAhKQgGQQkIAEJIOABCQgGQQkIAHJICABCUgGAQlIQDIISEACkkFAAhKQDAISkIBk\nEJCABCSDgAQkIBkEJCABySAgAQlIBgEJSEAyCEhAApJBQAISkAwCEpCAZBCQgAQkg4AEJCAZ\nBCQgAckgIAEJSAYBCUhAMghIQAKSQUACEpAMAhKQgGQQkIAEJIOABCQgGQQkIAHJICABCUgG\nAQlIQDIISEACkkFAAhKQDAISkIBkEJCABCSDgAQkIBkEJCABySAgAQlIBgEJSEAyCEhAApJB\nQAISkAwCEpCAZBCQgAQkg4AEJCAZBCQgAckgIAEJSAYBCUhAMghIQAKSQUACEpAMAhKQgGQQ\nkIAEJIOABCQgGQQkIAHJICABCUgGAQlIQDIISEACkkFAAhKQDAISkIBkEJCABCSDgAQkIBkE\nJCABySAgAQlIBgEJSEAyCEhAApJBQAISkAwCEpCAZBCQgAQkg4AEJCAZBCQgAckgIAEJSAYB\n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\nbye+O39FiMggIBEZBCQig4BEZBCQiAwCEpFBQCIyCEhEBgGphLrBDc/+Xdphpxb5TKh9QCqh\nbnDup5krbSGt5Bex+PFrUELd0PdL+74TX2kL6VZ+EYsfvwYl1A3u1b6T4isZSA+fuFffw25u\n8V90zg3z/q5j+/Ufdlf0+vXnH9TnA18rnX8PZdcISCXUDa5upvuzz0K6v8dpDzw2zX3Lvzra\nrXjJ/86dsXjxaW6x98MH3b7sziP2ry722aYrIJVQN7jauo9+oiELaehB9dGrTu+1yZ8X/yLO\n+Vz0Yvnu4325uzp68fU564p8sikLSCVUBMk/4m7MQFrnLopftTD6GHTeu7+IB57oG9538GPN\nRTvF1AakEiqG5M/c440Y0rNuVvyqh92CLKTy7xy+d8+eboT3T37IvW/MnY1FPte0BaQSKgNp\nbf9R/phT/Qo3M37VQ+72LKSTel77xPMvDI4g+abHr/qEO6ZU/s3IXSQglVAZSP5mt+i4U/0G\nd0H8qgVuSQbSa25K9FJj3xGtd73N/bJop5nKgFRCZSE1HnHw8ad6f/jg+IXT9ij357tG/1Lm\nA9Stbrh/bmz8Xwi/7uYV91zTFpBKqCwk/2SPHhGkh3b7wqI/ftPN9f56N/PehiEfXPTklaec\n0n/Z6/2PXPjo747f+/Vin226AlIJ1QrJT3bxH8guPWHPPkf/PLry1tG9DvUrjtvjAxeWPzhw\n31f+dsb+vQaf8deinmn6AhKRQUAiMghIRAYBicggIBEZBCQig4BEZBCQiAwCEpFBQCIyCEhE\nBgGJyKD/A8hbAP2bcKX3AAAAAElFTkSuQmCC"
          },
          "metadata": {
            "image/png": {
              "width": 420,
              "height": 420
            }
          }
        }
      ]
    }
  ]
}