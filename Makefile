#> build: build the docker image
build:
	 docker build -t mjladd/csound:latest .
.PHONY: build

#> shell: get a shell on the container to troubleshoot
shell:
	docker run -v $(pwd)/scores:/scores -it mjladd/csound /bin/bash
.PHONY: shell

makecsd:
	echo "TODO"
.PHONY: makecsd

.DEFAULT_GOAL = help

help:
	@echo ""
	@echo "🤖 I can help!"
	@echo ""
	@sed -n 's/^#>/ /p' $(MAKEFILE_LIST)
.PHONY: help
