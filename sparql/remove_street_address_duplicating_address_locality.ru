PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?postalAddress schema:streetAddress ?addressLocality .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?postalAddress a schema:PostalAddress ;
      schema:streetAddress ?addressLocality ;
      schema:addressLocality ?addressLocality .
  }
}
