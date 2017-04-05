#The below command needs to be run on the master (or a device authorized to query
#the puppetDB for all exported resources).  It calls up the API of the master
#to find all exported resources stored in the database. Fine tuning can be done via
# the --data-urlencode flag using classic puppet query language.
/usr/bin/curl -s -X GET \
--cert $(puppet config print hostcert) \
--key $(puppet config print hostprivkey) \
--cacert $(puppet config print cacert) \
--data-urlencode 'query=[ "=", "exported", true ]' \
"https://$(puppet config print server):8081/pdb/query/v4/resources"
