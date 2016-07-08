PROC= src/json
OPT= -I src -use-menhir -tag thread -use-ocamlfind -pkg core


all: json parse

json:
	ocamlbuild $(OPT) $(PROC).native

parse: json
	ocamlbuild $(OPT) t/parse.native

type: parse
	cd _build; \
	ocamlfind ocamlc -i -c -thread -package core -I src src/json.ml; \
	ocamlfind ocamlc -i -c -thread -package core -I src t/parse.ml

clean:
	rm -rf _build *.native *.byte


.PHONY: all json parse type clean
