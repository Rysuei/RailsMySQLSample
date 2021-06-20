@echo off

@REM rails new時にREADMEを強制上書きされないように一旦名前変更
rename README.md README.md.origin

@REM Railsセットアップの準備
docker-compose up -d --build
docker-compose exec web rails new . --force -d mysql --skip-bundle
docker-compose down

@REM 新しくできたREADME削除、元のREADMEに戻す
del README.md
rename README.md.origin README.md

@REM .\config\database.ymlにDB接続情報をセットするための準備
rename .\config\database.yml database.yml.origin
type nul > .\config\database.yml
set "BEFORE_DB_PASSWORD=  password^:"
set "AFTER_DB_PASSWORD=  password^: ^<%%= ENV.fetch^("DATABASE_PASSWORD"^) %%^>"
set "BEFORE_DB_HOST=  host^: localhost"
set "AFTER_DB_HOST=  host^: db"
set "DB_PORT=  port^: 3306"
set INPUT_DATABASE_YML=./config/database.yml.origin
set OUTPUT_DATABASE_YML=./config/database.yml

@REM ./config/database.ymlにDB接続情報セット
setlocal enabledelayedexpansion
for /f "delims=" %%a in (%INPUT_DATABASE_YML%) do (
    set line=%%a
    @REM 接続先DBのホスト名をコンテナ名のdbに変更
    if not "!line:host: localhost=!" == "!line!" (
        echo %AFTER_DB_HOST%>>%OUTPUT_DATABASE_YML%
        echo %DB_PORT%>>%OUTPUT_DATABASE_YML%
    ) else (
        @REM DBの接続パスワードを環境変数から取得するように変更
        if not "!line:  password:=!" == "!line!" (
            @REM 外側のIFだと2件ヒットするため、変更したい方をelseに抽出している
            if not "!line:RAILSMYSQLSAMPLE_DATABASE_PASSWORD=!" == "!line!" ( 
                echo !line!>>%OUTPUT_DATABASE_YML%
            ) else (
                echo %AFTER_DB_PASSWORD%>>%OUTPUT_DATABASE_YML%
            )
        @REM 特に変更がない行
        ) else (
            echo !line!>>%OUTPUT_DATABASE_YML%
        )
    )   
)
@REM database.yml.origin（元のdatabase.yml）削除
del .\config\database.yml.origin


@REM docker-compose.ymlの修正準備
set "REMOVE_STR=^# "
set "DEL="
rename docker-compose.yml docker-compose.yml.origin
type nul > docker-compose.yml
set INPUT_DOCKER_COMPOSE_YML=docker-compose.yml.origin
set OUTPUT_DOCKER_COMPOSE_YML=docker-compose.yml

@REM DBコンテナを作成するためdocker-compose.ymlのコメントアウト部分を戻す
setlocal enabledelayedexpansion
for /f "delims=" %%a in (%INPUT_DOCKER_COMPOSE_YML%) do (
    set line=%%a
    echo !line:%REMOVE_STR%=%DEL%!>>%OUTPUT_DOCKER_COMPOSE_YML%
)

@REM docker-compose.yml.origin（元のdocker-compose.yml）削除
del %INPUT_DOCKER_COMPOSE_YML%

@REM Rails・DBコンテナのビルド・立ち上げ
docker-compose up -d --build