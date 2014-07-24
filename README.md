simple_crm
==========
## 如何启动
1. git clone git@github.com:souche/simple_crm.git
2. cd simple_crm
3. bundle install
4. bundle exec rake db:drop db:create db:migrate
5. bundle exec rake db:seed
6. thin start -e production