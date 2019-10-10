ifndef SWAGGER_UI_PORT
    SWAGGER_UI_PORT := 8080
endif

ifndef PYTHON
    PYTHON := python3.7
endif

.PHONY: clean
clean:
	rm -rf venv

.PHONY: development
minimal development: venv install-hooks
	@true

.PHONY: install-hooks
install-hooks: venv
	./venv/bin/pre-commit install -f --install-hooks

venv: requirements.txt
	virtualenv venv --python=${PYTHON}
	./venv/bin/pip install -r requirements.txt

.PHONY: convert_to_json
convert_to_json: $(patsubst %.yaml,%.json,$(wildcard *.yaml))
	@true

specs_v%.json: venv specs_v%.yaml yaml_to_json.py
	${CURDIR}/venv/bin/python ${CURDIR}/yaml_to_json.py '$(basename $@).yaml' $@

.PHONY: swagger-ui
swagger-ui: convert_to_json
	docker run \
	--publish ${SWAGGER_UI_PORT}:8080 \
	--volume ${CURDIR}:/usr/share/nginx/html/specs:ro \
	swaggerapi/swagger-ui
