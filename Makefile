build:
	./build_docs.sh master dev
	./build_docs.sh release-0.10 0.10
	./build_docs.sh release-0.9 0.9

server:
	./start.sh

.PHONY: build server
