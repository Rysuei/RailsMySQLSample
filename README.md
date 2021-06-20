1.startup.batを実行

2.createDBandApp.batを実行  
 DBのみ作成するか、DBとデフォルトのサンプルアプリを作成するか選択できます。  
 DBのみを選択した場合、サンプルアプリは任意で作成できます。  
 --以下サンプルアプリ作成の実行例--  
 コンテナに入る  
 docker-compose exec web bash  
 サンプルアプリの簡易作成 rails g scaffold 見出し 項目名1:型 項目名2:型...  
 rails g scaffold Member Name:string Sex:string  
 DBマイグレーション  
 rails db:migrate  
 サーバ起動  
 rails s -b 0.0.0.0  
 
3.localhost:3000、localhost:3000/membersにアクセス  
/membersはrails g scaffoldコマンドで決めたサンプルアプリの見出し（Member）とリンク
