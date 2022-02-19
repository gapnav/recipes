rm ./log/*
rake tmp:clear

rake db:migrate:reset db:seed
