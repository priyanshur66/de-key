run:
	docker run --rm -d -p 8080:8080 plantuml/plantuml-server:tomcat

.PHONY: render
render:
	rm -rf render
	docker run --rm -v ${PWD}/:/flows/ plantuml/plantuml -svg -o /flows/render/ /flows/
	docker run --rm -v ${PWD}/:/flows/ -e PLANTUML_LIMIT_SIZE=16384 plantuml/plantuml -png -o /flows/render/ /flows/
