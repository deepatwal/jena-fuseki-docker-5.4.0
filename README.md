
#----------------------------------------------------------------------------------------------
# this is to run bulk import using tdb2 loader
                /c/Users/deepa/data/workspace/github/apache-jena-5.4.0/apache-jena-5.4.0
export JENAROOT=C:\Users\deepa\data\workspace\github\apache-jena-5.4.0\apache-jena-5.4.0
export JENA_HOME=C:\Users\deepa\data\workspace\github\apache-jena-5.4.0\apache-jena-5.4.0
export PATH=$PATH:$JENA_HOME/bin

deepa@illusion MINGW64 ~/data/workspace/github/apache-jena-5.4.0/apache-jena-5.4.0/bat
  $ ./sparql.bat --version

  $ ./tdb2_tdbstats.bat \
    --verbose \
    --loc="C:/Users/deepa/data/workspace/github/apache-jena-fuseki-5.4.0/apache-jena-fuseki-5.4.0/run/databases/myDataset_v02_5-10-2025" \
    --graph="https://www.sw.org/ontology/doid"
 
  $ ./tdb2_tdbloader.bat \
    --verbose \
    --loader=parallel \
    --loc="C:/Users/deepa/data/workspace/github/apache-jena-fuseki-5.4.0/apache-jena-fuseki-5.4.0/run/databases/myDataset_v02_5-10-2025" \
    --graph="https://www.sw.org/dpbedia/data" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\instance-types_lang=en_specific.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\instance-types_lang=en_transitive.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-literals_lang=en.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-objects_lang=en.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-objects_lang=en_disjointDomain.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\mappingbased-objects_lang=en_disjointRange.ttl" \
    "C:\Users\deepa\data\workspace\notebooks\datasets\dbpedia-14-04-2025-data\specific-mappingbased-properties_lang=en.ttl"

  $ ./tdb2_tdbquery.bat \
    --verbose \
    --loc="C:/Users/deepa/data/workspace/github/apache-jena-fuseki-5.4.0/apache-jena-fuseki-5.4.0/run/databases/myDataset_v02_5-10-2025" \
    "SELECT ?s ?p ?o WHERE { GRAPH <https://www.sw.org/ontology/doid> { ?s ?p ?o } } LIMIT 10"

#----------------------------------------------------------------------------------------------
     
# run the fuseki server
java -jar fuseki-server.jar

#----------------------------------------------------------------------------------------------

docker compose build --no-cache
docker compose up

#----------------------------------------------------------------------------------------------

/opt/apache-jena-5.4.0 $ sparql --version
Apache Jena version 5.4.0

/opt/apache-jena-5.4.0 $ tdb2.tdbloader --help

tdb2.tdbstats --loc=/fuseki/run/databases/myDataset_bulk_load_5-10-2025
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