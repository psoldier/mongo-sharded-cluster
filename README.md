# mongo-sharded-cluster

######################################################################################
1)Install RVM
  ~$  sudo apt-get update
  ~$  sudo apt-get install ....
2)Install gems
  ~$  bundle install
4)Run application
  ~$ rackup



#mongo --host ip_host
#use tesina
#db.createCollection("archivos")
#show dbs
#show collections

Load DB 
wget --random-wait -r -p -e robots=off -U mozilla http://en.wikipedia.org/wiki/Lionel_Messi

Mv only files
find . -type f -size -16M -exec mv {} /home/postgrado/psoldier/pablo/ \;
find . -type f -size -16M -exec mv {} /home/postgrado/psoldier/wikifiles/ \;

gcp -rv wiki2 /home/postgrado/psoldier/wiki2/

wget --random-wait -r -p -e robots=off -U mozilla https://es.wikipedia.org/wiki/Wikipedia:Efem%C3%A9rides


En promedio: 
21G...............231794 archivos.................7,4G
60G...............657793 archivos.................21G

Si ya tengo 21-> me van a faltar 40G


UTF8 FILENAMES

find . -type f -print0 | \
perl -n0e '$new = $_; if($new =~ s/[^[:ascii:]]/_/g) {
  print("Renaming $_ to $new\n"); rename($_, $new);
}'