@echo off
echo 1.create only DB
echo 2.create DB and sampleApp
echo please select 1 or 2
@REM 入力要求

set /p "USER_INPUT=your select... "

if %USER_INPUT% == 1 (
    docker-compose exec web rails db:create
) else if %USER_INPUT% == 2 (
    @REM DBの準備~アプリの項目作成~サーバ起動が書かれたshファイル読み込み
    docker-compose exec web bash ./startup.sh
) else (
    echo please select 1 or 2
)