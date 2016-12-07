PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>

DELETE {
  GRAPH ?g {
    ?address ruian:cisloOrientacniPismeno ?_orientationalNumberLetter .
  }
}
INSERT {
  GRAPH ?g {
    ?address ruian:cisloOrientacniPismeno ?orientationalNumberLetter .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address ruian:cisloOrientacniPismeno ?_orientationalNumberLetter .
    FILTER (?_orientationalNumberLetter = UCASE(?_orientationalNumberLetter))
    BIND (LCASE(?_orientationalNumberLetter) AS ?orientationalNumberLetter)
  }
}
