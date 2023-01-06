BUILD_PATH=../../build/rebuild-front-lambda
BINARY_NAME=bootstrap

build:
	GOARCH=arm64 GOOS=linux go build -o ${BUILD_PATH}/${BINARY_NAME}

run:
	${BUILD_PATH}/${BINARY_NAME}

clean:
	go clean
	rm -f ${BUILD_PATH}/${BINARY_NAME}
	rm -f ${BUILD_PATH}/${BINARY_NAME}.zip
