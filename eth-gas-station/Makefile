SHELL=/bin/bash

export REGISTRY_HOST ?= asia.gcr.io
export GOOGLE_PROJECT ?= xyz-admin

export ETHGASSTATION_API_TAG ?= $(shell git --git-dir ./ethgasstation-api/.git rev-parse HEAD)
export ETHGASSTATION_BACKEND_TAG ?= $(shell git --git-dir ./ethgasstation-backend/.git rev-parse HEAD)

export ETHGASSTATION_API_REPOSITORY ?= $(REGISTRY_HOST)/$(GOOGLE_PROJECT)/ethgasstation-api
export ETHGASSTATION_BACKEND_REPOSITORY ?= $(REGISTRY_HOST)/$(GOOGLE_PROJECT)/ethgasstation-backend

authenticate-docker:
	gcloud auth configure-docker

build-images:
	docker build ethgasstation-api -t '$(ETHGASSTATION_API_REPOSITORY):$(ETHGASSTATION_API_TAG)'
	docker build ethgasstation-backend -t '$(ETHGASSTATION_BACKEND_REPOSITORY):$(ETHGASSTATION_BACKEND_TAG)'

push-images: authenticate-docker build-images
	docker push $(ETHGASSTATION_API_REPOSITORY):$(ETHGASSTATION_API_TAG)
	docker push $(ETHGASSTATION_BACKEND_REPOSITORY):$(ETHGASSTATION_BACKEND_TAG)

install-helm:
	helm install charts/eth-gas-station --name gas-station --debug\

		--set image.ethgasstation_api.repository=$(ETHGASSTATION_API_REPOSITORY) \
		--set image.ethgasstation_api.tag=$(ETHGASSTATION_API_TAG) \
		--set image.ethgasstation_backend.repository=$(ETHGASSTATION_BACKEND_REPOSITORY) \
		--set image.ethgasstation_backend.tag=$(ETHGASSTATION_BACKEND_TAG)

upgrade-helm:
	helm upgrade gas-station charts/eth-gas-station --debug\
		--set image.ethgasstation_api.repository=$(ETHGASSTATION_API_REPOSITORY) \
		--set image.ethgasstation_api.tag=$(ETHGASSTATION_API_TAG) \
		--set image.ethgasstation_backend.repository=$(ETHGASSTATION_BACKEND_REPOSITORY) \
		--set image.ethgasstation_backend.tag=$(ETHGASSTATION_BACKEND_TAG)
