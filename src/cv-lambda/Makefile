BUILD_PATH=../../build
BINARY_NAME=cv-lambda

build:
	GOARCH=arm64 GOOS=linux go build -o ${BUILD_PATH}/${BINARY_NAME}

run:
	${BUILD_PATH}/${BINARY_NAME}

clean:
	go clean
	rm ${BUILD_PATH}/${BINARY_NAME}
