1.startup.batを実行

2.createDBandApp.batを実行
 1を選択した場合、サンプルアプリは任意で作成できます。  
 --以下実行例-- 
 docker-compose exec web bash  
 rails g scaffold Member Name:string Sex:string  
 rails db:migrate  
 rails s -b 0.0.0.0  
 
3.localhost:3000、localhost:3000/membersにアクセス
