all:
	@$(MAKE) -C ./src/cv-lambda
	@$(MAKE) -C ./src/rebuild-front-lambda

clean:
	@$(MAKE) -C ./src/cv-lambda clean
	@$(MAKE) -C ./src/rebuild-front-lambda clean
