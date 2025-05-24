#----------------------------------------------------------------------------------------------
pre requisite:

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
sudo chown -R $(id -u):$(id -g) ./run ./tmp

#----------------------------------------------------------------------------------------------
# build image
docker compose build --no-cache
docker compose up

or 
#----------------------------------------------------------------------------------------------
     
# run the fuseki server as normal java application
java -jar fuseki-server.jar

#----------------------------------------------------------------------------------------------
# this is to run bulk import using tdb2 loader in windows
  set JENAROOT=C:\Users\deepa\data\workspace\github\apache-jena-5.4.0\apache-jena-5.4.0
  set JENA_HOME=C:\Users\deepa\data\workspace\github\apache-jena-5.4.0\apache-jena-5.4.0
  set PATH=%PATH%;%JENA_HOME%\bin
  set PATH=%PATH%;%JENA_HOME%\bat

C:\Users\deepa\data\workspace\github\apache-jena-5.4.0\apache-jena-5.4.0\bat>
sparql.bat --version
tdb2_tdbstats.bat  --help

tdb2_tdbstats.bat ^
--verbose ^ 
--loader=parallel ^
--loc="C:\Users\deepa\data\workspace\github\jena-fuseki-docker-5.4.0\databases\myDataset-05" ^
--graph="https://www.sw.org/dpbedia/data" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\instance-types_lang=en_specific.ttl" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\instance-types_lang=en_transitive.ttl" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-literals_lang=en.ttl" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-objects_lang=en.ttl" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-objects_lang=en_disjointDomain.ttl" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-objects_lang=en_disjointRange.ttl" ^
"C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\specific-mappingbased-properties_lang=en.ttl"

#----------------------------------------------------------------------------------------------
# this is to run bulk import using tdb2 loader in linux (working)
  export JENAROOT=C:\\Users\\deepa\\data\\workspace\\github\\jena-fuseki-docker-5.4.0\\apache-jena-5.4.0
  export JENA_HOME=C:\\Users\\deepa\\data\\workspace\\github\\jena-fuseki-docker-5.4.0\\apache-jena-5.4.0
  export PATH=$PATH:$JENA_HOME\\bin

  cd /c/Users/deepa/data/workspace/github/jena-fuseki-docker-5.4.0/apache-jena-5.4.0/bat

  sparql.bat --version

  tdb2_tdbloader.bat \
    --verbose \
    --loader=parallel \
    --loc="C:\Users\deepa\data\workspace\github\jena-fuseki-docker-5.4.0\databases\dbpedia-21-05-2025" \
    --graph="https://www.sw.org/dpbedia/data" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\instance-types_lang=en_specific.ttl\instance-types_lang=en_specific.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\instance-types_lang=en_transitive.ttl\instance-types_lang=en_transitive.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\mappingbased-literals_lang=en.ttl\mappingbased-literals_lang=en.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\mappingbased-objects_lang=en.ttl\mappingbased-objects_lang=en.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\mappingbased-objects_lang=en_disjointDomain.ttl\mappingbased-objects_lang=en_disjointDomain.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\mappingbased-objects_lang=en_disjointRange.ttl\mappingbased-objects_lang=en_disjointRange.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-21-05-2025-data\specific-mappingbased-properties_lang=en.ttl\specific-mappingbased-properties_lang=en.ttl"

  tdb2_tdbquery.bat \
    --verbose \
    --loc="C:\Users\deepa\data\workspace\github\jena-fuseki-docker-5.4.0\databases\myDataset-05" \
    "SELECT ?s ?p ?o WHERE { GRAPH <https://www.sw.org/dpbedia/data> { ?s ?p ?o } } LIMIT 10"

#----------------------------------------------------------------------------------------------
# run from outside the docker container:
docker exec -it 3c08cf88e317 \
  sh -c '/opt/jena/bin/tdb2.tdbloader \
         --verbose \
         --loader=parallel \
         --loc=/fuseki/run/databases/mydatabase.ttl \
         --graph=https://www.sw.org/doid/ontology \
         /fuseki/tmp/doid.owl'

#----------------------------------------------------------------------------------------------
# main directory from where all the commands are running in docker: 
/fuseki # pwd
/fuseki

/fuseki # /opt/jena/bin/sparql --version
Apache Jena version 5.4.0

/fuseki # /opt/jena/bin/tdb2.tdbloader --help

/opt/jena/bin/tdb2.tdbloader \
--verbose \
--debug \
--loader=parallel \
--loc="run/databases/mydataset-02" \
--graph="https://www.sw.org/doid/ontology" \
"tmp/doid.owl"

/opt/jena/bin/tdb2.tdbstats \
--verbose \
--debug \
--loc="run/databases/myDataset_v02_5-10-2025" \
--graph="https://www.sw.org/doid/ontology"

/opt/jena/bin/tdb2.tdbquery \
--verbose \
--debug \
--loc="run/databases/myDataset_v02_5-10-2025" \
"SELECT ?s ?p ?o WHERE { GRAPH <https://www.sw.org/doid/ontology> { ?s ?p ?o } } LIMIT 10"

#----------------------------------------------------------------------------------------------

# from outside the running container
    - docker exec -it 8282e244ec78 tdb2.tdbstats --loc=/fuseki/run/databases/myDataset_bulk_load_5-10-2025
    - docker exec -it 8282e244ec78 tdb2.tdbstats --loc=/fuseki/run/databases/myDataset_v04_5-10-2025

    ## didn't worked
        - docker exec -it 8282e244ec78 tdb2.tdbloader --loc=/fuseki/run/databases/myDataset_bulk_load_5-10-2025 --graph=https://www.sw.org/ontology/doid /tmp/doid.owl
         
        - docker-compose exec fuseki tdb2.tdbloader \
            --loc=/fuseki/run/databases/myDataset_bulk_load_5-10-2025 \
            --graph=https://www.sw.org/ontology/doid \
            /fuseki/tmp/doid.owl
    
    ## this worked
        - export MSYS_NO_PATHCONV=1
        
        - docker-compose run --rm fuseki tdb2.tdbloader \
        --loc=/fuseki/run/databases/myDataset_bulk_load_5-10-2025 \
        --graph=https://www.sw.org/ontology/doid \
        --loader=parallel /fuseki/tmp/doid.owl

        - docker compose run --rm fuseki tdb2.tdbstats \
          --loc=/fuseki/run/databases/myDataset_bulk_load_5-10-2025

        $  docker compose run --rm fuseki sh
#----------------------------------------------------------------------------------------------
# build jena index
java -cp $FUSEKI_HOME/fuseki-server.jar jena.textindexer --desc=assembler_file

  cd ~/data/workspace/github/jena-fuseki-docker-5.4.0 
  java -cp fuseki-server.jar jena.textindexer -desc=config-w.ttl


#----------------------------------------------------------------------------------------------