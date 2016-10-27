PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>

DELETE {
  GRAPH ?g {
    ?address ruian:cisloOrientacni "" .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address ruian:cisloOrientacni "" .
  }
}
