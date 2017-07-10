NAME	= appsoa/docker-s3
VERSION	= 0.0.1

.PHONY:	all build test tag_latest release ssh

all:	clean build

build:

	@echo "Building an image with the current tag $(NAME):$(VERSION).."
	@docker build -t $(NAME):$(VERSION) --rm .

clean:			docker-current-clean-images docker-current-clean-volumes
clean_global:	docker-global-clean-images

run:

	docker exec -it $(NAME):$(VERSION) /bin/sh

tag_latest:

	docker tag $(NAME):$(VERSION) $(NAME):latest

release:

	docker push $(NAME)

test:

	./test.sh $(NAME):$(VERSION)

docker-current-clean-images:

	@echo "Deleting image(s) with the current tag $(NAME):$(VERSION).."
	@docker images -a | grep $(NAME):$(VERSION) | xargs --no-run-if-empty docker rmi -f

docker-current-clean-volumes:

	@echo "Deleting volumes(s) with the current tag $(NAME):$(VERSION).."
	@docker volume ls -q | grep $(NAME):$(VERSION) | xargs -r docker volume rm || true


docker-global-clean-images:

	@echo "Deleting images that are not tagged.."
	@docker images -a | grep \<none\> | awk -F " " '{print $3}' | xargs --no-run-if-empty docker rmi -f

docker-images-list:

	@echo "Listing image(s) matching the current repo \"$(NAME)\" and the tag \"$(VERSION)\".."
	@docker images -a | grep $(NAME) | grep $(VERSION) || true

	@echo "Listing any other images matching current repo \"$(NAME)\":"
	@docker images -a | grep $(NAME) | grep -v $(VERSION) || true
	
asdf:

	@echo $(PWD)
	@echo $(dir $(realpath $(firstword $(MAKEFILE_LIST))))