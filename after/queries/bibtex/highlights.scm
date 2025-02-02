; extends

(field
  name: (identifier) @_
  (#match? @_ "^(title|address|institution|journal|keywords|)$")
  value: (value (token) @spell))
