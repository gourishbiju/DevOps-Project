.PHONY: build push run tf-init tf-apply deploy-local

IMAGE=your_dockerhub_username/devops-demo
TAG=local

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

run:
	docker run --rm -p 5000:5000 $(IMAGE):$(TAG)

tf-init:
	cd terraform && terraform init

tf-apply:
	cd terraform && terraform apply -var "key_name=YOUR_KEY_NAME"
